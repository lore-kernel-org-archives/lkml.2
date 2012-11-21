Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2KUOvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:51:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59009 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2KUOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:51:32 -0500
Date: Wed, 21 Nov 2012 06:52:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC] driver-core: Remove dummy 'platform_bus'
Message-ID: <20121121145239.GA21860@kroah.com>
References: <1353509071-8658-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353509071-8658-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 02:44:31PM +0000, Grant Likely wrote:
> The "platform_bus" (note: not platform_bus_type) only exists as an empty
> directory to put platform devices into. However, it really doesn't make
> sense to segregate all the platform devices into a sub directory when
> typically they are memory mapped devices that doen't go through any
> particular bus. Particularly on embedded type platforms the platform_bus
> directory doesn't add anything.
> 
> However, this will probably just end up breaking some userspace that
> depends on the /sys/devices/platform/ path to be present (no matter how
> much we protest that userspace must not depend on paths in sysfs). So
> while I'm seriously proposing this change, it may just be unacceptable
> ABI breakage

If the devices don't show up under platform/ where are they going to be
at now, virtual/ ?  That doesn't sound like a good plan, they should be
somewhere "useful".

And yes, odds are this will break userspace, but we might not know until
we try it, have you tried it on different distros to see what happens?

thanks,

greg k-h
