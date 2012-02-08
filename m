Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2BHTGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:06:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:57920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2BHTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:06:07 -0500
Message-ID: <4F32C75E.2000807@kernel.dk>
Date: Wed, 08 Feb 2012 20:05:02 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cdrom: move shared static to cdrom_device_info
References: <1328722329-22728-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1328722329-22728-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 06:32 PM, Paolo Bonzini wrote:
> The keeplocked variable in the cdrom driver is shared across multiple
> drives, but set in per-device ioctls.  Move it to the per-device struct,
> avoiding that the setting on one drive affects the driver's behavior
> when closing another.
> 
> [ Impact: limit udev's confusion to one drive when a CD burning program
>   unlocks the CD door at the end of burning. ]
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	Would this be acceptable for 3.3?

Yeah, looks simple enough. I thought we had a module parameter for this
too, but we do not. So I've applied it for 3.3.

-- 
Jens Axboe

