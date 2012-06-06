Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2FFPHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:07:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51199 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756554Ab2FFPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:07:00 -0400
Date: Wed, 6 Jun 2012 11:06:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: stefani@seibold.net, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <oneukum@suse.de>,
        <alan@lxorguk.ukuu.org.uk>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] fix usb skeleton driver
In-Reply-To: <CACVXFVPX-F820rgusEiC9F9XQNqYybi29Cd_hSyiN95c2OAWHg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206061104390.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Ming Lei wrote:

> On Wed, Jun 6, 2012 at 9:23 PM,  <stefani@seibold.net> wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> >
> > This is a fix for the USB skeleton driver to bring it in shape.
> >
> > - The usb_interface structure pointer will be no longer stored
> > - Every access to the USB will be handled trought the usb_interface pointer
> > - Add a new bool 'connected' for signaling a disconnect (== false)
> > - Handle a non blocking read without blocking
> > - Code cleanup
> > - Synchronize disconnect() handler with open() and release(), to fix races
> > - Introduced fsync
> > - Single user mode
> > - More code cleanup :-)
> > - Save some bytes in the dev structure
> 
> So many purposes, you need to split your patches for review easily, :-)

Not just that...  usb-skeleton is intended to be a good example, to
help people learn how to write USB drivers.  It's already far too
complicated for this purpose, and adding more complication will just
make it worse.

Instead of adding things to usb-skeleton, we should take things away.

Alan Stern

