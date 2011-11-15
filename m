Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1KOLoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:44:34 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:26041 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1KOLod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:44:33 -0500
Message-ID: <4EC2509D.30604@parallels.com>
Date: Tue, 15 Nov 2011 15:44:29 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 1/4] Routine for generating an safe ID for kernel pointer
References: <4EC24E9E.8040502@parallels.com>	<4EC24EC1.7060203@parallels.com> <CAOJsxLECV5yr+A_mSooS674CKgGoNxgrbhOs0CCu0Pa0=KPkPw@mail.gmail.com>
In-Reply-To: <CAOJsxLECV5yr+A_mSooS674CKgGoNxgrbhOs0CCu0Pa0=KPkPw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +unsigned long gen_object_id(void *ptr)
>> +{
>> +       if (!ptr)
>> +               return 0;
>> +
>> +       if (unlikely(!ptr_poison)) {
>> +               spin_lock(&ptr_poison_lock);
>> +               if (!ptr_poison)
>> +                       get_random_bytes(&ptr_poison, sizeof(ptr_poison));
>> +               spin_unlock(&ptr_poison_lock);
>> +       }
>> +
>> +       return ((unsigned long)ptr) ^ ptr_poison;
>> +}
> 
> You could put this in mm/util.c. Wouldn't it make sense to separate
> the initialization and use late_initcall() to call it?

OK, will put to util.c

About the initialization - I will put the sanity check about poison being not 0 on
get_object_id() anyway, so what's the point in separate initialization?

>                         Pekka
> .
> 

