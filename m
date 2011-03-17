Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab1CQGCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 02:02:00 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:32820 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1CQGB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 02:01:56 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [BUG] usb_wwan: build error
Date: Thu, 17 Mar 2011 07:02:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <1300341100.10164.523.camel@edumazet-laptop>
In-Reply-To: <1300341100.10164.523.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103170702.28752.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 17. März 2011, 06:51:40 schrieb Eric Dumazet:
> commit 16871dcac74c (usb_wwan: error case of resume) added a build error
> if CONFIG_PM_RUNTIME is not defined.
> 
>   CC [M]  drivers/usb/serial/usb_wwan.o
> drivers/usb/serial/usb_wwan.c: In function ‘play_delayed’:
> drivers/usb/serial/usb_wwan.c:702: error: ‘struct dev_pm_info’ has no
> member named ‘usage_count’
> 
> I suspect we should use pm_runtime_put_noidle() instead

Yes. I don't understand why it compiled for me. Has it been removed?

	Regards
		Oliver

PS: patch about to follow
