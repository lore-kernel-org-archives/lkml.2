Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1DIRp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 13:45:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58455 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754654Ab1DIRp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 13:45:27 -0400
Date: Sat, 9 Apr 2011 18:45:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harald Welte <laforge@gnumonks.org>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        linux-kernel@vger.kernel.org,
        Aloisio Almeida <aloisio.almeida@openbossa.org>,
        Arnd Bergmann <arnd@arndb.de>, Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC] NFC subsystem prototype
Message-ID: <20110409184559.41b947af@lxorguk.ukuu.org.uk>
In-Reply-To: <20110409130945.GC3248@prithivi.gnumonks.org>
References: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
	<20110409130945.GC3248@prithivi.gnumonks.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    If you're worried about SPI-attached RFID/NFC ASICs, then I think the
>    propper approach is to have a generic support for exporting SPI devices to
>    userspace (similar to what we have with usb + libusb).

That bit in my experience doesn't work. Most i²c devices for example end
up needing an actual kernel driver because you have to manage the
transaction flow to stop users breaking things horribly.

>    I simply do not see the advantage of having this in the kenrel.  There are
>    no latency/timing constraints, and the amount of data you are moving is so
>    small, that performance considerations also don't really play any role.

The big one is security management - once you've got readers that are
needing to report different stuff to different people you need at least
the muxing in kernel. It also separates protocol stacks from apps which
is rather important in more complex systems.

> 2) even if you go for an in-kernel subsystem, what is your strategy for the
>    many existing CL-RC5xx / CL-RC6xx ASIC based RFID/NFC readers?  For them,
>    you typically need your own software implementation of the anti-collision
>    procedures of 14443-3 (a+b) and the T=CL (14443-4) code.  All of this has
>    been implemented in userspace e.g. librfid - but do you want to port or
>    re-implement it all in kernel-land, and then 'glue' it below your current
>    NFC subsystem approach?

The obvious thing would be to plug it into the kernel at a higher level
than the raw asic interface. We manage that sort of stuff with all sorts
of network devices just fine, and in fact we'll need chunks of that
anyway for virtualisation of rfid/nfc.
