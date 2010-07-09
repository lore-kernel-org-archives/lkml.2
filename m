Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0GIPAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:00:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33319 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754367Ab0GIPA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:00:28 -0400
Date: Fri, 9 Jul 2010 11:00:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] pm: Add runtime PM statistics to sysfs
In-Reply-To: <20100708224837.6a18995b@infradead.org>
Message-ID: <Pine.LNX.4.44L0.1007091056510.1582-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010, Arjan van de Ven wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: pm: Add runtime PM statistics to sysfs
> 
> In order for PowerTOP to be able to report how well the new runtime PM is working
> for the various drivers, the kernel needs to export some basic statistics in sysfs.
> 
> This patch adds two sysfs files in the runtime PM domain that expose the
> total time a device has been active, and the time a device has been suspended.
> 
> With this PowerTOP can compute the activity percentage
> 
> Active %age = 100 * (delta active) / (delta active + delta suspended)
> 
> and present the information to the user.
> 
> I've written the PowerTOP code (slated for version 1.12) already, and the output looks
> like this:
> 
> Runtime Device Power Management statistics
> Active  Device name
>  10.0%	06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E


> @@ -411,6 +433,7 @@ int __pm_runtime_resume(struct device *dev, bool from_wq)
>  	}
>  
>  	if (retval) {
> +		update_pm_runtime_accounting(dev);
>  		dev->power.runtime_status = RPM_SUSPENDED;
>  		pm_runtime_cancel_pending(dev);
>  	} else {

This line was added in the wrong place.  It belongs either before the 
"if (retval) {" or after the "} else {".

Alan Stern

