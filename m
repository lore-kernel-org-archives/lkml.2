Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab2EWBRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab2EWBRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:17:08 -0400
Date: Tue, 22 May 2012 21:17:01 -0400
From: Dave Jones <davej@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.4+ tty lockdep trace
Message-ID: <20120523011701.GA15255@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20120523002645.GA3490@redhat.com>
 <CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:06:22AM +0800, Ming Lei wrote:

 > > [   43.375802] stack backtrace:
 > > [   43.375841] Pid: 639, comm: sshd Not tainted 3.4.0+ #24
 > > [   43.375882] Call Trace:
 > > [   43.377572]  [<ffffffff810b4604>] __lock_acquire+0x1584/0x1aa0
 > > [   43.379286]  [<ffffffff810b51e2>] lock_acquire+0x92/0x1f0
 > > [   43.380995]  [<ffffffff81656d57>] ? tty_lock+0x37/0x80
 > > [   43.382700]  [<ffffffff816534f1>] mutex_lock_nested+0x71/0x3b0
 > > [   43.384403]  [<ffffffff81656d57>] ? tty_lock+0x37/0x80
 > > [   43.386094]  [<ffffffff81085521>] ? get_parent_ip+0x11/0x50
 > > [   43.387794]  [<ffffffff81656d57>] ? tty_lock+0x37/0x80
 > > [   43.389480]  [<ffffffff8165a68d>] ? sub_preempt_count+0x6d/0xd0
 > > [   43.391176]  [<ffffffff813b0243>] ? tty_release+0x1c3/0x5d0
 > > [   43.393003]  [<ffffffff81656d57>] tty_lock+0x37/0x80
 > > [   43.394867]  [<ffffffff81656dc3>] tty_lock_pair+0x23/0x5c
 > > [   43.396671]  [<ffffffff813b024e>] tty_release+0x1ce/0x5d0
 > > [   43.398462]  [<ffffffff811a765c>] fput+0x12c/0x300
 > > [   43.400292]  [<ffffffff811a23a9>] filp_close+0x69/0xa0
 > > [   43.402084]  [<ffffffff811a2f2d>] sys_close+0xad/0x1a0
 > > [   43.403871]  [<ffffffff8165e652>] system_call_fastpath+0x16/0x1b
 > 
 > We have one patch to address the problem, could you test it from the link below?
 > 
 >         http://marc.info/?l=linux-kernel&m=133765211309247&w=2

Yes, that seems to fix it. Thanks.

	Dave





