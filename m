Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2FMK2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:28:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55340 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2FMK2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:28:01 -0400
Date: Wed, 13 Jun 2012 11:31:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
Message-ID: <20120613113133.38c1ca8a@pyramind.ukuu.org.uk>
In-Reply-To: <CAH9NwWdF+zukb1r1z6ES6ULeg3dkFzhvhBq1xzjrqjWx-O3cOA@mail.gmail.com>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
	<CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
	<CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
	<CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
	<CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
	<20120612132736.642a4a5a@pyramind.ukuu.org.uk>
	<CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
	<20120612170412.359967ec@pyramind.ukuu.org.uk>
	<CAH9NwWdF+zukb1r1z6ES6ULeg3dkFzhvhBq1xzjrqjWx-O3cOA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My company is using these cpu bords for our products:
> http://www.congatec.com/en/products/qseven/dView/conga-qa6.html
> 
> With firmware you mean BIOS or VBios or ...? If you tell me what you need, I may
> ask our supplier for more informations. I can tell you that the
> following options can be
> changed in the BIOS regarding gfx - see
> https://www.dropbox.com/s/btlciurz0ih4fhu/IMG_20120612_143431.jpg

The basic question is:

Does this device use the Intel BIOS way of reporting mode information,
or the embedded "GCT" style.

If you look in oaktrail_device.c you'll see it tries mid_chip_setup() and
then if that fails to find data it calls psb_intel_init_bios(). Which is
in use. Also if the mid style one is in use what happens if you change
mid_get_vbt_data in mid_bios.c so that it just does

	vbt->size = 0;
	return;


Alan


