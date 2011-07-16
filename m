Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1GPLkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:40:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58978 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1GPLkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:40:40 -0400
X-AuditID: b753bd60-a1479ba0000050a4-bb-4e2178b424e0
X-AuditID: b753bd60-a1479ba0000050a4-bb-4e2178b424e0
Message-ID: <4E2178AB.1080007@hitachi.com>
Date: Sat, 16 Jul 2011 20:40:27 +0900
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
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp> <20110708194501.GU6418@nb.net.home> <4E1FE446.4040208@hitachi.com> <20110715124806.GH3486@nb.net.home>
In-Reply-To: <20110715124806.GH3486@nb.net.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Karel

Thank you for your comments.

(2011/07/15 21:48), Karel Zak wrote:
> On Fri, Jul 15, 2011 at 03:55:02PM +0900, Nao Nishijima wrote:
>>>  If there is not /dev/foo and /sys/block/foo then the patch introduces
>>>  a REGRESSION. 
>>>  
>>>  The names from /proc/partitions are used in many applications
>>>  (libblkid, fdisk, ...) for many many years. The applications will not
>>>  work as expected.
>>>
>>
>> I think that it is not a regression when users do not set an alias name.
>> Of course, I am going to modify all these utils so that users can use
>> alias names.
>>
>> The purpose of alias names is to unify the name of device which users
>> operate and see. Therefore, I think that users would like to get an
>> alias name from it, because currently they get a device name form it.
>>
>> However, for who wants to use alias name only for dmesg, I have an
>> enhancement idea that users can choose alias names or device names in
>> procfs by sysctl (default is device names).
> 
>>From my point of view
> 
>     dmesg | grep <alias>
> 
> seems a little bit problematic, because for example initial messages
> for the device will be invisible. In the log will be messages with
> original canonical names and another (later) messages with aliases, you
> can also change the alias, etc. Seems like a mess. The log should be
> consistent...
> 
> I think it would be better to use always only canonical names in the
> kernel log and translate to something more user-friendly in userspace.
> For example if you add some meta-information to the kernel log then we
> can improve dmesg(1) to translate the canonical names to aliases.
> 
>  printk(KERN_INFO "this is info about %{device}s", device);
> 
>  <5>[105221.774534]{device=sda} this is info about sda
> 
> or whatever... (this is a nice topic with many colors for the bike
> shed:-)
> 
>> I would like to hear your opinion about this.
> 
> If you want to modify all the userspace utils then you don't have to
> modify /proc/partitions :-)
> 
> You can keep the standard names in /proc/partitions (so the file will
> be compatible with /sys and /dev) and you can modify all the utils to
> translate the canonical device names to aliases. The result will be
> the same, except "cat /proc/partitions" -- but I think that instead of
> "cat" you can use "lsblk".
> 

"lsblk" is great. (Sorry, I didn't know this command until now)

I think it would be good that users can get alias name from BOTH of
"lsblk" and "/proc/partitions", because users expect to see same name in
kernel output and command output　as they can see now.

In kernel message, I think that "alias name" is necessary. Because those
logs are output when kernel crashes, it outputs kernel message to serial
console. In that case, it's hard to convert canonical device name to
alias name.

> If you add only the attribute (alias name) to the /sys then you don't
> have to care if all the utils are already modified.
> 
> Anyway, I still agree with Kay and Greg -- the proper solution
> is to improve printk() and dmesg(1). The aliases could be implemented 
> in userspace by udev /dev/disk/by-alias/<cool_name> symlinks.
> 

Best regards,

-- 
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email： nao.nishijima.xt@hitachi.com
