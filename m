Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2LTFjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:39:05 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:46934 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LTFjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:39:02 -0500
Date: Wed, 19 Dec 2012 21:42:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hongbo.zhang@linaro.org, wni@nvidia.com
Subject: Re: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
Message-ID: <20121220054201.GE28007@kroah.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
 <1355822977-4804-5-git-send-email-durgadoss.r@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355822977-4804-5-git-send-email-durgadoss.r@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 02:59:33PM +0530, Durgadoss R wrote:
> This patch adds a thermal_trip directory under
> /sys/class/thermal/zoneX. This directory contains
> the trip point values for sensors bound to this
> zone.

Eeek, you just broke userspace tools that now can no longer see these
entries :(

Why do you need to create a subdirectory?  As you found out, doing so
isn't the easiest, right?  That is on purpose.

I really wouldn't recommend doing this at all, please stick within the
'struct device' framework here, don't create new kobjects and hang sysfs
files off of them.

thanks,

greg k-h
