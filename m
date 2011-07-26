Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab1GZKQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 06:16:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38368 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752491Ab1GZKQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 06:16:44 -0400
Date: Tue, 26 Jul 2011 11:19:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Ryan Mallon <rmallon@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: Re: GMA500: ERROR: "__bad_udelay" undefined!
Message-ID: <20110726111927.129270f7@lxorguk.ukuu.org.uk>
In-Reply-To: <CAMeQTsY3T5sPCRYzf8-Xca8y_mWjXSUOOptxHZ2YK5YNL0uvuw@mail.gmail.com>
References: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net>
	<4E2CC55B.5010307@gmail.com>
	<4E2CC6CC.5020204@gmail.com>
	<62472696.BtqhiR95vr@wuerfel>
	<20110725224250.7d6edb83@bob.linux.org.uk>
	<CAMeQTsY3T5sPCRYzf8-Xca8y_mWjXSUOOptxHZ2YK5YNL0uvuw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Don't know yet - its on the fixme list to dig into - I think the answer
> > is some cases but not all.
> 
> IMO, it should be replaced with actually waiting for the vblank and not an
> arbitrary time. I think this is fine as long as we don't use it when waiting for
> a pipe to disable. And I guess we could sleep while waiting for vblank.

Opinions are cheap, generating a list of all the paths through the tree
that can hit vblank waits is alas not, neither is verifying it on a pile
of real hardware 8(

Plus none of the Intel issued IMG drivers wait for a vblank event and in
several cases it's quite clear that there is *no* vblank that can be
waited for at that point, eg look at the MIPI interfaces.

So unfortunately it's rather complicated to fix although working them
through to make some of the msleeps is certainly doable - add a
sleep_for_vblank() or similar and send patches as you verify each one is
ok and test it perhaps ?

Alan
