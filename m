Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1GOGzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:55:17 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41922 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1GOGzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:55:15 -0400
X-AuditID: b753bd60-a14abba0000019f4-91-4e1fe450ea67
X-AuditID: b753bd60-a14abba0000019f4-91-4e1fe450ea67
Message-ID: <4E1FE446.4040208@hitachi.com>
Date: Fri, 15 Jul 2011 15:55:02 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org,
        jcm@redhat.com, greg@kroah.com, dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com,
        stefanr@s5r6.in-berlin.de, hare@suse.de
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp> <20110708194501.GU6418@nb.net.home>
In-Reply-To: <20110708194501.GU6418@nb.net.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, karel

(2011/07/09 4:45), Karel Zak wrote:
> On Fri, Jul 08, 2011 at 05:45:47PM +0900, Nao Nishijima wrote:
>> This patch series provides an "alias name" of the disk into kernel and procfs
>> messages. The user can assign a preferred name to an alias name of the device.
>>
>> Based on previous discussion (*), I changed patches as follows
>> - This is "alias name"
>> - An "alias name" is stored in gendisk struct
>> - Add document to Documentation/ABI/testing/sysfs-block
>> - When the user changes an "alias name", kernel notifies udev
>>
>> (*) http://marc.info/?l=linux-scsi&m=130812625531219&w=2
>>
> 
> [...]
> 
>> [localhost]# cat /proc/partitions
>> major minor  #blocks  name
>>
>>    8        0   12582912 foo
>>    8        1   12582878 foo1
>>    8        0    8388608 sdb
>>    8        1     512000 sdb1
>>    8        2    7875584 sdb2
> 
>  If there is not /dev/foo and /sys/block/foo then the patch introduces
>  a REGRESSION. 
>  
>  The names from /proc/partitions are used in many applications
>  (libblkid, fdisk, ...) for many many years. The applications will not
>  work as expected.
> 

I think that it is not a regression when users do not set an alias name.
Of course, I am going to modify all these utils so that users can use
alias names.

The purpose of alias names is to unify the name of device which users
operate and see. Therefore, I think that users would like to get an
alias name from it, because currently they get a device name form it.

However, for who wants to use alias name only for dmesg, I have an
enhancement idea that users can choose alias names or device names in
procfs by sysctl (default is device names).

I would like to hear your opinion about this.

>  It's crazy to assume that all the applications will be improved to
>  translate the "pretty name" from /proc/partitions by /sys/block/<maj>:<min>.
> 
>  Note, it's pretty naive to expect that people will use the pretty
>  names for printk()/dmesg only. I'm absolutely sure that it's will be
>  expected (by end-users) in /etc/fstab, mount, df, fdisk, ...
> 
>  It's will be necessary to modify all these utils. 
> 

Yes, I am going to modify all these utils to support udev persistent
names(including alias name).

I had looked over some commands where those get a device name from.
Most of them get a device name from /proc/partitions, also other
commands get it from /etc/fstab, /sys/block/ or own device database.

I am going to modify those commands to get a device name from /dev/disk.

>  The patch is opening Pandora's box :-(
> 

Best regards,

-- 
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email： nao.nishijima.xt@hitachi.com
