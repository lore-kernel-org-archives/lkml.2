Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1CVTgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:36:44 -0400
Received: from tex.lwn.net ([70.33.254.29]:50492 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1CVTgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:36:42 -0400
Date: Tue, 22 Mar 2011 13:36:40 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Tony Ibbs <tibs@tonyibbs.co.uk>, Grant Likely <grant.likely@secretlab.ca>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Subject: Re: [PATCH 00/11] RFC: KBUS messaging subsystem
Message-ID: <20110322133640.5d5c88e4@bike.lwn.net>
In-Reply-To: <cover.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 17:21:09 +0000
Tony Ibbs <tibs@tonyibbs.co.uk> wrote:

> KBUS is a lightweight, Linux kernel mediated messaging system,
> particularly intended for use in embedded environments.

I've spent a bit of time looking at this code...this isn't a detailed
review by any stretch, more like a few impressions.

- Why kbus over, say, a user-space daemon and unix-domain sockets?  I'm
  not sure I see the advantage that comes with putting this into kernel
  space.

- The interface is ... creative.  If you have to do this in kernel space,
  it would be nice to do away with the split write()/ioctl() API for
  reading or writing messages.  It seems like either a write(), OR an
  ioctl() with a message data pointer would suffice; that would cut the
  number of syscalls the applications need to make too.

  Even better might be to just use the socket API.

- Does anything bound the size of a message fed into the kernel with
  write()?  I couldn't find it.  It seems like an application could
  consume arbitrary amounts of kernel memory.

- It would be good to use the kernel's dynamic debugging and tracing
  facilities rather than rolling your own.

- There's lots of kmalloc()/memset() pairs that could be kzalloc().

That's as far as I could get for now.

Thanks,

jon
