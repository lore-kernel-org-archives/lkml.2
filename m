Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab2KTXlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:41:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40571 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752489Ab2KTXlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:41:15 -0500
Message-ID: <1353454874.17819.41.camel@joe-AO722>
Subject: Re: [PATCH v2] checkpatch: add double empty line check
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Eilon Greenstein <eilong@broadcom.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date: Tue, 20 Nov 2012 15:41:14 -0800
In-Reply-To: <20121120231930.GA27492@localhost>
References: <1353151057.14327.18.camel@lb-tlvb-eilong.il.broadcom.com>
	 <20121120115239.GA7955@dm> <1353448728.17819.33.camel@joe-AO722>
	 <20121120231930.GA27492@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 23:19 +0000, Andy Whitcroft wrote:
> On Tue, Nov 20, 2012 at 01:58:48PM -0800, Joe Perches wrote:
> 
> > +# check for multiple blank lines, warn only on the second one in a block
> > +		if ($rawline =~ /^.\s*$/ &&
> > +		    $prevrawline =~ /^.\s*$/ &&
> > +		    $linenr != $last_blank_linenr + 1) {
> > +			CHK("DOUBLE_EMPTY_LINE",
> > +			    "One blank line separating blocks is generally sufficient\n" . $herecurr);
> > +			$last_blank_linenr = $linenr;
> > +		}
> > +
> >  # check for line continuations in quoted strings with odd counts of "
> >  		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
> >  			WARN("LINE_CONTINUATIONS",
> 
> Pretty sure that will fail with combination which have removed lines.

Not as far as I can tell.
Deleted lines followed by inserted lines seem
to work OK.

This check is located after the test that ensures
the current $line/$rawline is an insertion.

> I have a version here which I am testing with the combinations I have
> isolated to far ...

Enjoy.
Can you please test my proposal against those combinations too?

cheers, Joe


