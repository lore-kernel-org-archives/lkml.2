Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2HMX1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 19:27:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61438 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab2HMX1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 19:27:14 -0400
Date: Mon, 13 Aug 2012 16:27:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: picoLCD updates
Message-ID: <20120813232708.GF25632@google.com>
References: <20120730213656.0a9f6d30@neptune.home>
 <20120809200947.2194e89f@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120809200947.2194e89f@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 09, 2012 at 08:09:47PM +0200, Bruno Prémont wrote:
> As you are working on workqueues and related code, could you have a look
> at my usage of them in combination with db_defio?
> 
> The delayed memory corruptions or system reboots after unbinding/unplugging
> the PicoLCD seem very much related to workqueue used to handle the deferred
> IO to framebuffer.
> 
> I think things don't get cleaned-up as they should though I'm not sure
> where the trouble lies.
> 
> For ease of reading, I'm inlineing below the framebuffer related code of
> PicoLCD (for complete driver after this patch series apply the whole series
> on top of 3.5 https://lkml.org/lkml/2012/7/30/375 )
...
> void picolcd_exit_framebuffer(struct picolcd_data *data)
> {
> 	struct fb_info *info = data->fb_info;
> 	u8 *fb_vbitmap = data->fb_vbitmap;
> 
> 	if (!info)
> 		return;
> 
> 	device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
> 	info->par = NULL;
> 	unregister_framebuffer(info);
> 	data->fb_vbitmap = NULL;
> 	data->fb_bitmap  = NULL;
> 	data->fb_bpp     = 0;
> 	data->fb_info    = NULL;
> 	kfree(fb_vbitmap);
> }

I'm kinda shooting in the dark but who flushes / cancels
fb_info->deferred_work?

Thanks.

-- 
tejun
