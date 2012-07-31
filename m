Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2GaQSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:18:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48032 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab2GaQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:18:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAMjpGUdo0SavFWR_tk50_6nZMsJmxYO5BxH9Fp=UTw5sW-0+Rw@mail.gmail.com>
References: <1343742860-16213-1-git-send-email-damien.cassou@lifl.fr>
 <1343742860-16213-5-git-send-email-damien.cassou@lifl.fr> <CAMjpGUdo0SavFWR_tk50_6nZMsJmxYO5BxH9Fp=UTw5sW-0+Rw@mail.gmail.com>
From: Damien Cassou <damien.cassou@gmail.com>
Date: Tue, 31 Jul 2012 18:18:08 +0200
Message-ID: <CA+y5ggi-75ctNTtkE+xsAgi8XJyn0iVLNOcUXpwhVzqy2X6AKQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivers/video/bfin-t350mcqb-fb.c: use devm_ functions
To: Mike Frysinger <vapier@gentoo.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 3:57 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Tue, Jul 31, 2012 at 9:54 AM, Damien Cassou <damien.cassou@lifl.fr> wrote:
>> The various devm_ functions allocate memory that is released when a driver
>> detaches.  This patch uses these functions for data that is allocated in
>> the probe function of a platform device and is only freed in the remove
>> function.
>
> Acked-by: Mike Frysinger <vapier@gentoo.org>

This whole patch is invalid, because of this part:

-	info->fb_buffer = dma_alloc_coherent(NULL, fbinfo->fix.smem_len +
-				ACTIVE_VIDEO_MEM_OFFSET,
-				&info->dma_handle, GFP_KERNEL);
+	info->fb_buffer = dmam_alloc_coherent(&pdev->dev, NULL,
+					      fbinfo->fix.smem_len +
+					      ACTIVE_VIDEO_MEM_OFFSET,
+					      &info->dma_handle, GFP_KERNEL);


dmam_alloc_coherent() is called with 5 arguments but only accepts 4.

Please ignore this whole patch altogether.

I am sorry about that.

-- 
Damien Cassou
http://damiencassou.seasidehosting.st

"Lambdas are relegated to relative obscurity until Java makes them
popular by not having them." James Iry
