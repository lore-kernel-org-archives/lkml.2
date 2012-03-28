Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2C1AOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:14:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab2C1AOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:14:05 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=1W9--IY4QYAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=b8VgSBC0AAAA:8 a=lJCV1Y1Bzi-MoaYZkOgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332893642.23924.139.camel@gandalf.stny.rr.com>
Subject: [BUG] Warning at radeon_object.c:236 with latest Linus kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Cc: David Airlie <airlied@linux.ie>,
        Michel =?UTF-8?Q?D=C3=83=E2=82=ACnzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Date: Tue, 27 Mar 2012 20:14:02 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a test box that is triggering the following:

------------[ cut here ]------------
WARNING: at /home/rostedt/work/git/linux-trace.git/drivers/gpu/drm/radeon/radeon_object.c:236 radeon_bo_pin_restricted+0x67/0x137 [radeon]()
Hardware name: Precision WorkStation 470    
Modules linked in: radeon(+) ttm drm_kms_helper drm i2c_algo_bit^M
Pid: 863, comm: modprobe Not tainted 3.3.0-test+ #54
Call Trace:
 [<ffffffff810411ed>] warn_slowpath_common+0x83/0x9b
 [<ffffffff8104121f>] warn_slowpath_null+0x1a/0x1c
 [<ffffffffa009a718>] radeon_bo_pin_restricted+0x67/0x137 [radeon]
 [<ffffffffa009cdca>] radeon_crtc_do_set_base+0x117/0x473 [radeon]
 [<ffffffffa009d156>] radeon_crtc_set_base+0x1a/0x1c [radeon]
 [<ffffffffa009d181>] radeon_crtc_mode_set+0x29/0x84d [radeon]
 [<ffffffffa009cc0e>] ? radeon_crtc_dpms+0x18b/0x194 [radeon]
 [<ffffffffa0050611>] drm_crtc_helper_set_mode+0x27f/0x3fa [drm_kms_helper]^M
 [<ffffffffa005137b>] drm_crtc_helper_set_config+0x6bc/0x93d [drm_kms_helper]
 [<ffffffffa004f728>] drm_fb_helper_set_par+0x70/0xb9 [drm_kms_helper]
 [<ffffffff812a2386>] fbcon_init+0x31e/0x417
 [<ffffffff81300962>] visual_init+0xbc/0x113
 [<ffffffff81300dc0>] bind_con_driver+0x1af/0x2cd
 [<ffffffff81300f1b>] take_over_console+0x3d/0x4a
 [<ffffffff8129f318>] fbcon_takeover+0x5c/0x96
 [<ffffffff812a2aaf>] fbcon_event_notify+0x2d7/0x624
 [<ffffffff8152f70d>] notifier_call_chain.isra.2+0x6a/0x97
 [<ffffffff810648d8>] __blocking_notifier_call_chain+0x6a/0x87
 [<ffffffff81064909>] blocking_notifier_call_chain+0x14/0x16
 [<ffffffff81294d9b>] fb_notifier_call_chain+0x1b/0x1d
 [<ffffffff81296bfe>] register_framebuffer+0x254/0x276
 [<ffffffffa004f94a>] drm_fb_helper_single_fb_probe+0x1d9/0x27b [drm_kms_helper]
 [<ffffffffa004fbae>] drm_fb_helper_initial_config+0x1c2/0x1d6 [drm_kms_helper]
 [<ffffffffa004ed6d>] ? kzalloc.constprop.10+0xe/0x10 [drm_kms_helper]
 [<ffffffff81127119>] ? __kmalloc+0x122/0x134
 [<ffffffffa00a8557>] radeon_fbdev_init+0xac/0xb8 [radeon]
 [<ffffffffa00a479d>] radeon_modeset_init+0x70a/0x73f [radeon]
 [<ffffffffa0089520>] radeon_driver_load_kms+0x106/0x13d [radeon]
 [<ffffffffa0011dae>] drm_get_pci_dev+0x15c/0x258 [drm]
 [<ffffffffa00e6f79>] radeon_pci_probe+0x9d/0xa5 [radeon]
 [<ffffffff8127ffcb>] local_pci_probe+0x44/0x75
 [<ffffffff8128120a>] pci_device_probe+0xcd/0xfc
 [<ffffffff813225e6>] driver_probe_device+0x136/0x2eb
 [<ffffffff813227fa>] __driver_attach+0x5f/0x83
 [<ffffffff8132279b>] ? driver_probe_device+0x2eb/0x2eb
 [<ffffffff81320b74>] bus_for_each_dev+0x5c/0x88
 [<ffffffff81322042>] driver_attach+0x1e/0x20
 [<ffffffff81321bb9>] bus_add_driver+0xd4/0x22a
 [<ffffffff81322ca7>] driver_register+0x91/0xfe
 [<ffffffff8128142a>] __pci_register_driver+0x66/0xc4
 [<ffffffffa0011f34>] drm_pci_init+0x8a/0xef [drm]
 [<ffffffffa0131000>] ? 0xffffffffa0130fff
 [<ffffffffa01310e7>] radeon_init+0xe7/0xe9 [radeon]
 [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
 [<ffffffff81098b7a>] sys_init_module+0x17da/0x1a41
 [<ffffffff81532a29>] system_call_fastpath+0x16/0x1b
---[ end trace e08cb31255dbe358 ]---


You can get the full dmesg here:

http://rostedt.homelinux.com/private/dmesg-bxf-20120327

-- Steve


