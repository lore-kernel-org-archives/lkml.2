Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1GXDVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 23:21:45 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43728 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab1GXDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 23:21:41 -0400
X-Sasl-enc: hkBcoF5sHzZeSjaAjc/HUkqWnlWk0I6VVUyYeV+xWVNi 1311477700
Date: Sat, 23 Jul 2011 20:18:04 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs - export sysfs_create_subdir?
Message-ID: <20110724031804.GA16601@kroah.com>
References: <4E29B6B1.2090107@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E29B6B1.2090107@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 06:43:13PM +0100, Jonathan Cameron wrote:
> Hi All,
> 
> I have a couple of cases in IIO where under some conditions
> we end up using dummy attr_groups (no elements) to initialize
> a sub directory before dynamically creating all of its attributes.

Ick, you really shouldn't do that.

> Now having dummy groups in the IIO core is fine, but it does seem
> a little messy.
> 
> The obvious choice would be to put together a small wrapper function
> for sysfs_create_subdir that also does sysfs_get on the result.

That's why that function is not exported.  Creating subdirectories in
sysfs is not a good idea, udev doesn't like it, and you don't get
userspace notification for it very well either.

What specifically are you trying to do in sysfs that you are needing
this?

thanks,

greg k-h
