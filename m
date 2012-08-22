Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2HVNOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:14:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56871 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2HVNOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:14:06 -0400
Date: Wed, 22 Aug 2012 14:18:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/2] console_lock debug improvements
Message-ID: <20120822141846.3b142c12@pyramind.ukuu.org.uk>
In-Reply-To: <1345588472-4055-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1345588472-4055-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012 00:34:30 +0200
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> Hi all,
> 
> After Dave Airlie blew through a few days to track down a deadlock at boot-up
> when handing over from the firmware fb to the kms/drm framebuffer driver (1), I've
> figured that lockdep /should/ have caught this.
> 
> And indeed, by adding proper annotations to the console_lock it complains about
> the potential deadlock when exercising the entire driver life-cycle of just one
> fb driver (i.e. not even a handover required). While at it, I've replaced the
> existing in_interrupt check with the more paranoid might_sleep.
> 
> Comments, flames and review highly welcome.

This will be an absolute godsend for DRI debugging. Definitely wants to go
in.

Alan
