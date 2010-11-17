Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab0KQV7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:59:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab0KQV7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:59:02 -0500
Date: Wed, 17 Nov 2010 13:51:47 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101117215147.GA26792@suse.de>
References: <4CE44B1B.9040709@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE44B1B.9040709@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:37:31PM -0600, Timur Tabi wrote:
> Arnd and Greg,
> 
> I'm working on a TTY driver for a virtual device that we call "byte channels".
> This are likes pipes, but they go through an ePAPR hypervisor.

What is ePAPR?

> The hypervisor declares byte channels as nodes in a device tree.  Each byte
> channel has a unique 32-bit number called a "handle", and this handle is
> specified in the node for that device tree.  Applications are expected to scan
> the device tree to look for the node they want, and then extract the handle from
> that node.
> 
> The problem I have is that the handles are, from Linux's perspective, arbitrary
> and sparsely assigned.  For example, we could have four byte channels with
> handles of 2, 8, 73, and 74.
> 
> What I would like is for the minor number for each tty device to be the byte
> channel handle.  Or the byte channel could be in the /dev name.  Either way,
> applications can figure out which /dev entry to open in order to communicate
> with a given byte channel.

Why would you need this mapping?  Just do a first-come-first serve
assignment of tty minor devices like all other subsystems do (usb,
serial, acm, etc.)

sysfs will show the representation between your ePAPR device "handle"
and the tty device minor just fine, as it does today for those other
types of devices.

Bonus being that udev will create a persistant device id for your tty
device based on that handle so you can just open that if you want to, no
need to get the kernel involved in sparse minor mappings at all.

Hope this helps,

greg k-h
