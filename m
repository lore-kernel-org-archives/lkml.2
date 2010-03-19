Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab0CSSh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:37:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:59944 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751273Ab0CSShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:37:24 -0400
X-Authenticated: #352556
X-Provags-ID: V01U2FsdGVkX1/fucAFKfnfSY4fWLgrVsDxV67jgrLhdXP31W2YNx
	+RREVpzsye3EzR
Message-ID: <4BA3C461.5060209@gmx.net>
Date: Fri, 19 Mar 2010 19:37:21 +0100
From: Joachim Otahal <Jou@gmx.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.8) Gecko/20100205 SeaMonkey/2.0.3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
CC: jin zhencheng <zhenchengjin@gmail.com>, neilb@suse.de,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG:write data to degrade raid5
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com> 	<4BA3C07A.8030204@gmx.net> <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
In-Reply-To: <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristleifur Daðason schrieb:
> On Fri, Mar 19, 2010 at 6:20 PM, Joachim Otahal <Jou@gmx.net 
> <mailto:Jou@gmx.net>> wrote:
>
>     jin zhencheng schrieb:
>
>         hi;
>
>         i use kernel is 2.6.26.2
>
>         what i do as follow:
>
>         1, I create a raid5:
>         mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
>         --metadata=1.0 --assume-clean
>
>         2, dd if=/dev/zero of=/dev/md5 bs=1M&
>
>         write data to this raid5
>
>         3, mdadm --manage /dev/md5 -f /dev/sda
>
>         4 mdadm --manage  /dev/md5 -f /dev/sdb
>
>         if i faild 2 disks ,then the OS kernel display OOP error and
>         kernel down
>
>         do somebody know why ?
>
>         Is MD/RAID5 bug ?
>
>
>     RAID5 can only tolerate ONE drive to fail of ALL members. If you
>     want to be able to fail two drives you will have to use RAID6 or
>     RAID5 with one hot-spare (and give it time to rebuild before
>     failing the second drive).
>     PLEASE read the documentation on raid levels, like on wikipedia.
>
>
> That is true,
>
> but should we get a kernel oops and crash if two RAID5 drives are 
> failed? (THAT part looks like a bug!)
>
> Jin, can you try a newer kernel, and a newer mdadm?
>
> -- Kristleifur
You are probably right.
My kernel version is "Debian 2.6.26-21lenny4", and I had no oopses 
during my hot-plug testing one the hardware I use md on. I think it may 
be the driver for his chips.

Jin:

Did you really use the whole drives for testing or loopback files or 
partitions on the drives? I never did my hot-plug testings with whole 
drives being in an array, only with partitions.

Joachim Otahal

