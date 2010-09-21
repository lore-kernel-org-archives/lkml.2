Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0IUHtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 03:49:09 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37206 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0IUHtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 03:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=G0EJsYX0f4aoX9Tfp3eRR9zgoSjzxs/Uoh4v3+WbLXlicu1It+EiaLyEaQLRM//fjy
         8oXFBztp1d4GXwHZohGkrkY/JOdSOyP3K/JEacDruublSQ0rsHb3VZLLyoeOtPJp2B2V
         ANyTUyxBJ+Mmpq9tP2I8y4lYZW/+rKwek5Nzo=
Date: Tue, 21 Sep 2010 15:53:34 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rofail Qu <rofail@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: A simple question of sys_
Message-ID: <20100921075334.GA5427@cr0.nay.redhat.com>
References: <AANLkTintKaxaAKarDPFgpDLQMVomhThYtZecp5R5Mi62@mail.gmail.com>
 <20100920074838.GB5503@cr0.nay.redhat.com>
 <AANLkTim2NWLE4vhPL-P8JLS3bu9f=V8GqwF0xhE7S87m@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim2NWLE4vhPL-P8JLS3bu9f=V8GqwF0xhE7S87m@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 04:28:36PM +0800, Rofail Qu wrote:
>2010/9/20 Américo Wang <xiyou.wangcong@gmail.com>:
>> On Fri, Sep 17, 2010 at 02:58:30PM +0800, Rofail Qu wrote:
>>>How to use macro IS_ERR() ?
>>>
>>>It defines as,
>>>...
>>>#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
>>>static inline long __must_check IS_ERR(const void *ptr)
>>>{
>>>       return IS_ERR_VALUE((unsigned long)ptr);
>>>}
>>>...
>>>so when pass x as a pointer and x>=-MAX_ERRNO (including NULL or any
>>>valid address),
>>>IS_ERR() will return true!
>>
>> NULL is not an error pointer, you missed the cast to unsigned long.
>Ahh, yeah. A stupid mistake i have.
>Thanks.
>>
>>
>>>IS_ERR(x) seems to use on judge if "x" is a valid error number, right?
>>>
>>
>> Strictly speaking, it checks if 'x' is an error pointer.
>Then what is the range of a valid pointer?
>At least less than (unsigned long)-MAX_ERRNO from this case.

Yeah, the last page in the virtual memory address is reserved,
so all but the last page are non-error addresses.
