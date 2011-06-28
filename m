Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab1F1QlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:41:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43735 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759678Ab1F1QkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:40:13 -0400
Date: Tue, 28 Jun 2011 17:42:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl
 doesn't exist
Message-ID: <20110628174223.3d78ca4c@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTi=6W0quy1M71UapwKDe97E67b4EiA@mail.gmail.com>
References: <4E0519B7.3000304@redhat.com>
	<201106271907.59067.hverkuil@xs4all.nl>
	<BANLkTin=PTbTwBR2s+owMLy+GmKigeoYvg@mail.gmail.com>
	<201106280804.48742.hverkuil@xs4all.nl>
	<BANLkTi=6W0quy1M71UapwKDe97E67b4EiA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (In fact, the _correct_ thing to do would probably be to just do
> 
>    #define ENOIOCTLCMD ENOTTY
> 
> and get rid of any translation - just giving ENOTTY a more appropriate
> name and less chance for confusion)

Some code uses the two to separate 'the driver specific helper code
doesn't handle this' and 'does handle this'. In that situation you take
away the ability of a driver to override a midlayer ioctl with -ENOTTY to
say "I don't support this even if most people do"

> There may be applications out there that really break when they get
> ENOTTY instead of EINVAL. But most cases that check for errors from
> ioctl's tend to just say "did this succeed or not" rather than "did
> this return EINVAL". That's *doubly* true since the error code has
> been ambiguous, so checking for the exact error code has always been
> pretty pointless.

Chances are if anything is busted its busted the other way on Linux and
expects -ENOTTY. Certainly the large number I've been fixing over time
haven't shown up any problems.
