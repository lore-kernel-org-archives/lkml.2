Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab1JFScu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:32:50 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56630 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758883Ab1JFSct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:32:49 -0400
X-Sasl-enc: HwPzNmhwNIealndwmw7012BkjJV+yhALOF2u0D5T1Jts 1317925968
Date: Thu, 6 Oct 2011 11:25:00 -0700
From: Greg KH <greg@kroah.com>
To: Himanshu Chauhan <hschauhan@nulltrace.org>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon class driver registration with a device number
Message-ID: <20111006182500.GA18607@kroah.com>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <20111005193359.GB26664@kroah.com>
 <20111006041011.GB2125@ubuntu.ubuntu-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006041011.GB2125@ubuntu.ubuntu-domain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 09:40:11AM +0530, Himanshu Chauhan wrote:
> Hi Greg,
> 
> > 
> > How do you later remove a device created with this new interface?  As it
> > is, I think the existing calls will fail, right?
> > 
> If I have not missed out anything from hwmon_device_unregister(), it shouldn't
> fail. Why did you point that out?

If you create a device with a call to device_create() with a dev_t set,
it is usually cleaned up with a call to device_destroy(), but you are
right, a simple call to device_unregister() will still work properly.

So nevermind, sorry for the noise.

What you do need to determine is if this is a device node you really
want to be creating in this manner, as it is a new user/kernel API,
right?

greg k-h
