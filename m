Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2KTXTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:19:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2KTXTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:19:38 -0500
Date: Tue, 20 Nov 2012 23:19:30 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Eilon Greenstein <eilong@broadcom.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] checkpatch: add double empty line check
Message-ID: <20121120231930.GA27492@localhost>
References: <1353151057.14327.18.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120115239.GA7955@dm>
 <1353448728.17819.33.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353448728.17819.33.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 01:58:48PM -0800, Joe Perches wrote:

> +# check for multiple blank lines, warn only on the second one in a block
> +		if ($rawline =~ /^.\s*$/ &&
> +		    $prevrawline =~ /^.\s*$/ &&
> +		    $linenr != $last_blank_linenr + 1) {
> +			CHK("DOUBLE_EMPTY_LINE",
> +			    "One blank line separating blocks is generally sufficient\n" . $herecurr);
> +			$last_blank_linenr = $linenr;
> +		}
> +
>  # check for line continuations in quoted strings with odd counts of "
>  		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
>  			WARN("LINE_CONTINUATIONS",

Pretty sure that will fail with combination which have removed lines.  I
have a version here which I am testing with the combinations I have
isolated to far ...

-apw
