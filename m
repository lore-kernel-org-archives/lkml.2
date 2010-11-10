Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0KJBMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:12:06 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54551 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab0KJBMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:12:03 -0500
Date: Tue, 9 Nov 2010 17:10:39 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH v3 0/4] x86: clear XD_DISABLED flag on Intel
 to regain NX
Message-ID: <20101110011039.GG5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109183142.4ebfa737@lxorguk.ukuu.org.uk>
 <20101109185604.GK5876@outflux.net>
 <20101109225000.1b90e720@lxorguk.ukuu.org.uk>
 <20101109235314.GD5876@outflux.net>
 <20101110002153.7af92a1f@lxorguk.ukuu.org.uk>
 <20101110004347.GF5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110004347.GF5876@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Tue, Nov 09, 2010 at 04:43:47PM -0800, Kees Cook wrote:
> I looks like there is nothing that actually lists errata directly, so
> walking the entire site for lists of all processor types, e.g.:
> http://www.intel.com/products/processors/previousgeneration/index.htm
> http://www.intel.com/design/celeron/documentation.htm
> and then checking spec updates is the only way to go.
> 
> I will report if I find anything bad.

I have reviewed all the spec updates for all the processors I could find
(for a total of 45 PDFs). The only mention of XD is for the Dual-Core Xeon
5100[1]:

AG29. #GP Fault is Not Generated on Writing IA32_MISC_ENABLE [34]
      When Execute Disable (XD) is Not Supported
Problem: A #GP fault is not generated on writing to IA32_MISC_ENABLE [34]
         bit in a processor which does not support Execute Disable (XD)
         functionality.
Implication: Writing to IA32_MISC_ENABLE [34] bit is silently ignored
             without generating a fault.
Workaround: None identified.
Status: For the steppings affected, see the Summary Tables of Changes.

But this case is already handled (and doesn't matter) because
my patch already avoids this (we only clear IA32_MISC_ENABLE, not set it).

So, based on that, there doesn't seem to be an errata related to _needing_
to disable the XD cpu feature.

-Kees

[1] ftp://download.intel.com/design/Xeon/specupdt/313356.pdf

-- 
Kees Cook
Ubuntu Security Team
