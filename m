Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0CWHBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 03:01:00 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:52078 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0CWHA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 03:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FGJwIX2lmKNcxuAgxdCbH/HDMjM3iOyjDMeSnaMPbII0CflsuOHxdhLF11htHJazrC
         nWReCsUl8YiRtp8zMO0ChzuioylXimoQ7/XxP8s094wiQXRxxV+k4LXXWb3J2/aP1aA7
         HAh227TXJk/crdjsr9wrkBYv64yZhoCWQZ2GY=
MIME-Version: 1.0
In-Reply-To: <20100322233113.f17d0e0c.akpm@linux-foundation.org>
References: <20100322120509.GC21571@bicker>
	 <20100322233113.f17d0e0c.akpm@linux-foundation.org>
Date: Tue, 23 Mar 2010 15:00:58 +0800
Message-ID: <2375c9f91003230000m171f35c0t66fc3a5094b0d881@mail.gmail.com>
Subject: Re: [patch] kcore: fix test for end of list
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <error27@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 11:31 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 22 Mar 2010 15:05:09 +0300 Dan Carpenter <error27@gmail.com> wrote:
>
>> "m" is never NULL here.  We need a different test for the end of list
>> condition.
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>> ---
>> Found with a static checker and compile tested only.  Please review
>> carefully.
>>
>> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
>> index a44a789..b442dac 100644
>> --- a/fs/proc/kcore.c
>> +++ b/fs/proc/kcore.c
>> @@ -490,7 +490,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
>>               }
>>               read_unlock(&kclist_lock);
>>
>> -             if (m == NULL) {
>> +             if (&m->list == &kclist_head) {
>>                       if (clear_user(buffer, tsz))
>>                               return -EFAULT;
>>               } else if (is_vmalloc_or_module_addr((void *)start)) {
>
> hm, that code's been there for five years.  I wonder if it's actually necessary.

Nope, not that long, please see commit 2ef43ec7. :)
