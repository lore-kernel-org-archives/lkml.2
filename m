Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab1AVCBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 21:01:25 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:52973 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1AVCBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 21:01:23 -0500
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: SELinux/SMACK/TOMOYO: ioctl permissions handling is wrong andnonsensicle
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1295638239.3403.15.camel@localhost.localdomain>
In-Reply-To: <1295638239.3403.15.camel@localhost.localdomain>
Message-Id: <201101221101.JJB35923.OFJOOtMFSQFLVH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 22 Jan 2011 11:01:18 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> I'm planning to revert this SELinux commit, but I want other LSM authors
> to realize that (assuming I'm not completely off in the woods somewhere)
> you should take a look at your ioctl permissions checking as well....

Since the mapping of ioctl cmd number and what the kernel does with that number
is unknown for LSM modules, TOMOYO does not use permission bits.
TOMOYO simply checks ioctl cmd number value passed to ioctl() requests.
For example,

  file ioctl /dev/tty0 0x4B4E
  file ioctl /dev/console 0x5402
  file ioctl /dev/snd/controlC0 0x80045500
  file ioctl socket:[family=2:type=1:protocol=6] 0x8942
  file ioctl socket:[family=2:type=2:protocol=17] 0x8913

  http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/centos5.5/domain_policy.conf?v=policy-sample

So, I think nothing to change for TOMOYO.
