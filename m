Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2GaXvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:51:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45623 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab2GaXvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:51:05 -0400
Date: Tue, 31 Jul 2012 16:50:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] platform: Add support for automatic device IDs
Message-ID: <20120731235059.GA5702@kroah.com>
References: <20120727221459.144855ba@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727221459.144855ba@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 10:14:59PM +0200, Jean Delvare wrote:
> Right now we have support for explicit platform device IDs, as well as
> ID-less platform devices when a given device type can only have one
> instance. However there are cases where multiple instances of a device
> type can exist, and their IDs aren't (and can't be) known in advance
> and do not matter. In that case we need automatic device IDs to avoid
> device name collisions.
> 
> I am using magic ID value -2 (PLATFORM_DEVID_AUTO) for this, similar
> to -1 for ID-less devices. The automatically allocated device IDs are
> global (to avoid an additional per-driver cost.) We keep note that the
> ID was automatically allocated so that it can be freed later.
> 
> Note that we also restore the ID to PLATFORM_DEVID_AUTO on error and
> device deletion, to avoid avoid unexpected behavior on retry. I don't
> really expect retries on platform device addition, but better safe
> than sorry.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Looks sane to me, want me to queue it up for 3.7?

thanks,

greg k-h
