Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab0FYFJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 01:09:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50750 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0FYFJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 01:09:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MZw4ibd6woE4LATlIWuhkRJaMYjyAta8dZ36V52HtSOgQZlKlMiu3iMvv5R6S0C+OX
         aXgNfd6TgMaJ6o5YtYCPJBxTaSy3VDQOP0H3bnYFoICQECrwYmm16kKrtHio/UdGuE5c
         eMHCfySONFfBQlpqQzhWmZK6rPtnLZYFLHEsQ=
MIME-Version: 1.0
In-Reply-To: <20100625133542.8047.A69D9226@jp.fujitsu.com>
References: <AANLkTim7CiW-yfugZUAHZCqLvXKgt9CwolCvbLGdCLAk@mail.gmail.com>
	<20100625133542.8047.A69D9226@jp.fujitsu.com>
Date: Fri, 25 Jun 2010 15:09:56 +1000
Message-ID: <AANLkTiniN949ew8asVksRw6EEBlcs2yy2pZ7Eir33oiy@mail.gmail.com>
Subject: Re: 2.6.35-rc1 system oom, many processes killed but memory not free
From: Andrew Hendry <andrew.hendry@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes I made a mistake setting up ramdisk too big, but not sure why it
allowed me to set it up like that.
I think after ramdisk used all the memory, even after unmounting then
other processes still cannot use it.
oom killer gets very aggressive but cannot fix problem.

I have updated to rc3 and will test again on weekend. I will turn on
mem leak checker, is there anything else i should configure?

On Fri, Jun 25, 2010 at 3:00 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> I left a 2.6.35-rc1 system, ubuntu 10.4/64 building randconfigs in a
>> ramdisk overnight.
>> /dev/ram0              9842848   5141780   4201068  56% /media/ramdisk
>
> your total memory size is 8GB, but ramdisk size is 9.8GB. it's odd settings.
>
>>
>> After about 3 hours oom killer started killing nearly all the
>> processes, but the memory is still not released. Could ramdisk cause
>> this? How can I find out what is still using all the memory?
>
> Could.
> but I'm unclear your case was happen by only ramdisk.
> Can you remove such ramdisk at once?
>
>>
>> cat /proc/meminfo
>> MemTotal:        8187304 kB
>> MemFree:          231976 kB
>> Buffers:             424 kB
>> Cached:            19728 kB
>> SwapCached:        51144 kB
>> Active:            14056 kB
>> Inactive:          72592 kB
>> Active(anon):      12900 kB
>> Inactive(anon):    53940 kB
>> Active(file):       1156 kB
>> Inactive(file):    18652 kB
>> Unevictable:           0 kB
>> Mlocked:               0 kB
>> SwapTotal:       1986556 kB
>> SwapFree:        1504676 kB
>> Dirty:                 0 kB
>> Writeback:         19720 kB
>> AnonPages:         32884 kB
>> Mapped:             4760 kB
>> Shmem:                 4 kB
>> Slab:              51652 kB
>> SReclaimable:      28816 kB
>> SUnreclaim:        22836 kB
>> KernelStack:        2880 kB
>> PageTables:        18484 kB
>> NFS_Unstable:          0 kB
>> Bounce:                0 kB
>> WritebackTmp:          0 kB
>> CommitLimit:     6080208 kB
>> Committed_AS:    1133944 kB
>> VmallocTotal:   34359738367 kB
>> VmallocUsed:      350936 kB
>> VmallocChunk:   34359369212 kB
>> HardwareCorrupted:     0 kB
>> HugePages_Total:       0
>> HugePages_Free:        0
>> HugePages_Rsvd:        0
>> HugePages_Surp:        0
>> Hugepagesize:       2048 kB
>> DirectMap4k:        7616 kB
>> DirectMap2M:     8372224 kB
>
>
>
>
