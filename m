Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1AVCQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 21:16:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab1AVCQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 21:16:00 -0500
Subject: Re: SELinux/SMACK/TOMOYO: ioctl permissions handling is wrong
 andnonsensicle
From: Eric Paris <eparis@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Fri, 21 Jan 2011 21:15:49 -0500
In-Reply-To: <201101221101.JJB35923.OFJOOtMFSQFLVH@I-love.SAKURA.ne.jp>
References: <1295638239.3403.15.camel@localhost.localdomain>
	 <201101221101.JJB35923.OFJOOtMFSQFLVH@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295662551.2914.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-22 at 11:01 +0900, Tetsuo Handa wrote:
> Eric Paris wrote:
> > I'm planning to revert this SELinux commit, but I want other LSM authors
> > to realize that (assuming I'm not completely off in the woods somewhere)
> > you should take a look at your ioctl permissions checking as well....
> 
> Since the mapping of ioctl cmd number and what the kernel does with that number
> is unknown for LSM modules, TOMOYO does not use permission bits.
> TOMOYO simply checks ioctl cmd number value passed to ioctl() requests.
> For example,
> 
>   file ioctl /dev/tty0 0x4B4E
>   file ioctl /dev/console 0x5402
>   file ioctl /dev/snd/controlC0 0x80045500
>   file ioctl socket:[family=2:type=1:protocol=6] 0x8942
>   file ioctl socket:[family=2:type=2:protocol=17] 0x8913
> 
>   http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/centos5.5/domain_policy.conf?v=policy-sample
> 
> So, I think nothing to change for TOMOYO.

You are correct, I thought I saw you guys doing something similar, but
that is clearly not the case.  It's just SELinux and SMACK that are
doing it wrong.

-Eric


