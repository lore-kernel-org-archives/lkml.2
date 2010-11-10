Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0KJBxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:53:38 -0500
Received: from smtp-out.google.com ([216.239.44.51]:16225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0KJBxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:53:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=l6twCC3tw4onOgcVzls4xA/uJNCbWxhf0hR0VQzfdaXVb+TLKj1CAO+7fBUnZ4AUsm
         PVgx0GLyXcrJ6toJugOQ==
MIME-Version: 1.0
In-Reply-To: <4CD9ECD2.3030805@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com> <4CC146BA.7080009@cn.fujitsu.com>
 <AANLkTikf-1kLStxqi5UjP=vn3pqVBHy0OA7ibeWTkJ5z@mail.gmail.com>
 <4CD78946.5060405@cn.fujitsu.com> <AANLkTim6d1fQLZbkmZST3PTN0RMSs3m=oossF81pYBn9@mail.gmail.com>
 <4CD9ECD2.3030805@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Tue, 9 Nov 2010 17:53:13 -0800
Message-ID: <AANLkTinMr7VE4Os7rXWjiHWOVysv=oE0vHKduLWCN0bC@mail.gmail.com>
Subject: Re: [PATCH 1/7] cgroups: Shrink struct cgroup_subsys
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 4:52 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>> bool active:1;
>> bool disabled:1;
>>
>
> It won't compile, but unsigned char active:1 will do. ;)

Are you sure? I don't have a buildable kernel tree at the moment, but
the following fragment compiled fine for me (with gcc 4.4.3):

struct foo {
  _Bool b1:1;
  _Bool b2:1;
};

and was sized at one byte. And "bool" is just a typedef of _Bool in
the kernel headers.

>
> Every thing that reduces code size (without sacrifice readability
> and maintain maintainability) should be worth.

Agreed, within reason. But this patch doesn't reduce code size - it
makes the code fractionally more complicated and reduces the *binary*
size by a few bytes.

>
> This is one of the reasons we accept patches that replacing
> kmalloc+memset with kzalloc, which just saves 8 bytes in my box.
>

Replacing two function calls with one function call is a code
simplification and hence (generally) a good thing - the minuscule
reduction in binary size reduction that comes with it is just noise.

Paul
