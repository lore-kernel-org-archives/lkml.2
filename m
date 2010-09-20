Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0ITI2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:28:40 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35407 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0ITI2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=HLz0B7ND6LslnER0a38EjUTVZOYEnYiqsdx1poRP5SRUnDzWxrf0jDCKNgagvk8xD9
         V6/ajtmkWGiNRc/EBTd+uKMqL2jl3YvAy0/p+I7OZqIjVw1r4v7GomGBfi+agYvmff5l
         uoTpn6/yGQW9Z4M3ivwUXc6hA31cpbhkGSpQs=
MIME-Version: 1.0
In-Reply-To: <20100920074838.GB5503@cr0.nay.redhat.com>
References: <AANLkTintKaxaAKarDPFgpDLQMVomhThYtZecp5R5Mi62@mail.gmail.com>
	<20100920074838.GB5503@cr0.nay.redhat.com>
Date: Mon, 20 Sep 2010 16:28:36 +0800
Message-ID: <AANLkTim2NWLE4vhPL-P8JLS3bu9f=V8GqwF0xhE7S87m@mail.gmail.com>
Subject: Re: A simple question of sys_
From: Rofail Qu <rofail@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/20 Américo Wang <xiyou.wangcong@gmail.com>:
> On Fri, Sep 17, 2010 at 02:58:30PM +0800, Rofail Qu wrote:
>>How to use macro IS_ERR() ?
>>
>>It defines as,
>>...
>>#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
>>static inline long __must_check IS_ERR(const void *ptr)
>>{
>>       return IS_ERR_VALUE((unsigned long)ptr);
>>}
>>...
>>so when pass x as a pointer and x>=-MAX_ERRNO (including NULL or any
>>valid address),
>>IS_ERR() will return true!
>
> NULL is not an error pointer, you missed the cast to unsigned long.
Ahh, yeah. A stupid mistake i have.
Thanks.
>
>
>>IS_ERR(x) seems to use on judge if "x" is a valid error number, right?
>>
>
> Strictly speaking, it checks if 'x' is an error pointer.
Then what is the range of a valid pointer?
At least less than (unsigned long)-MAX_ERRNO from this case.
>
>
