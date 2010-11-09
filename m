Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0KIEMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:12:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61643 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0KIEMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:12:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m0laA6rZ/gKAaqU2yhcbsW5YotPHJ7yseltfWAfvTT+0DX6z+YF6pmu6nNgrgF0Hgh
         qipZYSYN7LE5lOdMEwvfCiSVpfoHnHM7ZbWLEZCS/qNKFiO5chiTyHXYyG+IHsI8RdzA
         BWy8JqjpFnPlHs8rDgnKoxOWZPkx4wHMR8Gtc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikCnK7YN9F3JOv0rVZt65iQ=v=YJ_ONOuwj_=9D@mail.gmail.com>
References: <AANLkTikCnK7YN9F3JOv0rVZt65iQ=v=YJ_ONOuwj_=9D@mail.gmail.com>
Date: Mon, 8 Nov 2010 22:12:11 -0600
Message-ID: <AANLkTindSKRu2SJoCwqwhdRmBaV-+oRDQ9fp9Cikh2_G@mail.gmail.com>
Subject: Re: 2.6.37-rc1 kmemleak warnings when saving a file over cifs.
From: Steve French <smfrench@gmail.com>
To: Andrew Hendry <andrew.hendry@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 6:13 PM, Andrew Hendry <andrew.hendry@gmail.com> wrote:
> Have just noticed these in the past few days, now running 2.6.37-rc1+
> Seems to be 1 logged per file save when using a text file with gedit over cifs.

Can you tell the called function in cifs_setattr_unix vs. cifs_setattr_nounix
(the former will usually be called when the server is Samba, the latter
when the server is Windows or NetApp).  What is the server type?

> unreferenced object 0xffff88022ee08b40 (size 32):
>  comm "gedit", pid 2524, jiffies 4300160388 (age 2633.655s)
>  hex dump (first 32 bytes):
>    5c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d  \.goutputstream-
>    35 42 41 53 4c 56 00 de 09 00 00 00 2c 26 78 ee  5BASLV......,&x.
>  backtrace:
>    [<ffffffff81504a4d>] kmemleak_alloc+0x2d/0x60
>    [<ffffffff81136e13>] __kmalloc+0xe3/0x1d0
>    [<ffffffffa0313db0>] build_path_from_dentry+0xf0/0x230 [cifs]
>    [<ffffffffa031ae1e>] cifs_setattr+0x9e/0x770 [cifs]
>    [<ffffffff8115fe90>] notify_change+0x170/0x2e0
>    [<ffffffff81145ceb>] sys_fchmod+0x10b/0x140
>    [<ffffffff8100c172>] system_call_fastpath+0x16/0x1b
>    [<ffffffffffffffff>] 0xffffffffffffffff

Didn't see anything obvious in cifs_setattr_unix on the kmalloc/kfree
of full_path,
but it will help when we know which path we are in.  We did make some recent
changes in 2.6.37 in file allocation.

-- 
Thanks,

Steve
