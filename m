Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2LWLwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:52:14 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40048 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751082Ab2LWLwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:52:13 -0500
Message-ID: <1356263531.10873.6.camel@joe-AO722>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Joe Perches <joe@perches.com>
To: Andy Furniss <andyqos@ukfsn.org>
Cc: Borislav Petkov <bp@alien8.de>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Date: Sun, 23 Dec 2012 03:52:11 -0800
In-Reply-To: <50D6E491.3030801@ukfsn.org>
References: <20121222203547.GA5319@liondog.tnic>
	 <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com>
	 <20121223002507.GA12121@liondog.tnic>
	 <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com>
	 <20121223105527.GA6230@liondog.tnic> <50D6E491.3030801@ukfsn.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-23 at 11:01 +0000, Andy Furniss wrote:
> Borislav Petkov wrote:
> 
> > [   28.191072] radeon: `0' invalid for parameter `wb'
> >
> > although the whole driver blubber didn't appear on the console fterwards
> > aso something got turned off allright.
> >
> > Then, I went and tried "radeon.no_wb" where the driver blubber appeared
> > but AGP writeback was still enabled:
> 
> no_wb=1 should work.

Perhaps some of the module_param_named(,,int,) should be bool
Also, are all of the various permissions appropriate?

$ git grep module_param_named drivers/gpu/drm/radeon/
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(no_wb, radeon_no_wb, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(modeset, radeon_modeset, int, 0400);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(dynclks, radeon_dynclks, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(r4xx_atom, radeon_r4xx_atom, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(vramlimit, radeon_vram_limit, int, 0600);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(agpmode, radeon_agpmode, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(gartsize, radeon_gart_size, int, 0600);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(benchmark, radeon_benchmarking, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(test, radeon_testing, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(connector_table, radeon_connector_table, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(tv, radeon_tv, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(audio, radeon_audio, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(disp_priority, radeon_disp_priority, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(hw_i2c, radeon_hw_i2c, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(pcie_gen2, radeon_pcie_gen2, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(msi, radeon_msi, int, 0444);
drivers/gpu/drm/radeon/radeon_drv.c:module_param_named(lockup_timeout, radeon_lockup_timeout, int, 0444);


