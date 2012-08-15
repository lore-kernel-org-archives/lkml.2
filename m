Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2HOMLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:11:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2HOMLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:11:39 -0400
Date: Wed, 15 Aug 2012 14:11:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: picoLCD updates
In-Reply-To: <20120815114236.0f7db40e@neptune.home>
Message-ID: <alpine.LNX.2.00.1208151409500.7026@pobox.suse.cz>
References: <20120730213656.0a9f6d30@neptune.home> <alpine.LNX.2.00.1208151016221.7026@pobox.suse.cz> <20120815114236.0f7db40e@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Bruno Prémont wrote:

> > > [ 6383.521833] =============================================================================
> > > [ 6383.530020] BUG kmalloc-64 (Not tainted): Object already free
> > > [ 6383.530020] -----------------------------------------------------------------------------
> > > [ 6383.530020] 
> > > [ 6383.530020] INFO: Slab 0xdde0ea20 objects=51 used=40 fp=0xcef516e0 flags=0x40000080
> > > [ 6383.530020] INFO: Object 0xcef51190 @offset=400 fp=0xcef51f50
> > > [ 6383.530020] 
> > > [ 6383.530020] Bytes b4 cef51180: cc cc cc cc d0 12 f5 ce 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
> > > [ 6383.530020] Object cef51190: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > > [ 6383.530020] Object cef511a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > > [ 6383.530020] Object cef511b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > > [ 6383.530020] Object cef511c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> > > [ 6383.530020] Redzone cef511d0: bb bb bb bb                                      ....
> > > [ 6383.530020] Padding cef511d8: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> > > [ 6383.530020] Pid: 1922, comm: bash Not tainted 3.5.0-jupiter-00003-g8d858b1-dirty #2
> > > [ 6383.530020] Call Trace:
> > > [ 6383.530020]  [<c10bd3cc>] print_trailer+0x11c/0x130
> > > [ 6383.530020]  [<c10bd415>] object_err+0x35/0x40
> > > [ 6383.530020]  [<c10be809>] free_debug_processing+0x99/0x200
> > > [ 6383.530020]  [<c10bf77e>] __slab_free+0x2e/0x280
> > > [ 6383.530020]  [<c1322284>] ? hid_submit_out+0xa4/0x120
> > > [ 6383.530020]  [<c1322870>] ? __usbhid_submit_report+0xc0/0x3c0
> > > [ 6383.530020]  [<c10bfbda>] ? kfree+0xfa/0x110
> > > [ 6383.530020]  [<de932aa4>] ? picolcd_debug_out_report+0x8c4/0x8e0 [hid_picolcd]
> > > [ 6383.530020]  [<c10bfbda>] kfree+0xfa/0x110
> > > [ 6383.530020]  [<c1322284>] ? hid_submit_out+0xa4/0x120
> > > [ 6383.530020]  [<c1322284>] ? hid_submit_out+0xa4/0x120
> > > [ 6383.530020]  [<c1322284>] ? hid_submit_out+0xa4/0x120
> > > [ 6383.530020]  [<c1322284>] hid_submit_out+0xa4/0x120
> > > [ 6383.530020]  [<c1322908>] __usbhid_submit_report+0x158/0x3c0
> > > [ 6383.530020]  [<c1322c2b>] usbhid_submit_report+0x1b/0x30
> > > [ 6383.530020]  [<de930789>] picolcd_fb_reset+0xb9/0x180 [hid_picolcd]
> > > [ 6383.530020]  [<de930f1d>] picolcd_init_framebuffer+0x20d/0x2e0 [hid_picolcd]
> > > [ 6383.530020]  [<de92fb9c>] picolcd_probe+0x3cc/0x580 [hid_picolcd]
> > > [ 6383.530020]  [<c1319147>] hid_device_probe+0x67/0xf0
> > > [ 6383.530020]  [<c1282f97>] ? driver_sysfs_add+0x57/0x80
> > > [ 6383.530020]  [<c128329d>] driver_probe_device+0xbd/0x1c0
> > > [ 6383.530020]  [<c1318a1b>] ? hid_match_device+0x7b/0x90
> > > [ 6383.530020]  [<c12821e5>] driver_bind+0x75/0xd0
> > > [ 6383.530020]  [<c1282170>] ? driver_unbind+0x90/0x90
> > > [ 6383.530020]  [<c12818b7>] drv_attr_store+0x27/0x30
> > > [ 6383.530020]  [<c1114aec>] sysfs_write_file+0xac/0xf0
> > > [ 6383.530020]  [<c10c794c>] vfs_write+0x9c/0x130
> > > [ 6383.530020]  [<c10d4a1f>] ? sys_dup3+0x11f/0x160
> > > [ 6383.530020]  [<c1114a40>] ? sysfs_poll+0x90/0x90
> > > [ 6383.530020]  [<c10c7bbd>] sys_write+0x3d/0x70
> > > [ 6383.530020]  [<c13f2557>] sysenter_do_call+0x12/0x26
> > 
> > So I am wondering whether the path this happens on is
> > 
> >                 if (!test_bit(HID_OUT_RUNNING, &usbhid->iofl)) {
> >                         usbhid_restart_out_queue(usbhid);
> > 
> > in __usbhid_submit_report(). It would then indicate perhaps some race with 
> > iofl handling.
> 
> Huh, that specific test_bit hunk I can't find in __usbhid_submit_report,
> is that 3.6 material?
> I'm running my tests against 3.5...

I see. Alan Stern has fixed a huge pile of things in this area in 3.6-rc1. 
I have expected all of those to actually be on theoretical problems not 
ever having happened in the wild, but it might be that you are actually 
chasing on of those.

Could you please retest with latest Linus' tree (or at least eb055fd0560b) 
to see whether this hasn't actually been fixed already by Alan's series?

Thanks,

-- 
Jiri Kosina
SUSE Labs
