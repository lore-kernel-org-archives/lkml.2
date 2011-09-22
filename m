Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1IVUXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:23:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35009 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753822Ab1IVUXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:23:32 -0400
Date: Thu, 22 Sep 2011 21:21:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] gma500: gtt based hardware scrolling console
Message-ID: <20110922212146.609065b1@lxorguk.ukuu.org.uk>
In-Reply-To: <CAMuHMdWBz9+TCBUbaOY3HRv=khiDHkRCKdx5e53HCen54RUBVw@mail.gmail.com>
References: <20110922184316.25068.54702.stgit@localhost.localdomain>
	<CAMuHMdWBz9+TCBUbaOY3HRv=khiDHkRCKdx5e53HCen54RUBVw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       info->fix.ywrapstep = gtt_roll;
> 
> Do you really want to set this? I didn't see any other wrapping
> support in your patch.
> However, I guess you can implement wrapping support using the same
> mapping trick?

It is actually wrapping - it writes the low pages back below the high
ones so it works the GTT as a circular buffer - or am I misunderstanding
this.

One thing I wasn't sure of on the fb side. If I've got a display width
that is annoying and can't fit on a 4Kbyte stride am I right in thinking
I can set this to say 8 and use a 512 byte stride and still get
acceleration for the usual font choice ?

Alan
