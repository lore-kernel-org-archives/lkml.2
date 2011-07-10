Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1GJSMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:12:38 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:42349 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab1GJSMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:12:34 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: state machine defect in drivers/tty/vt/vt.c?
References: <1310317919.3848.38.camel@Joe-Laptop>
X-Yow: I LIKE Aisle 7a.
Date: Sun, 10 Jul 2011 20:12:30 +0200
In-Reply-To: <1310317919.3848.38.camel@Joe-Laptop> (Joe Perches's message of
	"Sun, 10 Jul 2011 10:11:59 -0700")
Message-ID: <m2vcvac8dt.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> vc->vc_state is sequentially set to different values.
>
> Looks like there's either a return or a break
> missing at the end of case ESgetpars:
>
> Anyone know the right fix here?

The first assignment can be removed.

> 	case ESgetpars:
> 		if (c == ';' && vc->vc_npar < NPAR - 1) {
> 			vc->vc_npar++;
> 			return;
> 		} else if (c>='0' && c<='9') {
> 			vc->vc_par[vc->vc_npar] *= 10;
> 			vc->vc_par[vc->vc_npar] += c - '0';
> 			return;
> 		} else
> 			vc->vc_state = ESgotpars;
> 	case ESgotpars:
> 		vc->vc_state = ESnormal;

That handles cases like '\033[m' where '\033[' enters state ESgetpars,
but 'm' is handled by ESgotpars.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
