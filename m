Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2HFH3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 03:29:41 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3271 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2HFH3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 03:29:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: Update VIP to videobuf2 and control framework
Date: Mon, 6 Aug 2012 09:26:40 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com> <201208010841.56941.hverkuil@xs4all.nl> <5055608.KkUHWr6mgc@harkonnen>
In-Reply-To: <5055608.KkUHWr6mgc@harkonnen>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208060926.40164.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun August 5 2012 19:11:19 Federico Vaga wrote:
> Hi Hans,
>  
> > Did you run the latest v4l2-compliance tool from the v4l-utils.git
> > repository over your driver? I'm sure you didn't since VIP is missing
> > support for control events and v4l2-compliance would certainly
> > complain about that.
> > 
> > Always check with v4l2-compliance whenever you make changes! It's
> > continuously improved as well, so a periodic check wouldn't hurt.
> 
> I applied all your suggestions, and some extra simplification; now I'm 
> running v4l2-compliance but I have this error:
> 
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>                 fail: v4l2-compliance.cpp(322): doioctl(node, 
> VIDIOC_G_PRIORITY, &prio)
>         test VIDIOC_G/S_PRIORITY: FAIL
> 
> 
> which I don't undestand. I don't have vidio_{g|s}_priority functions in 
> my implementation. And I'm using the V4L2_FL_USE_FH_PRIO flag as 
> suggested in the documentation:
> 
> ---------------
> - flags: optional. Set to V4L2_FL_USE_FH_PRIO if you want to let the 
> framework handle the VIDIOC_G/S_PRIORITY ioctls. This requires that you 
> use struct v4l2_fh.

  ^^^^^^^^^^^^^^^^^^

Are you using struct v4l2_fh? The version you posted didn't. You need this
anyway to implement control events.

Regards,

	Hans

> Eventually this flag will disappear once all drivers 
> use the core priority handling. But for now it has to be set explicitly.
> --------------
> 
> 
