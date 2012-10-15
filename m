Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2JOJgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:36:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab2JOJgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:36:23 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 3/3] USB: forbid memory allocation with I/O during bus reset if storage interface exits
Date: Mon, 15 Oct 2012 11:34:33 +0200
Message-ID: <2564763.3cNFlv543H@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc4-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1350278059-14904-4-git-send-email-ming.lei@canonical.com>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com> <1350278059-14904-4-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012 13:14:19 Ming Lei wrote:
> If one storage interface exists in the device, memory allocation
> with GFP_KERNEL during usb_device_reset() might trigger I/O transfer
> on the storage interface itself and cause deadlock because the
> 'us->dev_mutex' is held in .pre_reset() and the storage interface
> can't do I/O transfer when the reset is triggered by other
> interface, or the error handling can't be completed if the reset
> is triggered by mass storage itself(error handling path).

I think limiting this to devices which have a storage device is not
productive. What if you are using iSCSI or nbd? In the long run
we will see busses attached to busses and as soon as the daughter
bus is hotpluggable you are thwarted anyway. Just do it unconditionally.

	Regards
		Oliver

