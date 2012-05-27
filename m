Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab2E0NEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 09:04:00 -0400
Received: from plane.gmane.org ([80.91.229.3]:47903 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2E0ND7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 09:03:59 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Subject: Re: Linux 3.4 released
Date: Sun, 27 May 2012 15:03:41 +0200
Message-ID: <4FC2262D.2040105@web.de>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com> <4FBBB11D.7020904@web.de> <20120522155345.GC14339@google.com> <4FBBC461.4060008@web.de> <20120522170320.GD14339@google.com> <jpglns$1uj$1@dough.gmane.org> <CAOS58YPMh_hbJ4a49j4p9H68n8U1LzMUuaxmHx57gVTkmfxF6A@mail.gmail.com> <4FBBEDF2.8060803@web.de> <20120523182457.GD18143@google.com> <4FBD40F4.4090201@web.de> <20120523202657.GB3933@htj.dyndns.org> <s5hehq87meg.wl%tiwai@suse.de> <4FBFA637.6000704@web.de> <s5hhav45jpo.wl%tiwai@suse.de> <4FBFD263.60908@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
X-Gmane-NNTP-Posting-Host: p5b3717bc.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
In-Reply-To: <4FBFD263.60908@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

meanwhile I tried the support of vga-switcheroo for HD-audio from your git tree
without success.

Since I'm not familiar with git I'll describe what I did:

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
$ cd linux
$ git reset --keep v3.4
$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
tags/hda-switcheroo

This resulted in a merge conflict for file
drivers/gpu/drm/i915/intel_ringbuffer.c which I didn't resolve since both of my
GPU are AMD radeon chips.

$ cp -p /boot/config-3.4.0 .config
$ make oldconfig
$ make
$ make modules_install

After installing kernel and system map (I don't use an initrd) , I restarted the
notebook. Before starting X, when I call the script which should mount debugfs
and switche off the discrete GPU, the system freezes.
I haven't written down all of the text on the console. It seems to be a sequence
of bugs, but I couldn't scroll back. The last stack trace begins with

... wq_worker_sleeping+0x8/0x80
... __scheduler+0x35b/0x510
... do_exit+0x542/0x830

-- 
Best regards,
Jörg-Volker.


