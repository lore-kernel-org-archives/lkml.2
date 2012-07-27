Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2G0SWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:22:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34853 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2G0SV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:21:59 -0400
Date: Fri, 27 Jul 2012 11:21:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] platform: Add support for automatic device IDs
Message-ID: <20120727182155.GD23564@kroah.com>
References: <20120727134625.71e29d2d@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727134625.71e29d2d@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:46:25PM +0200, Jean Delvare wrote:
> Right now we have support for explicit platform device IDs, as well as
> ID-less platform devices when a given device type can only have one
> instance. However there are cases where multiple instances of a device
> type can exist, and their IDs aren't (and can't be) known in advance
> and do not matter. In that case we need automatic device IDs to avoid
> device name collisions.
> 
> I am using magic ID value -4 for this (I left -2 and -3 free in case
> we ever need a couple of other magic values.) The automatically
> allocated device IDs are global (to avoid an additional per-driver
> cost) and are stored internally as negative numbers, starting with -4.
> This is required so that the IDs can be freed later. Externally the
> positive value is used.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> If anyone has a problem with the -4 or using negative device IDs
> internally, it would be possible to avoid that by adding a boolean
> attribute to every platform device to record whether the ID needs to
> be freed. This would cost some memory.

A boolean is "free" don't worry about that.  Don't overload the device
id with "magic" values like this, I don't like that at all.  I'd prefer
to see another field added if this is really going to be needed.

thanks,

greg k-h
