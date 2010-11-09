Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0KIHFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 02:05:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:52631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab0KIHFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 02:05:20 -0500
Message-ID: <4CD8F2A9.6080907@suse.de>
Date: Tue, 09 Nov 2010 12:35:13 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Hendry <andrew.hendry@gmail.com>
Cc: Steve French <smfrench@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-cifs@vger.kernel.org
Subject: Re: 2.6.37-rc1 kmemleak warnings when saving a file over cifs.
References: <AANLkTikCnK7YN9F3JOv0rVZt65iQ=v=YJ_ONOuwj_=9D@mail.gmail.com>	<AANLkTindSKRu2SJoCwqwhdRmBaV-+oRDQ9fp9Cikh2_G@mail.gmail.com> <AANLkTi=nDY25GNpV=XVum0Cbg1tjX14v-fcA2K6NrhgW@mail.gmail.com>
In-Reply-To: <AANLkTi=nDY25GNpV=XVum0Cbg1tjX14v-fcA2K6NrhgW@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 11:31 AM, Andrew Hendry wrote:
> The server is a qnap NAS, running linux 2.6.24

> On Tue, Nov 9, 2010 at 3:12 PM, Steve French <smfrench@gmail.com> wrote:
>> On Mon, Nov 8, 2010 at 6:13 PM, Andrew Hendry <andrew.hendry@gmail.com> wrote:
>>> Have just noticed these in the past few days, now running 2.6.37-rc1+
>>> Seems to be 1 logged per file save when using a text file with gedit over cifs.
>>
>> Can you tell the called function in cifs_setattr_unix vs. cifs_setattr_nounix
>> (the former will usually be called when the server is Samba, the latter
>> when the server is Windows or NetApp). �What is the server type?
>>
>>> unreferenced object 0xffff88022ee08b40 (size 32):
>>> �comm "gedit", pid 2524, jiffies 4300160388 (age 2633.655s)
>>> �hex dump (first 32 bytes):
>>> � �5c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d �\.goutputstream-
>>> � �35 42 41 53 4c 56 00 de 09 00 00 00 2c 26 78 ee �5BASLV......,&x.
>>> �backtrace:
>>> � �[<ffffffff81504a4d>] kmemleak_alloc+0x2d/0x60
>>> � �[<ffffffff81136e13>] __kmalloc+0xe3/0x1d0
>>> � �[<ffffffffa0313db0>] build_path_from_dentry+0xf0/0x230 [cifs]
>>> � �[<ffffffffa031ae1e>] cifs_setattr+0x9e/0x770 [cifs]
>>> � �[<ffffffff8115fe90>] notify_change+0x170/0x2e0
>>> � �[<ffffffff81145ceb>] sys_fchmod+0x10b/0x140
>>> � �[<ffffffff8100c172>] system_call_fastpath+0x16/0x1b
>>> � �[<ffffffffffffffff>] 0xffffffffffffffff
>>

Are you using the mount option 'nounix'? I spotted a memleak in the
nounix code path introduced by a recent patch and proposed a fix here:

	http://thread.gmane.org/gmane.linux.kernel.cifs/1549

Does this fix the leak for you?



-- 
Suresh Jayaraman
