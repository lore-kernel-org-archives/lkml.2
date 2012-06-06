Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2FFLMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:12:14 -0400
Received: from plane.gmane.org ([80.91.229.3]:54989 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab2FFLMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:12:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Subject: freeze hard-lock with 3.5-rc1 with dynpm for radeon GPU [was Re:
 Linux 3.4 released]
Date: Wed, 06 Jun 2012 13:11:58 +0200
Message-ID: <4FCF3AFE.3010702@web.de>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com> <4FBBB11D.7020904@web.de> <20120522155345.GC14339@google.com> <4FBBC461.4060008@web.de> <20120522170320.GD14339@google.com> <jpglns$1uj$1@dough.gmane.org> <CAOS58YPMh_hbJ4a49j4p9H68n8U1LzMUuaxmHx57gVTkmfxF6A@mail.gmail.com> <4FBBEDF2.8060803@web.de> <20120523182457.GD18143@google.com> <4FBD40F4.4090201@web.de> <20120523202657.GB3933@htj.dyndns.org> <s5hehq87meg.wl%tiwai@suse.de> <4FBFA637.6000704@web.de> <s5hhav45jpo.wl%tiwai@suse.de> <4FBFD263.60908@web.de> <4FC2262D.2040105@web.de> <s5hbol86g1p.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
X-Gmane-NNTP-Posting-Host: p5b373413.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
In-Reply-To: <s5hbol86g1p.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote, on 05/28/12 07:16:
> At Sun, 27 May 2012 15:03:41 +0200,
> Jörg-Volker Peetz wrote:
>>
>> Hello,
>>
>> meanwhile I tried the support of vga-switcheroo for HD-audio from your git tree
>> without success.
>>
>> Since I'm not familiar with git I'll describe what I did:
>>
>> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>> $ cd linux
>> $ git reset --keep v3.4
>> $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
>> tags/hda-switcheroo
> 
> Pulling sound git tree branch onto 3.4 (or a tree without a proper
> update of DRM tree) is known to be broken because it misses a few fix
> commits in the VGA switcheroo part.
> 
> Linus already merged the HD-audio vga-switcheroo support in his tree.
> So, just pull Linus tree and use it as is.
> 
> If it still causes the problem, get debugfs output of vga switcheroo
> and the kernel messages before switching off D-GPU.
> 
> 
> Takashi

Hello Takashi, hello David,

I have managed to test 3.5-rc1 on my HP Pavilion dv7 notebook with two AMD GPU.
The problem I had with the USB web-cam is fixed:
using vgaswitcheroo to switch off the discrete GPU and the discrete HDMI audio via
  echo -n OFF > /sys/kernel/debug/vgaswitcheroo/switch
works and after starting X I'm able to activate the built-in USB web-cam with
guvcview. Thank you very much.

But now I have another regression: trying to use the power management method
"dynpm" via
  echo -n dynpm > /sys/class/drm/card0/device/power_method
even before mounting debugfs, lets the machine freeze with at least two trace
calls on the console screen. On the console only the last two lines of one call
trace and the last one are visible (machine is frozen). It says (typed by hand,
therefore, not complete):

...
---[ end trace a926a4156be75305 ]---
BUG: unable to handle kernel paging request at fffffffffffffff8
IP: [<ffffffff81045097>] kthread_data+0x7/0x10
PGD 1585067 PUD 1586067 PMD 0
Oops: 0000 [#2] SMP
CPU 1

...

Call Trace:
[< ... >] ? wq_worker_sleeping+0x8/0x80
   ...    ? __schedule+0x363/0x520
   ...    ? do_exit+0x552/0x850
   ...    ? oops_end+0x67/0x90
   ...    ? no_context+0x24e/0x279
   ...    ? do_page_fault+0x2bb/0x460

...

What to do next?
-- 
Best regards,
Jörg-Volker.





