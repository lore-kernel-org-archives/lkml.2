Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2FLUTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:19:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54677 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2FLUTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:19:24 -0400
Date: Tue, 12 Jun 2012 21:23:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
Message-ID: <20120612212302.7a4ec41c@pyramind.ukuu.org.uk>
In-Reply-To: <CAMeQTsbAxToYhP4T+PRsaTq-wrX4yCprM=jCfK8NRWi21Avzvw@mail.gmail.com>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
	<CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
	<CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
	<CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
	<CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
	<20120612132736.642a4a5a@pyramind.ukuu.org.uk>
	<CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
	<20120612170412.359967ec@pyramind.ukuu.org.uk>
	<CAMeQTsbAxToYhP4T+PRsaTq-wrX4yCprM=jCfK8NRWi21Avzvw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It matters because everything between 0x4100 - 0x4107 are Moorestown if you ask
> the macro, but are assigned to oaktrail_chip_ops. That makes Oaktrail ==
> Moorestown. IS_OAK might be a more appropriate name.

Oaktrail is sort of Moorestown, the divide is whether they have a PC like
set of I/O devices or not. It reflects the history of the driver


> IS_MRST is primarily used for two things:
> 1) Take LVDS enable fuse value into account

This like the non PC BIOS parsing should probably go. I've not taken it
out yet because I wanted to prove this. I'd be very surprised if it's the
right way to handle E600T but there's a bit of a lack of any public info
on that so who knows 8(.

> 2) Tell that LVDS must be on Pipe A

Which is true for Oaktrail and it seems E600T

> Those things where required for him to get the panel working,
> so why not include the 0x4108 in the IS_MRST check?

We probably want IS_GMA600() rather than IS_MRST.

Alan
