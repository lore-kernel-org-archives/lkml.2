Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab0EFDWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 23:22:25 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:32844 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0EFDWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 23:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=u3/YW66j1kBppNNfCHf77qq8xxrJ7f3Gew8uqbGAox/+pBEUY7krbTwtME9uFBCIct
         Lew3eVrxgIFo0vj5j7MFf1PsW8Y4ZfSlRZNfpaZhrXD5tpGPOQUs0J7czHcGJoQj4WL7
         kpDWw2W0oyqK2ExMDG0DS+AaBmggr1CAOq950=
MIME-Version: 1.0
In-Reply-To: <201005060312.o463CUOQ085547@www262.sakura.ne.jp>
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com> 
	<201005060312.o463CUOQ085547@www262.sakura.ne.jp>
From: Changli Gao <xiaosuo@gmail.com>
Date: Thu, 6 May 2010 11:22:03 +0800
Message-ID: <l2o412e6f7f1005052022td6db0c2g4afccb5f006366ff@mail.gmail.com>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: eric.dumazet@gmail.com, jslaby@suse.cz, viro@zeniv.linux.org.uk,
       paulmck@linux.vnet.ibm.com, adobriyan@gmail.com, mingo@elte.hu,
       peterz@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/6 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
> Changli Gao wrote:
>> struct kvfree_work_struct {
>>       struct work_struct      work;
>>       void                    *head;
>>       void                    **ptail;
>> };
>
> I wonder why "struct kvfree_work_struct" is needed.
> According to http://kernel.ubuntu.com/git?p=jj/ubuntu-lucid.git;a=blobdiff;f=security/apparmor/match.c;h=d2cd55419acfcae85cb748c8f837a4384a3a0d29;hp=afc2dd2260edffcf88521ae86458ad03aa8ea12c;hb=f5eba4b0a01cc671affa429ba1512b6de7caeb5b;hpb=abdff9ddaf2644d0f9962490f73e030806ba90d3 ,
>
> static void kvfree_work(struct work_struct *work)
> {
>        vfree(work);
> }
>
> void kvfree_inatomic(void *ptr, size_t size)
> {
>        if (size < PAGE_SIZE) {
>                kfree(ptr);
>        } else if (is_vmalloc_addr(ptr)) {
>                /*
>                 * We can embed "struct work_struct" inside *ptr
>                 * because size >= PAGE_SIZE.
>                 */
>                struct work_struct *work = ptr;
>                BUILD_BUG_ON(sizeof(struct work_struct) > PAGE_SIZE);
>                INIT_WORK(&work, kvfree_work);
>                schedule_work(&work);

&work should be work. It is a much better idea. thanks very much.

>        } else {
>                free_pages_exact(ptr, size);
>        }
> }
>
> should do what you want. (Though, I didn't test it.)
>

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
