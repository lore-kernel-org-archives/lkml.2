Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1LAH05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:26:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35401 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab1LAH0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:26:55 -0500
Date: Wed, 30 Nov 2011 23:26:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rakesh Iyer <riyer@nvidia.com>
Cc: "rydberg@euromail.se" <rydberg@euromail.se>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v1] Input: tegra-kbc - report wakeup key for some
 platforms.
Message-ID: <20111201072649.GE16816@core.coreip.homeip.net>
References: <1322685811-14060-1-git-send-email-riyer@nvidia.com>
 <20111130212022.GB3108@core.coreip.homeip.net>
 <1FC56210173BB445BD77F608D6FB8D034F3D1BB4BD@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FC56210173BB445BD77F608D6FB8D034F3D1BB4BD@HQMAIL03.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 02:14:03PM -0800, Rakesh Iyer wrote:
> Thanks Dmitry.
> 
> Since there can be multiple wake causes I wanted to isolate wake key
> generation to the case where keyboard actually generated the wake
> interrupt.

I do not think you can guarantee this though because if user touches
keyboard "too early", before your resume method had a chance to disable
kbc interrupt as a wakeup source, you are still going to get that
interrupt and deliver KEY_POWER even though KBC is not the actual wakeup
source.

So don't over-complicate it. If hardware can't detect actual key pressed
just emit KEY_POWER if a key was at any time between calls to
tegra_kbc_suspend() and tegra_kbc_resume().

BTW, could you please have your MUA wrap long lines around 75 column or so?

Thanks.

-- 
Dmitry
