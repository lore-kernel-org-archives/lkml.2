Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1GJUbC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:31:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48667 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab1GJUa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:30:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110710173530.GA16954@linux.vnet.ibm.com>
References: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com>
	<201107072047.14429.kernelmail.jms@gmail.com>
	<20110707195845.GD6014@linux.vnet.ibm.com>
	<201107072147.12751.kernelmail.jms@gmail.com>
	<20110708002903.GI6014@linux.vnet.ibm.com>
	<20110709100900.GB6014@linux.vnet.ibm.com>
	<CAAVPGOMe6NawfkNQ1pSGYe5a1=X0z_KcD5Dn_xDX55p3K_46nQ@mail.gmail.com>
	<20110710032510.GG6014@linux.vnet.ibm.com>
	<CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
	<20110710171626.GK6014@linux.vnet.ibm.com>
	<20110710173530.GA16954@linux.vnet.ibm.com>
Date: Sun, 10 Jul 2011 21:30:58 +0100
Message-ID: <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
From: julie Sullivan <kernelmail.jms@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But maybe not that much thought.  My current guess is that your
> configuration is somehow causing some RCU callbacks to be executed
> during early boot, and that these callbacks are attempting to use kernel
> features that are not yet initialized.  If my guess is correct, then
> the reason that enabling RCU_BOOST makes things work is that it prevents
> RCU callbacks from executing until after the scheduler is up and running.
>
> So I added another commit to the jms.2011.07.07a branch in the -rcu
> git tree.  If my guesses are correct, this will allow your system to
> boot, possibly emitting a warning on the way up.  When you get a chance
> to try this out, please let me know how it goes.
>
>                                                        Thanx, Paul

Fantastic, now we boot perfectly!
I also tried the same treatment on v3.0-rc5 and -rc6 (i.e. revert
f8b7fc6b514f34a51875 and a46e0899eec7a3069bcad then add those
8 commits from the jms.2011.07.07a branch) with the same success.

Thanks for giving me back 3.0-rc4, -rc5 and -rc6!

Cheers
Julie
