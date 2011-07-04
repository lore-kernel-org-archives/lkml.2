Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab1GDR7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:59:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:10562 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292Ab1GDR7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,474,1304319600"; 
   d="scan'208";a="21436781"
Date: Mon, 4 Jul 2011 19:59:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jin Park <jinyoungp@nvidia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] aat2870: Adding mfd, backlight and regulator drivers
Message-ID: <20110704175932.GU3021@sortiz-mobl>
References: <1309356412-23881-1-git-send-email-jinyoungp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309356412-23881-1-git-send-email-jinyoungp@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin,

On Wed, Jun 29, 2011 at 11:06:49PM +0900, Jin Park wrote:
> Changing subject because the patch was separated.
> Adding relevant maintainers for backlight and regulator.
> 
> Hi Samuel,
> 
> > Before reviewing this patch, could you please do the following:
> > 
> > 1) Split it into 3 actual patches: the MFD one, the regulator one and the
> > backlight one.
> I have separated the patch to mfd, backlight and regulator.
> 
> > 2) Add the relevant maintainers (See MAINTAINERS) if you want to get a proper
> > regulator and backlight driver review.
> I submitting the patches with relevant maintainers.
> 
> > You also need to take the io_lock mutex here, to prevent someone else to write
> > a different value to your register between your read and write.
> > So what you typically want is an unlocked version of aat2870_[read|write]
> > (let's say we call it __aat2870_[read|write]). Then your aat2870_[read|write]
> > become wrappers around the __aat2870_[read|write] with the lock taken. And
> > your update_bits routine can use __aat2870_[read|write] with the lock taken
> > from the beginning.
> I have modified mfd driver according to your comment.
All 3 patches applied, although I'd appreciate to get an ACK from the
backlight maintainer.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
