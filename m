Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab2DLLIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:08:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58248 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab2DLLIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:08:52 -0400
Date: Thu, 12 Apr 2012 12:11:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120412121124.64aee2f6@pyramind.ukuu.org.uk>
In-Reply-To: <CACVxJT_RRfW7HknkbA4+41L9hNMBHZNezKs1ifbv_qFx5eB0-w@mail.gmail.com>
References: <20120401125741.GA7484@p183.telecom.by>
	<4F78D0BA.9040709@zytor.com>
	<CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
	<4F7F1659.5090305@zytor.com>
	<20120406201601.GA3310@p183.telecom.by>
	<4F7F59E1.2040009@zytor.com>
	<CACVxJT_RRfW7HknkbA4+41L9hNMBHZNezKs1ifbv_qFx5eB0-w@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 13:54:25 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sat, Apr 7, 2012 at 12:02 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 04/06/2012 01:16 PM, Alexey Dobriyan wrote:
> >>
> >> closefrom(3) written via nextfd(2) loop is reliable and doesn't fail.
> >> closefrom(3) written via /proc/self/fd is reliable and can fail (including ENOMEM).
> >> closefrom(3) written via close(fd++) is unreliable.
> >>
> >
> > I call shenanigans on this.  There is no reason to ENOMEM on the second
> > written using the fdwalk() implementation I already posted, for example.
> 
> open("/proc/self/fd") can fail with ENOMEM.

Any syscall can fail with a process kill due to a stack extend on out of
memory in most configurations. That includes your nextfd stuff

This whole thing is getting stupid. "Perfection is the enemy of
success".

Your code will also fail when the cat pees on the computer, when the
power fails and when disk dies. I suspect that other than the cat these
are all more likely real world cases than your ENOMEM.

Alan
