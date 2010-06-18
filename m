Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab0FRVOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:14:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab0FRVOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:14:00 -0400
Subject: Re: [PATCH] DRM / radeon / PM: Do not evict VRAM during freeze
 phase of hibernation
From: Dave Airlie <airlied@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ondrej Zary <linux@rainbow-software.org>
In-Reply-To: <201006182221.57333.rjw@sisk.pl>
References: <201006182221.57333.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Jun 2010 07:08:16 +1000
Message-ID: <1276895296.6513.3.camel@t60prh>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 22:21 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> I have recently noticed a 55 sec. delay during the "device freeze"
> phase of hibernation on my test-bed HP nx6325.  Due to the 100%
> reproducibility of it I was able to narrow it down to
> radeon_suspend_kms() and then it turned out that the delay occured
> somewhere in radeon_bo_evict_vram().  However, it doesn't seem really
> necessary or even very useful to me to evict VRAM at this particular
> point, because we're going to create an image and bring the device
> back to the fully functional state in a little while.  Thus, I think
> the VRAM evicition can be skipped for state.event == PM_EVENT_FREEZE,
> which makes the delay go away.

I'm not 100% sure of the hibernate sequencing and its early in the
morning, but we want to evict VRAM before image building so we can have
the contents of VRAM in the image so we can restore them on resume. Does
this just avoid evicting them a second time after we created the image?

Dave.


