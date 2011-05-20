Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578Ab1ETPNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:13:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65023 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183Ab1ETPNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:13:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs cpu attribute
Date: Fri, 20 May 2011 17:13:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <201105201637.20925.arnd@arndb.de> <4DD6821F.6060707@tilera.com>
In-Reply-To: <4DD6821F.6060707@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201713.25364.arnd@arndb.de>
X-Provags-ID: V02:K0:hHtM5rQaD4W/kfmtHN+iFeqFbrnmseR7/WcaGlmMPkI
 7jeqV8+0SGYwXre5DO58LwuHfEBsKYjm5lcjZhgYxU79PXbRw9
 dc/ztLQtXWH4UDQ0YmHlNNPqzutDbmcXkZN1PoYDmEoPP5u3Jx
 VPVgu74/4sqamr1PiD8hJyQctaK9mOkgU1eeZE+al6vOQvZVuG
 9t6XwnQtAEiRWmJRW83Wg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 17:00:47 Chris Metcalf wrote:
> > Any chance you can still restructure the information? I would recommend
> > making it a first-class procfs member, since the data is really per-task.
> >
> > You can add a conditional entry to tgid_base_stuff[] in fs/proc/base.c
> > to make it show up for each pid, and then just have the per-task information
> > in there to do the lookup the other way round:
> >
> > # cat /proc/484/hardwall
> > 2x2 1,1 @2,1
> >
> > # cat /proc/479/hardwall
> > 2x2 1,1 @1,1
> 
> It's not unreasonable to do what you're suggesting, i.e. "what's this
> task's hardwall?", but it's not something that we've come up with any kind
> of use case for in the past, so I'm not currently planning to implement
> this.  If we did, I agree, your solution looks like the right one.

It's fairly easy to aggregate in user space though, we do similar
things for 'lsof' and 'top', which walk all of procfs in order
to show the complete picture. This is obviously more overhead than
walking the lists in the kernel, but still not an expensive
operation, and it keeps the data format much simpler.

	Arnd
