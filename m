Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2H0Sed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:34:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2H0Sea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:34:30 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=06lJtMxUfagA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=ERDPx3maok4A:10 a=meVymXHHAAAA:8 a=SOHA6BCROhLeC_dYscAA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Date: Mon, 27 Aug 2012 14:34:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Watts <akwatts@ymail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG]: fsnotify oops on 3.5.2
Message-ID: <20120827183428.GA21402@home.goodmis.org>
References: <20120826204453.GA10707@ymail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826204453.GA10707@ymail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 03:44:54PM -0500, Andrew Watts wrote:
> Hi.
> 
> The system runs kernel 3.5.2 with ext3. (note: kernel is patched with
> overlayfs-v13).
> 

Thanks for pointing out that the kernel is patched with overlayfs. As
the crash is within the filesystem, it looks to be a bug with that
patch. You may want to report this bug to them.

-- Steve

> ==

> BUG: unable to handle kernel NULL pointer dereference at 00000064
> IP: [<c1109b7d>] fsnotify+0x8b/0x270
> *pde = 00000000
> Oops: 0000 [#1]
> Pid: 14083, comm: firefox Tainted: G O 3.5.2
> EIP: 0060:[<c1109b7d>] EFLAGS: 00210246 CPU: 0
> EIP is at fsnotify+0x8b/0x270
> EAX: 00000000 EBX: fffffff0 ECX: f5988910 EDX: f5988910
> ESI: 00000010 EDI: 00000000 EBP: dea1de5c ESP: dea1de14
> DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> CR0: 80050033 CR2: 00000064 CR3: 34c52000 CR4: 000007d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
> Process firefox (pid: 14083, ti=dea1c000 task=ed2d1880 task.ti=dea1c000)
> Stack:
> dea1de34 c10ee498 00000000 dea1deec dea1df78 00008000 00000001 c10f21c3
> eeb43688 f5988910 00000010 dea1de48 00000000 00000000 00000000 eeb43680
> 00000010 f6003600 dea1de8c c10de255 00000001 00000000 00000000 00000000
> Call Trace:
> [<c10ee498>] ? dput+0x156/0x1c5
> [<c10f21c3>] ? mntput+0x19/0x28
> [<c10de255>] fput+0x196/0x1ed
> [<c10e5435>] release_open_intent+0x1d/0x29
> [<c10e8b03>] path_openat+0xc5/0x33f
> [<c10e8e41>] do_filp_open+0x2a/0x79
> [<c10f105e>] ? alloc_fd+0x5c/0xcb
> [<c10e538a>] ? getname_flags+0x31/0xb1
> [<c10dc553>] do_sys_open+0xef/0x1da
> [<c10dc692>] sys_open+0x27/0x2f
> [<c1573f13>] sysenter_do_call+0x12/0x22
> [<c1560000>] ? netlbl_mgmt_add_common+0x1ec/0x306
> Code: 02 00 00 b8 20 82 93 c1 e8 41 35 f4 ff 89 45 d0 8b 4d dc 85 b1 24 01 00 00 0f 85 2b 01 00 00 85 db 0f 84 37 01 00 00 85 ff 75 09 <85> 73 74 0f 84 2a 01 00 00 8b 43 70 89 45 ec 8b 4d dc 8b 91 28
> EIP: [<c1109b7d>] fsnotify+0x8b/0x270 SS:ESP 0068:dea1de14
> CR2: 0000000000000064
> ---[ end trace b9a1d764aab1963e ]---

