Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0CVMGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:06:09 -0400
Received: from mamba.nagafix.co.uk ([194.145.196.68]:59154 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753359Ab0CVMGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:06:04 -0400
Message-ID: <4BA75D1A.8010001@nagafix.co.uk>
Date: Mon, 22 Mar 2010 19:05:46 +0700
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Olivier Galibert <galibert@pobox.com>, Ingo Molnar <mingo@elte.hu>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <4BA67F12.6030501@nagafix.co.uk> <4BA68063.2050800@redhat.com> <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com>
In-Reply-To: <4BA68997.60406@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
>>>   I believe that -kernel use will be rare, though.  It's a lot 
>>> easier to keep everything in one filesystem.
>> Well, for what it's worth, I rarely ever use anything else. My 
>> virtual disks are raw so I can loop mount them easily, and I can also 
>> switch my guest kernels from outside... without ever needing to mount 
>> those disks.
>
> Curious, what do you use them for?
Various things, here is one use case which I think is under-used: 
read-only virtual disks with just one network application on them (no 
runlevels, sshd, user accounts, etc), a hell of a lot easier to maintain 
and secure than a full blown distro. Want a new kernel? boot a new VM 
and swap it for the old one with zero downtime (if your network app 
supports this sort of hot-swap - which a lot of cluster apps do)

Another reason for wanting to keep the kernel outside is to limit the 
potential points of failure: remove the partition table, remove the 
bootloader, remove even the ramdisk. Also makes it easier to switch to 
another solution (say UML) or another disk driver (as someone mentioned 
previously).
In virtualized environments I often prefer to remove the ability to load 
kernel modules too, for obvious reasons.

Hope this helps.

Antoine
