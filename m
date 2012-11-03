Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374Ab2KCA6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:58:38 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37090 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab2KCA6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:58:36 -0400
Date: Sat, 3 Nov 2012 01:03:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121103010331.3dd593a5@pyramind.ukuu.org.uk>
In-Reply-To: <87sj8rwm0p.fsf@xmission.com>
References: <20121101210634.GA19723@srcf.ucam.org>
	<20121101213127.5967327f@pyramind.ukuu.org.uk>
	<20121101212843.GA20309@srcf.ucam.org>
	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>
	<20121101213452.GA20564@srcf.ucam.org>
	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>
	<20121101215752.GA21154@srcf.ucam.org>
	<87625ogzje.fsf@xmission.com>
	<20121102140057.GA4668@srcf.ucam.org>
	<87liejacix.fsf@xmission.com>
	<20121103002033.GA18691@srcf.ucam.org>
	<87sj8rwm0p.fsf@xmission.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No reason to?  How can I configure an off the shelf system originally
> sold with windows 8 installed to boot in UEFI secure boot mode using
> shim without trusting Microsoft's key?

Assuming its an x86 and a PC class platform and thus should allow you to
disable secure boot mode then you disable secure boot mode and boot in
sane PC mode. You then jump through a collection of hoops to sign all
your OS stuff, your ROMs and a few other things with a new key, remove
the MS key and then "secure" boot it.

That will also stop random people demonstrating how secure your "secure"
boot is by walking up to your box and installing Windows 8 over your
distribution by reformatting your hard drive and probably block a wide
range of interesting law enforcement and other tools some of which will
inevitably fall into the wrong hands.

A lot of the work there is the mechanising of all of the hoop jumping and
key management, but there isn't an intrinsic reason you can't turn this
into a nice clean click and point self-sign my PC UI.

There are some interesting uses for self signed keys or having your own
corporate key included in your builds as a big company. One thing it
solves if you do it with Linux and an own key is being able to remote
install securely over a network which right now for all OS's and PC class
devices is a problem as you have no way to verify the image.

Alan
