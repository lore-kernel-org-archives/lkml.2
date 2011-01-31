Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1AaUXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:23:31 -0500
Received: from tex.lwn.net ([70.33.254.29]:54456 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab1AaUXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:23:30 -0500
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2011 15:23:30 EST
Date: Mon, 31 Jan 2011 12:55:24 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: "Brian D. McGrew" <brian@visionpro.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Ioctl
Message-ID: <20110131125524.116fe96e@bike.lwn.net>
In-Reply-To: <C96C4FE1.46AA1%brian@visionpro.com>
References: <C96C4FE1.46AA1%brian@visionpro.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.23.90; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 11:39:13 -0800
"Brian D. McGrew" <brian@visionpro.com> wrote:

> I'm very new at working with the kernel and device drivers and I'm trying to
> bring ours drivers up from a 2.6.16 kernel to 2.6.37.  I'm noticing that
> ioctl() doesn't seem to be raound anymore, or at least I can't find it.

What you almost certainly want is unlocked_ioctl(), which handles ioctl()
calls but lacks the protection of the (soon to be removed) big kernel
lock.  If your driver is properly written, you should have no problem
using unlocked_ioctl(), but do note that the function prototype is a
little different.

jon
