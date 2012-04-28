Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2D1SXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 14:23:25 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55948 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2D1SXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 14:23:24 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 32-bit ppc kernel
References: <4F973026.3020103@lwfinger.net>
	<1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>
	<1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net>
	<1335390257.21961.53.camel@pasglop> <4F9ABD67.3060704@lwfinger.net>
	<1335565573.20866.7.camel@pasglop> <4F9B3398.9060701@lwfinger.net>
	<1335573757.20866.12.camel@pasglop> <4F9C3252.7020508@lwfinger.net>
X-Yow: Place me on a BUFFER counter while you BELITTLE several BELLHOPS
 in the Trianon Room!!  Let me one of your SUBSIDIARIES!
Date: Sat, 28 Apr 2012 20:23:15 +0200
In-Reply-To: <4F9C3252.7020508@lwfinger.net> (Larry Finger's message of "Sat,
	28 Apr 2012 13:09:22 -0500")
Message-ID: <m2y5pflnqk.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.96 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> I have done a little more debugging. The problem is definitely coming from
> drivers/tty/serial/pmac_zilog.c. I am getting ChanB interrupts while open,
> which causes the following code segment to return IRQ_NONE:
>
>        if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
>                if (!ZS_IS_OPEN(uap_a)) {

s/uap_a/uap_b/?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
