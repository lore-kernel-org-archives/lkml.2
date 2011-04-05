Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab1DEQWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:22:31 -0400
Received: from kroah.org ([198.145.64.141]:50897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab1DEQWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:22:30 -0400
Date: Tue, 5 Apr 2011 09:23:06 -0700
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        stable <stable@kernel.org>, Mike Surcouf <mike@surcouf.co.uk>
Subject: Re: [PATCH] staging: hv: Fix GARP not sent after Quick Migration
Message-ID: <20110405162306.GA1800@kroah.com>
References: <1302020655-27133-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302020655-27133-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 09:24:15AM -0700, Haiyang Zhang wrote:
> After Quick Migration, the network is not immediately operational in the
> current context when receiving RNDIS_STATUS_MEDIA_CONNECT event. So, I put
> the netif_notify_peers() into a scheduled work, otherwise GARP packet will
> not be sent after quick migration, and cause network disconnection.

Wait, what are you relying on here for the delay?  What happens when
processors get faster and that work queue gets run even sooner than
today?  You are relying on the scheduler to introduce a "delay" here and
you can't rely on that at all.

Instead, use a proper timer as you do know how long you need to wait,
right?  Don't abuse workqueues for something they were not designed for.

thanks,

greg k-h
