Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2JSIOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:14:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51697 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2JSIOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:14:15 -0400
MIME-Version: 1.0
In-Reply-To: <5080f0b3.85712b0a.0d0f.ffff9dd2SMTPIN_ADDED@mx.google.com>
References: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>
	<CAFLxGvwfGc_4z1JM=pAb-U4tNVeMZR1zs-neQv7Vz2-6DQT+9Q@mail.gmail.com>
	<1350624189.14741.1.camel@wall-e>
	<5080f0b3.85712b0a.0d0f.ffff9dd2SMTPIN_ADDED@mx.google.com>
Date: Fri, 19 Oct 2012 10:14:14 +0200
Message-ID: <CAFLxGvxdH=sx9+1y0Uw5gNWL9ZRbPTst3Fj2SgAimoUDbo_2PQ@mail.gmail.com>
Subject: Re: [PATCH] remove untouched code in kfifo_in
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        jkosina@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 8:18 AM, Richard Yang
<weiyang@linux.vnet.ibm.com> wrote:
> On Fri, Oct 19, 2012 at 07:23:09AM +0200, Stefani Seibold wrote:
>>
>>Am Freitag, den 19.10.2012, 00:37 +0200 schrieb richard -rw- weinberger:
>>> On Thu, Oct 18, 2012 at 3:59 PM, Wei Yang <weiyang@linux.vnet.ibm.com> wrote:
>>> > In kfifo_in marco, one piece of code is arounded by if(0). This code in
>>> > introduced by Stefani Seibold <stefani@seibold.net> to suppress a compiler
>>> > warning. This warning is not there with the upgrade of gcc version.
>>> >
>>> > This patch just remove this code.
>>>
>>> Are you sure?
>>> This code fragment looks like a compiler bomb to detect type mismatch to me...
>>>
>>
>>Yes, you are great! That was the reason why i made this peace of code.
>>So don't remove it!
> Thanks for your confirmation.
>
> Hmm, would you give me a hint on how it check the type mismatch?

Here a small hint:
---cut---
struct x {
};
struct y {
};

#define check(a, b) \
({ \
        if (0) { \
                typeof(a) __dummy __attribute__ ((unused)); \
                __dummy = (typeof(b))NULL; \
        } \
})

int main(int argc, char **argv)
{
        struct x _x;
        struct y _y;

        check(&_x, &_x); //okay
        check(&_x, &_y); //will explode with "assignment from
incompatible pointer type"

        return 0;
}

---cut---


-- 
Thanks,
//richard
