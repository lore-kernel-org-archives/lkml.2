Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab1BVK1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:27:53 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33415 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1BVK1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:27:52 -0500
Date: Tue, 22 Feb 2011 15:58:12 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Subject: Re: [CFS Bandwidth Control v4 0/7] Introduction
Message-ID: <20110222102812.GA9545@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <4D61D230.907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D61D230.907@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 10:47:12AM +0800, Xiao Guangrong wrote:
> On 02/16/2011 11:18 AM, Paul Turner wrote:
> > Hi all,
> > 
> > Please find attached v4 of CFS bandwidth control; while this rebase against
> > some of the latest SCHED_NORMAL code is new, the features and methodology are
> > fairly mature at this point and have proved both effective and stable for
> > several workloads.
> > 
> > As always, all comments/feedback welcome.
> > 
> 
> Hi Paul,
> 
> Thanks for the great features!
> 
> I applied the patchset to kvm tree, then tested with kvm guest, unfortunately,
> it seems don't work normally. 
> 
> The steps is follow:
> 
> # mount -t cgroup -o cpu none /mnt/
> # qemu-system-x86_64 -enable-kvm  -smp 4 -m 512M -drive file=fc64.img,index=0,media=disk
> 
> Don't do any configuration in cgroup, and run the kvm guest directly (don't use libvirt),
> the guest booted very slowly and i saw some "soft lockup" bugs reported in the guest,
> i also noticed one CPU usage is 100% for more than 60s and other CPUs is 10%~30% in the host
> when guest was booting.
> 
> And if cgroup is not mounted, the guest runs well.
> 

Hi Xiao Guangrong,

Thanks for testing the patches. I do see some soft lockups in the
guest when I mount the cgroup and start VM using qemu-kvm.

Will get back after further investigation.

Regards,
Bharata.
