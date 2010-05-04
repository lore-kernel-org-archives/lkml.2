Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0EDOIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:08:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48898 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab0EDOIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ciy/VlPHf5uZjlGJBcQTjD+K1wpNT9GfPqOVcLJTEMeot8rc13gWCLIPy5N/R9krWO
         ABCiUgnHMD4Q6ldOiuoBefmtZsZ3ONjaIsttAigdsyrGL8kQjVizvixQirjz8kxOZwV3
         Q/jUnI0gSDYSXXGFr6GvcgzLJN4Q84s30w+YY=
MIME-Version: 1.0
In-Reply-To: <20100504103232.GA25054@infradead.org>
References: <x2gd4f60c3c1005032259p8be864bcucff91618016a0eb@mail.gmail.com>
	 <20100504103232.GA25054@infradead.org>
Date: Tue, 4 May 2010 07:05:34 -0700
Message-ID: <m2id4f60c3c1005040705v2e46547axad496769d4d4dbe8@mail.gmail.com>
Subject: Re: nfs accesses of FAT fs folders causes deadlock on lock_super
From: Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 3:32 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, May 03, 2010 at 10:59:42PM -0700, Fredrick Prashanth John Berchmans wrote:
>> The box was running kernel version 2.6.27.10.
>> But I think the FAT code has not changed much.
>
> But the nfsd code has and now doesn't call lookup from the filldir
> callback anymore.
>
>

Ah..I just noticed the changes in the nfsd code.

But in 2.6.27.10, can it be fixed by removing the lock_super in the
vfat_lookup.?
Because I saw some discussions long back of regressions due to
replacing lock_kernel by lock_super in FAT code.
Or should the sb mutex be unlocked before calling the callback filldir
in the __fat_readdir?

Thanks,
Fredrick
