Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1LVDxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:53:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab1LVDx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:53:28 -0500
Date: Wed, 21 Dec 2011 19:51:15 -0800
From: Greg KH <gregkh@suse.de>
To: mengdeguo <mengdeguo@baidu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: help about device driver
Message-ID: <20111222035115.GD14174@suse.de>
References: <55E19C299740714F83A6770B39E11B3515EB2828@MAILBOX03.internal.baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55E19C299740714F83A6770B39E11B3515EB2828@MAILBOX03.internal.baidu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:55:49AM +0800, mengdeguo wrote:
> Hi,
> 
> 
> 
>          I find a problem very confusing. Devices are divided into char/block/network dev. By the definition i2c, usb ,input devices belong to char devices. But walk across all the device driver, I can not find the cdev struct for them (i2c ,usb ,input devices). What's the problem ? This devices don't need cdev, if so, what do we do to associate file_operations with dev node?

What device node is associated with a usb device?

cdev structures are only there for character device nodes, the majority
of drivers never use that at all, that's what the different "class"es
are for (input, tty, misc, etc.)

greg k-h
