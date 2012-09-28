Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2I1KDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:03:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47410 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab2I1KDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:03:45 -0400
Date: Fri, 28 Sep 2012 11:08:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG_ON/panic proliferation.
Message-ID: <20120928110829.5ab03cfe@pyramind.ukuu.org.uk>
In-Reply-To: <5064F4E2.6010301@gmail.com>
References: <20120807134156.GP1996@amd.com>
	<20120927145217.GA18962@8bytes.org>
	<4FA345DA4F4AE44899BD2B03EEEC2FA908FEF572@SACEXCMBX04-PRD.hq.netapp.com>
	<20120927153928.GB18962@8bytes.org>
	<4FA345DA4F4AE44899BD2B03EEEC2FA908FEF7A3@SACEXCMBX04-PRD.hq.netapp.com>
	<CA+55aFx5CtDDpXTunJDtkDQWPX7sY0hYMRyekuPErC+s5yXpWw@mail.gmail.com>
	<20120927173057.GA13142@redhat.com>
	<5064F4E2.6010301@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove panic calls from drivers/tty/pty.c
>     
> There is no need to panic the system if the allocation/registration of
> the pty drivers fails. Instead return an error and fail the module load.
>     
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>

NAK

this is pointless complexity

This is early boot up code. If it fails we ran out of memory before even
the base drivers got running. It's already game over.

