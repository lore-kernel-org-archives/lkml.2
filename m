Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1CXOzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:55:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45435 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751630Ab1CXOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:55:11 -0400
Date: Thu, 24 Mar 2011 10:55:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Chris Wright <chrisw@sous-sol.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: check device_create_file() return code in usb_create_sysfs_intf_files()
In-Reply-To: <20110324143116.GA8200@swordfish.minsk.epam.com>
Message-ID: <Pine.LNX.4.44L0.1103241050520.2006-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Sergey Senozhatsky wrote:

> Hello,
> 
> I just noticed that usb_create_sysfs_intf_files() ignores device_create_file() 
> return code and sets intf->sysfs_files_created to 1, even if sysfs_add_file_mode() 
> returned -ENOMEM (or later sysfs_add_one() returned -EEXIST).
> 
> Shouldn't we check retval for 0 before setting intf->sysfs_files_created?

No.  We want this routine to succeed even if the sysfs files can't be 
created.  The interface string attribute is more or less optional.

It would be okay to add a comment explaining this, so that other people
don't make the same mistake (which has already happened -- you're not
the first).

Alan Stern

