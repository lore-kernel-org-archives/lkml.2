Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab2EKPWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:22:55 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65408 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2EKPWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120511151944.GA6990@kroah.com>
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
 <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
 <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop>
 <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com> <20120511151944.GA6990@kroah.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 17:22:32 +0200
Message-ID: <CA+1xoqdfzc8WEj6GejGiErmMON3Zb2OcFdZ2anOq4hNBjVMXBA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 5:19 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, May 11, 2012 at 12:35:07PM +0200, Sasha Levin wrote:
>> This has a small issue with the way timing is printed compared to how
>> it worked previously.
>>
>> Consider the following case:
>>
>>     printk("\n foo \n bar \n zoot")
>>
>> Previously, you would see timing on each line of the print, but now
>> you see it only on the first.
>
> What code does this?  Shouldn't those be individual printk lines?  I
> didn't think that type of line would ever work properly in the past.

At least the lockdep code, in several places:

        __print_lock_name(safe_class);
        printk(");\n");
        printk("\n *** DEADLOCK ***\n\n");

Which has looked fine before.
