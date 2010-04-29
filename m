Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab0D3RU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:20:27 -0400
Received: from tex.lwn.net ([70.33.254.29]:34475 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab0D3RUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:20:11 -0400
Date: Thu, 29 Apr 2010 13:06:38 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 24/30] viafb: Add a driver for the video capture engine
Message-ID: <20100429130638.0abff0dc@tpl.lwn.net>
In-Reply-To: <20100429191624.30cd67e0@neptune.home>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
	<1272493051-25380-25-git-send-email-corbet@lwn.net>
	<20100429191624.30cd67e0@neptune.home>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 19:16:24 +0200
Bruno Prémont <bonbons@linux-vserver.org> wrote:

> I think the extra 'viafb-camera' entry should be wrapped into a
> 
> #if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)

I think you're right, yes.  (As noted above, the camera driver isn't
quite ready for merging yet - but I can't swear I would have caught
this one, so I'm glad you did).

> or probably better be dynamically added when camera module is loaded
> and/or detects/probes the camera sub-device.

That's a little harder - the platform device is the means by which the
camera and the core communicate.  I guess I could add a general "I'm a
via-core subdev and I'm here now" exported function in the core, but
I'm not sure that would be better than just having the platform dev be
there.

But it definitely shouldn't be around if the camera is configured out.

Thanks,

jon
