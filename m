Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2HERHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 13:07:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34683 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2HERHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 13:07:41 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: Update VIP to videobuf2 and control framework
Date: Sun, 05 Aug 2012 19:11:19 +0200
Message-ID: <5055608.KkUHWr6mgc@harkonnen>
User-Agent: KMail/4.8.4 (Linux/3.5.0-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <201208010841.56941.hverkuil@xs4all.nl>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com> <201208010841.56941.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,
 
> Did you run the latest v4l2-compliance tool from the v4l-utils.git
> repository over your driver? I'm sure you didn't since VIP is missing
> support for control events and v4l2-compliance would certainly
> complain about that.
> 
> Always check with v4l2-compliance whenever you make changes! It's
> continuously improved as well, so a periodic check wouldn't hurt.

I applied all your suggestions, and some extra simplification; now I'm 
running v4l2-compliance but I have this error:


Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
                fail: v4l2-compliance.cpp(322): doioctl(node, 
VIDIOC_G_PRIORITY, &prio)
        test VIDIOC_G/S_PRIORITY: FAIL


which I don't undestand. I don't have vidio_{g|s}_priority functions in 
my implementation. And I'm using the V4L2_FL_USE_FH_PRIO flag as 
suggested in the documentation:

---------------
- flags: optional. Set to V4L2_FL_USE_FH_PRIO if you want to let the 
framework handle the VIDIOC_G/S_PRIORITY ioctls. This requires that you 
use struct v4l2_fh. Eventually this flag will disappear once all drivers 
use the core priority handling. But for now it has to be set explicitly.
--------------

-- 
Federico Vaga
