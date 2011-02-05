Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1BERXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:23:25 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:37901 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab1BERXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:23:25 -0500
Date: Sat, 5 Feb 2011 19:23:19 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dell-wmi: Received unknown WMI event (0x11)
Message-ID: <20110205172319.GA2619@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110205171807.GA3738@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205171807.GA3738@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 05, 2011 at 07:18:07PM +0200, Felipe Balbi wrote:
> Hi,
> 
> I believe this is a regression as it was working on 2.6.37 but with
> 2.6.38-rc3 I can't burn DVDs with my latitute e6410. When I put a blank
> double layer DVD on the drive I get:
> 
> [  393.020537] dell-wmi: Received unknown WMI event (0x11)
> [  832.336855] dell-wmi: Received unknown WMI event (0x11)
> [  832.409353] dell-wmi: Received unknown WMI event (0x11)
> [  833.621140] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [  834.367611] dell-wmi: Received unknown WMI event (0x11)
> [ 1001.665940] dell-wmi: Received unknown WMI event (0x11)
> [ 1002.846845] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 1003.591459] dell-wmi: Received unknown WMI event (0x11)
> [ 1063.690326] dell-wmi: Received unknown WMI event (0x11)
> [ 1064.942777] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 1644.787491] dell-wmi: Received unknown WMI event (0x11)
> [ 1644.849026] dell-wmi: Received unknown WMI event (0x11)
> [ 1645.971790] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 1646.719084] dell-wmi: Received unknown WMI event (0x11)
> [ 2317.273481] dell-wmi: Received unknown WMI event (0x11)
> [ 2318.540645] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 2319.285487] dell-wmi: Received unknown WMI event (0x11)
> [ 2379.364740] dell-wmi: Received unknown WMI event (0x11)
> [ 2877.001258] dell-wmi: Received unknown WMI event (0x11)
> [ 2878.211188] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 2878.957282] dell-wmi: Received unknown WMI event (0x11)
> [ 2903.422959] dell-wmi: Received unknown WMI event (0x11)
> [ 2904.609272] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 2905.352451] dell-wmi: Received unknown WMI event (0x11)
> [ 2965.454915] dell-wmi: Received unknown WMI event (0x11)
> [ 2966.701330] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 3981.339257] dell-wmi: Received unknown WMI event (0x11)
> [ 3982.510612] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 3983.254770] dell-wmi: Received unknown WMI event (0x11)
> [ 4045.466929] dell-wmi: Received unknown WMI event (0x11)
> [ 4046.631137] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 4047.391614] dell-wmi: Received unknown WMI event (0x11)
> [ 4107.480071] dell-wmi: Received unknown WMI event (0x11)
> [ 4108.631339] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 4731.506881] dell-wmi: Received unknown WMI event (0x11)
> [ 4732.646424] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 4733.391238] dell-wmi: Received unknown WMI event (0x11)
> [ 6025.385179] cdrom: This disc doesn't have any tracks I recognize!
> 
> and when I try to burn anything (well, a dry-run burn) I get:
> 
> $ growisofs -dvd-compat -use-the-force-luke=dao -use-the-force-luke=break:1913760 -speed=2 -Z /dev/dvd=my-backup-files.iso -dry-run
> :-( /dev/dvd: CD_ROM_MEDIA_CHANGED ioctl failed: Inappropriate ioctl for device
> 
> Has anyone seen that before ? I'll try to reboot on 2.6.37 and try again
> just to be sure and will report back on the differences.

yes, it works like a charm on 2.6.37:

$ dmesg
[   91.522079] cdrom: This disc doesn't have any tracks I recognize!
$ growisofs -dvd-compat -use-the-force-luke=dao -use-the-force-luke=break:1913760 -speed=2 -Z /dev/dvd=my-backup-files.iso -dry-run
Executing 'builtin_dd if=cpx-mja.iso of=/dev/dvd obs=32k seek=0'

What more information can I grab which would help debugging ? I guess I
could bisect and try to find the offending commit, but that'll take a
few days.

-- 
balbi
