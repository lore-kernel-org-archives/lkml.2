Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2IZUQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:16:00 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61467 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2IZUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:15:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120926160127.c34cb6d3e5dcc9ab32e8b573@canb.auug.org.au>
References: <20120926160127.c34cb6d3e5dcc9ab32e8b573@canb.auug.org.au>
Date: Wed, 26 Sep 2012 13:15:58 -0700
X-Google-Sender-Auth: 2nrGv-VTe0VexX_j55oG7KQhVhI
Message-ID: <CAGXu5jJJPLXP1cjtWAwHNmYQ6ZxtVu=Oo6vh=NkowzT+26RWPg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
From: Kees Cook <keescook@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is weird -- my original patch doesn't touch audit_get_sessionid() at all:
http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=commitdiff;h=7bbfec58ed33d5e74043530b87992f16da718ba2

The patch in linux-next (currently
e269b4131288512ebfe2adfe69042983cb2e69e5) got mangled to include
removing it, possibly triggered by the audit_get_loginuid() changes
("userns: Convert the audit loginuid  to be a kuid"). These shouldn't
be removed:

#define audit_get_loginuid(t) (INVALID_UID)
#define audit_get_sessionid(t) (-1)

I'll send an updated patch that'll apply on top of what's in linux-next.

Thanks!

-Kees

On Tue, Sep 25, 2012 at 11:01 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> net/key/af_key.c: In function 'pfkey_add':
> net/key/af_key.c:1476:9: error: implicit declaration of function 'audit_get_sessionid' [-Werror=implicit-function-declaration]
> net/core/dev.c: In function '__dev_set_promiscuity':
> net/core/dev.c:4573:5: error: implicit declaration of function 'audit_get_sessionid' [-Werror=implicit-function-declaration]
>
> Caused by commit "audit.h: replace defines with C stubs".
>
> I have reverted that commit for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Kees Cook
Chrome OS Security
