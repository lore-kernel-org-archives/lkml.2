Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1DAPPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:15:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56061 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1DAPPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:15:20 -0400
Date: Fri, 1 Apr 2011 12:15:14 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l: subdev: initialize sd->internal_ops in
 v4l2_subdev_init
Message-ID: <20110401151513.GA2347@herton-IdeaPad-Y430>
References: <1301667857-5145-1-git-send-email-herton.krzesinski@canonical.com>
 <1301667857-5145-2-git-send-email-herton.krzesinski@canonical.com>
 <201104011705.27742.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104011705.27742.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 05:05:27PM +0200, Hans Verkuil wrote:
> On Friday, April 01, 2011 16:24:17 Herton Ronaldo Krzesinski wrote:
> > Many v4l drivers currently don't initialize their struct v4l2_subdev
> > with zeros, so since the addition of internal_ops in commit 45f6f84, we
> > are at risk of random oopses when code in v4l2_device_register_subdev
> > tries to dereference sd->internal_ops->*, as can be shown by the report
> > at http://bugs.launchpad.net/bugs/745213
> > 
> > So make sure internal_ops is cleared in v4l2_subdev_init.
> 
> NACK: we need to replace those kmalloc's with kzalloc. This patch will just
> fix the internal_ops problem, but sd->entity isn't zeroed. It's going to be
> a neverending problem unless we fix those kmalloc's. It is my fault, I guess:
> I should always have required the use of kzalloc.
> 
> I grepped for this and the number of kmalloc's is quite small:
> 
> drivers/media/video/tda9840.c
> drivers/media/video/upd64031a.c
> drivers/media/video/m52790.c
> drivers/media/video/tea6415c.c
> drivers/media/video/tea6420.c
> drivers/media/video/upd64083.c
> drivers/media/radio/saa7706h.c
> drivers/media/radio/tef6862.c
> 
> If you fix those kmalloc's, then I'll ack those changes. There is just one
> relevant kmalloc in each file.
> 
> The reason this wasn't noticed before is that all these devices are all
> pretty rare. All the more common device drivers use kzalloc. I am really
> surprised to hear of mxb boards still in use! Just for the record: I have
> one myself for testing, although I clearly never realized that I should
> test that particular change with that board...
> 
> Thanks for doing such a great job of tracking this down!

No problem, I'll take a look and send a new patch.

> 
> Regards,
> 
> 	Hans
> 

-- 
[]'s
Herton
