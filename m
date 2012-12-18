Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2LRQsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:48:36 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:58797 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755233Ab2LRQse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:48:34 -0500
Message-ID: <1355849302.26487.15.camel@thor.lan>
Subject: Re: [PATCH v2 00/11] tty: Fix buffer work access-after-free
From: Peter Hurley <peter@hurleysoftware.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 11:48:22 -0500
In-Reply-To: <CA+1xoqeRfg7iY_vS7nVG6W7hqLOmVUmJaz-c4_Sr3h_XMg++sg@mail.gmail.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	 <CA+1xoqeRfg7iY_vS7nVG6W7hqLOmVUmJaz-c4_Sr3h_XMg++sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 10:44 -0500, Sasha Levin wrote:
> I'm still seeing that warning with the new patch series:
> 
> [  549.561769] ------------[ cut here ]------------
> [  549.598755] WARNING: at drivers/tty/n_tty.c:160 n_tty_set_room+0xff/0x130()
> [  549.604058] scheduling buffer work for halted ldisc
> [  549.607741] Pid: 9417, comm: trinity-child28 Tainted: G      D W
> 3.7.0-next-20121217-sasha-00023-g8689ef9 #219
> [  549.652580] Call Trace:
> [  549.662754]  [<ffffffff81c432cf>] ? n_tty_set_room+0xff/0x130
> [  549.665458]  [<ffffffff8110cae7>] warn_slowpath_common+0x87/0xb0
> [  549.668257]  [<ffffffff8110cb71>] warn_slowpath_fmt+0x41/0x50
> [  549.671007]  [<ffffffff81c432cf>] n_tty_set_room+0xff/0x130
> [  549.673268]  [<ffffffff81c44597>] reset_buffer_flags+0x137/0x150
> [  549.675607]  [<ffffffff81c45b71>] n_tty_open+0x131/0x1c0

This is a false-positive warning that means I need to refine the warning
condition to not include this code path.

Thanks again.

> [  549.677699]  [<ffffffff81c47824>] tty_ldisc_open.isra.5+0x54/0x70
> [  549.680147]  [<ffffffff81c482bf>] tty_ldisc_hangup+0x11f/0x1e0
> [  549.682409]  [<ffffffff81c3fa17>] __tty_hangup+0x137/0x440
> [  549.684634]  [<ffffffff81c3fd49>] tty_vhangup+0x9/0x10
> [  549.686443]  [<ffffffff81c4a42c>] pty_close+0x14c/0x160
> [  549.688446]  [<ffffffff81c41225>] tty_release+0xd5/0x490
> [  549.690460]  [<ffffffff8127d8a2>] __fput+0x122/0x250
> [  549.692577]  [<ffffffff8127d9d9>] ____fput+0x9/0x10
> [  549.694534]  [<ffffffff811348c2>] task_work_run+0xb2/0xf0
> [  549.696349]  [<ffffffff81113c6d>] do_exit+0x36d/0x580
> [  549.698286]  [<ffffffff8107d964>] ? syscall_trace_enter+0x24/0x2e0
> [  549.702729]  [<ffffffff81113f4a>] do_group_exit+0x8a/0xc0
> [  549.706775]  [<ffffffff81113f92>] sys_exit_group+0x12/0x20
> [  549.711088]  [<ffffffff83cfab18>] tracesys+0xe1/0xe6
> [  549.728001] ---[ end trace 73eb41728f11f87e ]---



