Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1GNGwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:52:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1GNGwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:52:43 -0400
Date: Thu, 14 Jul 2011 16:52:31 +1000
From: NeilBrown <neilb@suse.de>
To: Qin Dehua <qindehua@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: PROBLEM: md/raid5 bug by commit 415e72d03
Message-ID: <20110714165231.0cda7762@notabene.brown>
In-Reply-To: <CA+gQ4teG7wKXk+zkZvHYWRCqtoLE=qQOcns9zeth+Dt-xPixTg@mail.gmail.com>
References: <CA+gQ4teG7wKXk+zkZvHYWRCqtoLE=qQOcns9zeth+Dt-xPixTg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jul 2011 13:58:39 +0800 Qin Dehua <qindehua@gmail.com> wrote:

> By bisecting, commit 415e72d03(md/raid5: Allow recovered part of
> partially recovered devices to be in-sync) was found as the cause of
> follow problem:
> 	* md1_raid5 or md1_raid6 process will hang(99% CPU usage) after
> repeatedly remove disk from then re-add disk to raid5 or raid6£¨there
> is also a dd process write to the raid continuously).
> 	
> Hardware platform is IOP 341 XScale processor(did not test on other
> platforms£©. The problem can be reproduced with this script:
> 
> { while true; do dd if=/dev/zero of=/dev/md1 bs=1M count=90000 >
> /dev/null 2>/dev/null;done; } &
> 
> while true;do
> 	mdadm /dev/md1 -f /dev/sda /dev/sdb
> 	sleep 1
> 	mdadm /dev/md1 -r /dev/sda /dev/sdb
> 	sleep 1
> 	mdadm /dev/md1 -a /dev/sda /dev/sdb
> 	sleep 6
> done

I cannot reproduce this on x86_64.

Can you find out more about the hanging process?  Maybe
  cat /proc/PROCESS-ID/stack

a few times and see where it is spending its time??

NeilBrown
