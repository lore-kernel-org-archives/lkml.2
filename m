Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0KILR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:17:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0KILR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:17:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uJ8HM2Oeka5S9fNNkJxtRAJ/nTe1OR48uuX0wxzDVpTi95V2A5eQYDHv+uK2Z70AfO
         u6L7ApdAqcNuE+GLEGAY2gYAwdXId1y+8blI4q3dX/o6z7UkSnXKuXIEkY+YHKMCpgEU
         90pjy/8xfC/4N50CMWzr2v7Ef4GP7UQ8doz6g=
MIME-Version: 1.0
In-Reply-To: <4CD8F2A9.6080907@suse.de>
References: <AANLkTikCnK7YN9F3JOv0rVZt65iQ=v=YJ_ONOuwj_=9D@mail.gmail.com>
	<AANLkTindSKRu2SJoCwqwhdRmBaV-+oRDQ9fp9Cikh2_G@mail.gmail.com>
	<AANLkTi=nDY25GNpV=XVum0Cbg1tjX14v-fcA2K6NrhgW@mail.gmail.com>
	<4CD8F2A9.6080907@suse.de>
Date: Tue, 9 Nov 2010 22:17:55 +1100
Message-ID: <AANLkTikduZJ1pjKN7X7F2Uai1eqLyb1PTEMPJ7P==tT8@mail.gmail.com>
Subject: Re: 2.6.37-rc1 kmemleak warnings when saving a file over cifs.
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Steve French <smfrench@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes that fixes the leak, appears fine now thanks.

On Tue, Nov 9, 2010 at 6:05 PM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> On 11/09/2010 11:31 AM, Andrew Hendry wrote:
>> The server is a qnap NAS, running linux 2.6.24
>
>> On Tue, Nov 9, 2010 at 3:12 PM, Steve French <smfrench@gmail.com> wrote:
>>> On Mon, Nov 8, 2010 at 6:13 PM, Andrew Hendry <andrew.hendry@gmail.com> wrote:
>>>> Have just noticed these in the past few days, now running 2.6.37-rc1+
>>>> Seems to be 1 logged per file save when using a text file with gedit over cifs.
>>>
>>> Can you tell the called function in cifs_setattr_unix vs. cifs_setattr_nounix
>>> (the former will usually be called when the server is Samba, the latter
>>> when the server is Windows or NetApp). �What is the server type?
>>>
>>>> unreferenced object 0xffff88022ee08b40 (size 32):
>>>> �comm "gedit", pid 2524, jiffies 4300160388 (age 2633.655s)
>>>> �hex dump (first 32 bytes):
>>>> � �5c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d �\.goutputstream-
>>>> � �35 42 41 53 4c 56 00 de 09 00 00 00 2c 26 78 ee �5BASLV......,&x.
>>>> �backtrace:
>>>> � �[<ffffffff81504a4d>] kmemleak_alloc+0x2d/0x60
>>>> � �[<ffffffff81136e13>] __kmalloc+0xe3/0x1d0
>>>> � �[<ffffffffa0313db0>] build_path_from_dentry+0xf0/0x230 [cifs]
>>>> � �[<ffffffffa031ae1e>] cifs_setattr+0x9e/0x770 [cifs]
>>>> � �[<ffffffff8115fe90>] notify_change+0x170/0x2e0
>>>> � �[<ffffffff81145ceb>] sys_fchmod+0x10b/0x140
>>>> � �[<ffffffff8100c172>] system_call_fastpath+0x16/0x1b
>>>> � �[<ffffffffffffffff>] 0xffffffffffffffff
>>>
>
> Are you using the mount option 'nounix'? I spotted a memleak in the
> nounix code path introduced by a recent patch and proposed a fix here:
>
>        http://thread.gmane.org/gmane.linux.kernel.cifs/1549
>
> Does this fix the leak for you?
>
>
>
> --
> Suresh Jayaraman
>
