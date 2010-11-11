Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0KKPPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:15:23 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:12670 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752518Ab0KKPPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:15:22 -0500
Date: Thu, 11 Nov 2010 16:15:20 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Kees Cook <kees.cook@canonical.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH v3 0/4] x86: clear XD_DISABLED flag on Intel to regain NX
Message-ID: <20101111151520.GA20168@bitwizard.nl>
References: <20101109181157.GE5876@outflux.net> <20101109183142.4ebfa737@lxorguk.ukuu.org.uk> <20101109185604.GK5876@outflux.net> <20101109225000.1b90e720@lxorguk.ukuu.org.uk> <20101109235314.GD5876@outflux.net> <20101110002153.7af92a1f@lxorguk.ukuu.org.uk> <20101110004347.GF5876@outflux.net> <20101110011039.GG5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110011039.GG5876@outflux.net>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 05:10:39PM -0800, Kees Cook wrote:
> AG29. #GP Fault is Not Generated on Writing IA32_MISC_ENABLE [34]
>       When Execute Disable (XD) is Not Supported
> Problem: A #GP fault is not generated on writing to IA32_MISC_ENABLE [34]
>          bit in a processor which does not support Execute Disable (XD)
>          functionality.
> Implication: Writing to IA32_MISC_ENABLE [34] bit is silently ignored
>              without generating a fault.
> Workaround: None identified.
> Status: For the steppings affected, see the Summary Tables of Changes.
 
> But this case is already handled (and doesn't matter) because my
> patch already avoids this (we only clear IA32_MISC_ENABLE, not set
> it).

Ehhh. A Virtual machine monitor may need to be notified of your
"clearing" that bit. The erratum is correctly worded as for "writing"
not "setting".

But that bug is intel's problem. Not yours. 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
