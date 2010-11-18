Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab0KRRWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:22:24 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46504 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab0KRRWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=uoCsGa0hvqvVsg1r24P0SNYNRfne2bsr00Qpcms60Xv/naUlfhY+E1mj8ovnyDfuxF
         Jw5tDpfQnygFn32TFKbx//ckQSf6Uq4rpplNuCkSizC8/hAmDu4xfR1za16HJQqDjguW
         T+q+qVYRhEYdswtAK6UwFljK2Eqj9QiCAAmDg=
MIME-Version: 1.0
In-Reply-To: <1290094063.3187.41.camel@heimdal.trondhjem.org>
References: <AANLkTimavN8px1k_Y65mFqsAsiLjgCh6vos22ZnZm+3Z@mail.gmail.com> <1290094063.3187.41.camel@heimdal.trondhjem.org>
From: Peng Tao <lkml.bergwolf@gmail.com>
Date: Fri, 19 Nov 2010 01:22:01 +0800
X-Google-Sender-Auth: 1FjSIzTpduqr0CYoRu-9OzUpqjE
Message-ID: <AANLkTik6cGbhyAPBKVoq49ePEfxgVaNL16ghXgztya1V@mail.gmail.com>
Subject: Re: Question about nfs_page_async_flush assertion
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:27 PM, Trond Myklebust
<trond.myklebust@fys.uio.no> wrote:
> On Thu, 2010-11-18 at 18:53 +0800, Peng Tao wrote:
>> Hi, all,
>>
>> nfs_writepages calls into
>> write_cache_pages()->nfs_writepages_callback()->nfs_do_writepage()->nfs_page_async_flush(),
>> where it asserts BUG_ON(test_bit(PG_CLEAN, &req->wb_flags)).
>> My question is: how do we guarantee the request has PG_CLEAN flag set?
>
> We don't. We guarantee that the request has PG_CLEAN cleared, and that
> is done when we dirty the page (see nfs_try_to_update_request()).
Ah, I missed. It is test_bit() other than !test_bit(). Thank you Trond
for pointing it out.
Sorry for the spam :)

-- 
Thanks,
-Bergwolf
