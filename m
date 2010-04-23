Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab0DWKcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:32:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47788 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753621Ab0DWKcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:32:15 -0400
Date: Fri, 23 Apr 2010 11:37:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Locking question for DRM
Message-ID: <20100423113717.1188415d@lxorguk.ukuu.org.uk>
In-Reply-To: <s2l21d7e9971004230324me3de75b0w58a9907999b7872a@mail.gmail.com>
References: <20100423112222.67cfcbb2@lxorguk.ukuu.org.uk>
	<s2l21d7e9971004230324me3de75b0w58a9907999b7872a@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > and I can't see what makes this safe if the drm_release for the master
> > and a client occur at the same time ?
> 
> lock_kernel in drm_release. We probably need to clean that up.

I don't think that works. drm_open_helper doesn't appear to be under the
BKL merely the struct mutex.

> > The setmaster/dropmaster ioctl seems similar - the various conditional
> > checks are not protected from parallel changes occuring during their
> > execution.
> >
> > Is this a bug or is something clever afoot ?
> 
> These ioctls are also under the BKL.

But setmaster can sleep so the BKL is dropped on contention of the
struct_mutex, ditto dropmaster



Alan
