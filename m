Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2GXK2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:28:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45736 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2GXK2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:28:46 -0400
Date: Tue, 24 Jul 2012 11:32:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Borislav Petkov <bp@amd64.org>
Cc: Andre Przywara <andre.przywara@amd.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Message-ID: <20120724113204.7f48efe6@pyramind.ukuu.org.uk>
In-Reply-To: <20120724095031.GA24393@aftab.osrc.amd.com>
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
	<dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
	<20120721103715.GA3632@aftab.osrc.amd.com>
	<500E4960.8040307@parallels.com>
	<500E5951.5020900@amd.com>
	<20120724095031.GA24393@aftab.osrc.amd.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So actually, making it straightforward to disable CPUID feature bits
> just for every whim is the bug.

Sometimes its needed to make stuff work. Expecting user space to go
digging in odd places isn't good either but exposing *both* true/apparent
cpuid bits might not be a bad idea.

> I'd like to see a real valid reason why someone would even think that.
> Except virtualization folks who are crazy anyway, so that doesn't count :).

Which is a very large part of the x86 market. So they most definitely do
count. Virtualisation is somewhat different though. There you are trying
to define a subset of the features that all the systems in your
environment have so you can do migrations. Virtualisation you have rather
more different control of the cpuid and msrs anyway.

> Majority of users is majority of users no matter how you look at it!

That's not a good argument. The majority of users don't have SCSI,
certain processors and so on ...

> Right, and how is giving the user a heavy, well-oiled AK-47 to do that,
> user-friendly?

It's a point and click interface

> And this is exactly what I'm questioning: the usability, or rather, the
> mis-usability of such a feature.

What goes with that is "so how do you do it otherwise". Distros can
certainly add patches for such features if needed but that just makes it
even more fun to debug.
 
Does "bind mount your own cpuid file" cover this ?

Alan
