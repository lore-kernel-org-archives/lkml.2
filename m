Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0FCNUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:20:18 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:40933 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0FCNUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:20:16 -0400
Message-ID: <4C07AD0C.8090409@oss.ntt.co.jp>
Date: Thu, 03 Jun 2010 22:24:28 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
       Dan Carpenter <error27@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v2] fcntl: return -EFAULT if copy_to_user fails
References: <20100603100402.GR5483@bicker> <4C07826A.6060302@oss.ntt.co.jp> <20100603103542.GV5483@bicker> <4C07990A.8080508@fusionio.com> <4C079D34.5010500@oss.ntt.co.jp> <1275568683.2456.33.camel@edumazet-laptop> <20100603131031.GM6822@laptop>
In-Reply-To: <20100603131031.GM6822@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/03 22:10), Nick Piggin wrote:
> On Thu, Jun 03, 2010 at 02:38:03PM +0200, Eric Dumazet wrote:
>> Le jeudi 03 juin 2010 à 21:16 +0900, Takuya Yoshikawa a écrit :
>>> (2010/06/03 20:59), Jens Axboe wrote:
>>>> On 2010-06-03 12:35, Dan Carpenter wrote:
>>>>> copy_to_user() returns the number of bytes remaining, but we want to
>>>>> return -EFAULT.
>>>>> 	ret = fcntl(fd, F_SETOWN_EX, NULL);
>>>>> With the original code ret would be 8 here.
>>>>>
>>>>> V2: Takuya Yoshikawa pointed out a similar issue in f_getown_ex()
>>>>
>>>> Pretty basic bug, how long has this been there?
>>>
>>> IIUC, from the beginning, when these were introduced.
>>
>> Maybe copy_to_user() was changed sometime to return a partial count
>> instead of EFAULT ?
>
> I think it's been like that since first introduced. Some functions
> do need to know in order to do partial copies.
>
>
>> I do think we should have a set of helper functions, instead of
>> spreading special EFAULT cases in one housand places...
>>
>> This is really ugly.
>>
>> static inline int sec_copy_to_user(arg1, arg2, arg3)
>> {
>> 	int res = copy_to_user(arg1, arg2, arg3);
>>
>> 	return (res>  0) ? -EFAULT : res;
>> }
>
> It would be unfortunate if it adds more confusion. I'd prefer to have
> a sufficiently different name. memcpy_to_user/memcpy_from_user
> perhaps?

Then, and memclear_user() ?

>

