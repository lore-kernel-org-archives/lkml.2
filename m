Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1KOLvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:51:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64335 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab1KOLvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:51:35 -0500
MIME-Version: 1.0
In-Reply-To: <4EC2509D.30604@parallels.com>
References: <4EC24E9E.8040502@parallels.com>
	<4EC24EC1.7060203@parallels.com>
	<CAOJsxLECV5yr+A_mSooS674CKgGoNxgrbhOs0CCu0Pa0=KPkPw@mail.gmail.com>
	<4EC2509D.30604@parallels.com>
Date: Tue, 15 Nov 2011 13:51:34 +0200
X-Google-Sender-Auth: bOgT9ciIUoG1iMItKlUWI_5Yyog
Message-ID: <CAOJsxLHyXuFEuqcMS6Mdh8Gh45pfur+BHU4sH4irKqTAR7xrZw@mail.gmail.com>
Subject: Re: [PATCH 1/4] Routine for generating an safe ID for kernel pointer
From: Pekka Enberg <penberg@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 1:44 PM, Pavel Emelyanov <xemul@parallels.com> wrote:
>>> +unsigned long gen_object_id(void *ptr)
>>> +{
>>> +       if (!ptr)
>>> +               return 0;
>>> +
>>> +       if (unlikely(!ptr_poison)) {
>>> +               spin_lock(&ptr_poison_lock);
>>> +               if (!ptr_poison)
>>> +                       get_random_bytes(&ptr_poison, sizeof(ptr_poison));
>>> +               spin_unlock(&ptr_poison_lock);
>>> +       }
>>> +
>>> +       return ((unsigned long)ptr) ^ ptr_poison;
>>> +}
>>
>> You could put this in mm/util.c. Wouldn't it make sense to separate
>> the initialization and use late_initcall() to call it?
>
> OK, will put to util.c
>
> About the initialization - I will put the sanity check about poison being not 0 on
> get_object_id() anyway, so what's the point in separate initialization?

You no longer need the spinlock and you get rid of the potential
double initialization problem because you're not holding the spinlock
when you check for ptr_poisson being zero.

                        Pekka
