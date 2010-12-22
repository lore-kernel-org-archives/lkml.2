Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0LVDTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 22:19:30 -0500
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:33216 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640Ab0LVDT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 22:19:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=IkA1EHLV09df586KXUN42apHG1IqUad2jOaf2M74Di6Z5CQSmIc9enM/ACIYk/Dj;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D116E40.1060204@earthlink.net>
Date: Tue, 21 Dec 2010 22:19:28 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
References: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79044a379fa2dd1da4d3d9177fbb76acdd350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 06:43 PM, Dave Airlie wrote:
> Hi,
>
> meant to get this out earlier, but I've been off sick as well as having a
> sick kid, also meant a few things piled up when I wasn't looking
>
> contains a revert for reported regression in intel and also one in radeon,
> a few radeon fixes, one for a 15s resume time on certain laptops, and one
> to fix gpu reset on some gpus,
>
> Dave.
>
> The following changes since commit a4851d8f7d6351a395d36ae8fdcf41745a832d76:
>
>    Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2010-12-15 12:41:17 -0800)
>
> are available in the git repository at:
>
>    ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes
>
> Alex Deucher (7):
>        drm/radeon/kms: disable ss fixed ref divide
>        drm/radeon/kms: disable the r600 cb offset checker for linear surfaces
>        drm/radeon/kms/evergreen: flush hdp cache when flushing gart tlb
>        drm/radeon/kms: fix evergreen asic reset
>        drm/radeon/kms/evergreen: reset the grbm blocks at resume and init
>        drm/radeon/kms: reorder display resume to avoid problems
>        drm/radeon/kms: fix bug in r600_gpu_is_lockup
>
> Benjamin Herrenschmidt (1):
>        drm/radeon: Add early unregister of firmware fb's
>
> Chris Wilson (5):
>        drm/i915/ringbuffer: Handle wrapping of the autoreported HEAD
>        drm/i915/sdvo: Only use the SDVO pin if it is in the valid range
>        agp/intel: Fix missed cached memory flags setting in i965_write_entry()
>        drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
>        drm: Include the connector name in the output_poll_execute() debug message
>
> Dave Airlie (3):
>        Merge remote branch 'intel/drm-intel-fixes' of /ssd/git/drm-next into drm-fixes
>        drm/radeon: use aperture size not vram size for overlap tests
>        Revert "drm: Don't try and disable an encoder that was never enabled"
>
> David Flynn (1):
>        drm/i915/dp: Fix I2C/EDID handling with active DisplayPort to DVI converter
>
>   drivers/char/agp/intel-gtt.c            |   11 +++++++-
>   drivers/gpu/drm/drm_crtc_helper.c       |    7 ++++-
>   drivers/gpu/drm/i915/intel_bios.c       |    2 +-
>   drivers/gpu/drm/i915/intel_dp.c         |   37 +++++++++++++++++++++++++------
>   drivers/gpu/drm/i915/intel_ringbuffer.c |   19 ++++++---------
>   drivers/gpu/drm/i915/intel_ringbuffer.h |    5 ++-
>   drivers/gpu/drm/i915/intel_sdvo.c       |    9 +++++--
>   drivers/gpu/drm/radeon/atombios_crtc.c  |    7 +++--
>   drivers/gpu/drm/radeon/evergreen.c      |   27 ++++++++++------------
>   drivers/gpu/drm/radeon/evergreend.h     |    1 +
>   drivers/gpu/drm/radeon/r600.c           |   10 ++++++-
>   drivers/gpu/drm/radeon/r600_cs.c        |    9 +++----
>   drivers/gpu/drm/radeon/radeon_device.c  |    9 +++----
>   drivers/gpu/drm/radeon/radeon_drv.c     |   19 ++++++++++++++++
>   drivers/gpu/drm/radeon/radeon_fb.c      |    2 +-
>   15 files changed, 115 insertions(+), 59 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
Hello,

I am new to git and can't figure out how to get these changes.

I have done a git clone of 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
What next?

Thanks

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



