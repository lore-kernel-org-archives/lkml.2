Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1H3VH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:07:26 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46758 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab1H3VHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:07:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Deepthy Ravi <deepthy.ravi@ti.com>
Subject: Re: [PATCH 1/2] omap3: ISP: Fix the failure of CCDC capture during suspend/resume
Date: Tue, 30 Aug 2011 23:07:47 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.7.0; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@infradead.org, linux-omap@vger.kernel.org,
        Abhilash K V <abhilash.kv@ti.com>
References: <1312984992-19315-1-git-send-email-deepthy.ravi@ti.com>
In-Reply-To: <1312984992-19315-1-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108302307.47564.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 10 August 2011 16:03:12 Deepthy Ravi wrote:
> From: Abhilash K V <abhilash.kv@ti.com>
> 
> While resuming from the "suspended to memory" state,
> occasionally CCDC fails to get enabled and thus fails
> to capture frames any more till the next suspend/resume
> is issued.
> This is a race condition which happens only when a CCDC
> frame-completion ISR is pending even as ISP device's
> isp_pm_prepare() is getting called and only one buffer
> is left on the DMA queue.
> The DMA queue buffers are thus depleted which results in
> its underrun.So when ISP resumes there are no buffers on
> the queue (as the application which can issue buffers is
> yet to resume) to start video capture.
> This fix addresses this issue by dequeuing and enqueing
> the last buffer in isp_pm_prepare() after its DMA gets
> completed. Thus,when ISP resumes it always finds atleast
> one buffer on the DMA queue - this is true if application
> uses only 3 buffers.

How is that problem specific to the CCDC ? Can't it be reproduce at the 
preview engine or resizer output as well ?

-- 
Regards,

Laurent Pinchart
