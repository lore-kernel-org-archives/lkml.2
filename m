Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2KHLOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:14:44 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44120 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab2KHLOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:14:42 -0500
Date: Thu, 8 Nov 2012 11:19:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Olivier Galibert <galibert@pobox.com>,
        Florian Weimer <fw@deneb.enyo.de>,
        Chris Friesen <chris.friesen@genband.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Josh Boyer <jwboyer@gmail.com>,
        LKML Mailing List <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121108111928.27911a63@pyramind.ukuu.org.uk>
In-Reply-To: <CAAMvbhFF=kb8TJ4oE+40Zrx7HD1OkD0NOYj7QEZegZKGtqDm_A@mail.gmail.com>
References: <87fw4nv1vj.fsf@xmission.com>
	<20121106035352.GA24698@srcf.ucam.org>
	<87hap3s3yl.fsf@xmission.com>
	<878vafqi5q.fsf@mid.deneb.enyo.de>
	<50992946.4060101@genband.com>
	<87625iwgao.fsf@mid.deneb.enyo.de>
	<7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com>
	<20121106224920.3b9d4a86@pyramind.ukuu.org.uk>
	<a35e035b-de9d-4253-9e7d-ae1f1c2e2f88@email.android.com>
	<CAMFK0gt7oAr4ArD8FmD8QE+i4g4rSTmQjbbLcjs02xwQeXGx-A@mail.gmail.com>
	<20121107145518.GB30662@srcf.ucam.org>
	<CAAMvbhFF=kb8TJ4oE+40Zrx7HD1OkD0NOYj7QEZegZKGtqDm_A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You have a fair chance of protecting via physical means (Locked rooms,
> Background checks on users etc.) of preventing a user with malicious intent
> to access the local machine.

So called "secure boot" doesn't deal with any kind of physical access,
which also means its useless if a device is lost and returned and you
don't know if it was in the hands of a third party.

> The first thing a computer does when switched on is run its first code
> instructions. Commonly referred to as the BIOS.

A good deal more complicated than that. However the signing in hardware
and early boot up on a lot of devices already goes as far as the BIOS if
the system has BIOS or EFI if it doesn't. You also have all the devices
to deal with.

> Normally digital signatures would examine the binary, ensure the signature
> matches, and then run the code contained in it.

No - it's a good deal more complicated than that too.
