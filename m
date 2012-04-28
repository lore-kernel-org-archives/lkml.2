Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2D1Ws0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 18:48:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:36877 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab2D1WsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 18:48:25 -0400
Message-ID: <1335653288.20866.15.camel@pasglop>
Subject: Re: Regression in 32-bit ppc kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2012 08:48:08 +1000
In-Reply-To: <m2y5pflnqk.fsf@igel.home>
References: <4F973026.3020103@lwfinger.net>
	 <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>
	 <1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net>
	 <1335390257.21961.53.camel@pasglop> <4F9ABD67.3060704@lwfinger.net>
	 <1335565573.20866.7.camel@pasglop> <4F9B3398.9060701@lwfinger.net>
	 <1335573757.20866.12.camel@pasglop> <4F9C3252.7020508@lwfinger.net>
	 <m2y5pflnqk.fsf@igel.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 20:23 +0200, Andreas Schwab wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
> > I have done a little more debugging. The problem is definitely coming from
> > drivers/tty/serial/pmac_zilog.c. I am getting ChanB interrupts while open,
> > which causes the following code segment to return IRQ_NONE:
> >
> >        if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
> >                if (!ZS_IS_OPEN(uap_a)) {
> 
> s/uap_a/uap_b/?

Good catch... Let's see if that fixes it for Larry...

Cheers,
Ben.

