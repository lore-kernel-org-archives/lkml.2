Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0KVTBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:01:25 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:56620 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab0KVTBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:01:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=N/Hi1Fql4wUpwqGYNyyWxBWT7KufWdHMYuF6c7A+Z5EjRTQjEWUhPqRNFirMO+Jxt8
         fQxov5QxfEIbRcBgLeUDjye+Ymbsgfk2UmrQbaWKDGfC04Vi4bX6bxIyKHTcpi3mufMD
         KkdIxQh621YkIyuwgC3YnOfMBMIdtH/W2HSP4=
Message-ID: <4CEABDFD.9080908@gmail.com>
Date: Mon, 22 Nov 2010 11:01:17 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: general protection fault: 0000 [#1] SMP
References: <AANLkTik=d4nOUAd_DZCsJL44NB5OvYmux+b58mqs1PGH@mail.gmail.com> <alpine.LNX.2.00.1011202322050.24071@swampdragon.chaosbits.net> <alpine.LNX.2.00.1011202331090.24071@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1011202331090.24071@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<---- cut -------->

cleaned the thread up.. Anyways after doing some debugging with gdb and 
with valgrind for an application that keeps segfaulting I noticed this 
in dmesg:

[ 3028.571941] FIREWALL:INPUT IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:00:23:12:65:cb:02:08:00 SRC=0.0.0.0 
DST=255.255.255.255 LEN=328 TOS=0x00 PREC=0x00 TTL=255 ID=57984 
PROTO=UDP SPT=68 DPT=67 LEN=308
[ 3061.177655] BUG: Bad page state in process make  pfn:2134c
[ 3061.177661] page:ffffea00007438a0 count:0 mapcount:0 mapping: 
   (null) index:0x507
[ 3061.177663] page flags: 0x4000000000000008(uptodate)
[ 3061.177669] Pid: 5691, comm: make Not tainted 
2.6.37-rc2-00039-g0211924 #7
[ 3061.177671] Call Trace:
[ 3061.177680]  [<ffffffff810c5900>] ? dump_page+0xc0/0xc5
[ 3061.177684]  [<ffffffff810c5f18>] bad_page+0xd8/0xea
[ 3061.177688]  [<ffffffff810c7aeb>] get_page_from_freelist+0x344/0x4a0
[ 3061.177693]  [<ffffffff811bf123>] ? inode_has_perm+0x68/0x6a
[ 3061.177697]  [<ffffffff810c7d6b>] __alloc_pages_nodemask+0x124/0x645
[ 3061.177701]  [<ffffffff810f7cf2>] ? __dentry_open+0x194/0x2a1
[ 3061.177705]  [<ffffffff810dc155>] handle_mm_fault+0x2a8/0x82f
[ 3061.177710]  [<ffffffff811056ec>] ? do_filp_open+0x1f3/0x646
[ 3061.177714]  [<ffffffff810f4226>] ? check_object+0x13b/0x1eb
[ 3061.177719]  [<ffffffff81447d8e>] do_page_fault+0x3ec/0x411
[ 3061.177722]  [<ffffffff810f4b95>] ? free_debug_processing+0x1c5/0x208
[ 3061.177726]  [<ffffffff81103958>] ? getname+0x2c/0x1be
[ 3061.177728]  [<ffffffff810f4d08>] ? __slab_free+0x130/0x145
[ 3061.177732]  [<ffffffff81444e25>] page_fault+0x25/0x30
[ 3061.177734] Disabling lock debugging due to kernel taint
[ 3126.418774] type=1400 audit(1290451825.417:178): avc:  denied

from what I remember using valgirnd with the app took a while to load 
but am unsure if is the reason for the above message.

Justin P. Mattock
