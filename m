Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab1BLBmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:42:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab1BLBmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:42:05 -0500
Message-ID: <4D55E555.9050409@redhat.com>
Date: Fri, 11 Feb 2011 19:41:41 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL]
References: <20110211134058.GA4309@thunk.org> <AANLkTineDxntR0ZTXdgXrc6qx6pATTORgOwFR5+w5MLN@mail.gmail.com>
In-Reply-To: <AANLkTineDxntR0ZTXdgXrc6qx6pATTORgOwFR5+w5MLN@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/11 6:33 PM, Linus Torvalds wrote:
> On Fri, Feb 11, 2011 at 5:40 AM, Ted Ts'o <tytso@mit.edu> wrote:
>>
>> Please pull from:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
>>
>> to get regression and bug fixes for 2.6.38.
>>
>> Eric Sandeen (3):
>>      ext4: serialize unaligned asynchronous DIO
> 
> This is a completely disgusting patch, and it causes warnings like this:

>  fs/ext4/file.c: In function ‘ext4_aiodio_wait’:
>  fs/ext4/file.c:60:44: warning: cast from pointer to integer of different size
> 
> because that disgusting patch does things like
> 
>   #define ext4_aio_mutex(v)  (&ext4__aio_mutex[((unsigned)v) % EXT4_WQ_HASH_SZ])

Well crap, the patch I sent Ted did not cause warnings.
OTOH, I eyeballed his changes to my patch and said OK.  Didn't test-build it though.
Sorry about that.

Will see what's going on here...

-Eric

> which is just terminally broken.
> 
> It's terminally broken for multiple reasons, too. It's not just "oh, a
> warning". It's a case of "oh, THAT CODE IS UTTER CRAP". The warning
> was just the lucky reason I noticed the totally unacceptable code.
> 
> Dammit, don't send sh*t to me this late in the release cycle. This
> clearly went through _zero_ quality control.
> 
>                    Linus
> 
> PS. If people don't understand why that code is utter crap, let me
> give you a hint: macro argument expansion vs operator precedence.
> 
> PPS. And btw, the warning is unacceptable too. Cast the thing to
> "unsigned long" (or uintptr_t, but quite frankly, in the kernel I'd
> suggest "unsigned long" rather than the more obscure standard types)
> after you've fixed the macro argument problem.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

