Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0LHQFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:05:11 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:52473 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0LHQFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:05:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=biY+EOJfLnPg2xeXvRtWeiL9nObYIj0+1LwslCs11h+WeqyKGpVUblsgT5nJd5jUwO
         JqdH4086AqsoMt0yqS+N4G+Xvt48FELBT1fYncS8B3b8W7vkCEMWpaF5F005M6Z5kGYq
         uEApc8liZlx40+KdCkOVN9vluZvTqMPegi/ZM=
MIME-Version: 1.0
In-Reply-To: <1291782450.2325.41.camel@work-vm>
References: <1291775384-7570-1-git-send-email-ckhardin@gmail.com>
	<1291782450.2325.41.camel@work-vm>
Date: Wed, 8 Dec 2010 08:05:06 -0800
Message-ID: <AANLkTi=g_0+P7=rY_vA+QqHU5BM_hqDVqpKrDPYhP4ye@mail.gmail.com>
Subject: Re: [PATCH] Move the scope of the FD_SET, FD_CLR, FD_SETSIZE,
 FD_ISSET, and FD_SERO to the linux/posix_types.h scope and out of the
 linux/time.h scope.
From: Charles Hardin <ckhardin@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

Sorry, your name popped out of the get_maintainers.pl script, you have
any idea who else from

Thomas Gleixner
David Howells
H. Peter Anvin
David S. Miller

This should go to? or just all of them?
Charles

On Tue, Dec 7, 2010 at 8:27 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2010-12-07 at 18:29 -0800, ckhardin@gmail.com wrote:
>> From: Charles Hardin <chardin@erebus.dhcp.2wire.com>
>>
>> This is a change to address a conflict in a time utility library that
>> was using the kernel version of timespec and picked up the FD_SET macros
>> and which caused a redefinition compiler error
>>
>> Signed-off-by: Charles Hardin <ckhardin@gmail.com>
>
> No objection here, but I'm not sure if I'm the best to review this, as
> I'm not as familiar with the users of FD_*.
>
> thanks
> -john
>
>
>> ---
>>  include/linux/posix_types.h |   12 ++++++++++++
>>  include/linux/time.h        |    8 --------
>>  2 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/posix_types.h b/include/linux/posix_types.h
>> index f04c98c..c49ce52 100644
>> --- a/include/linux/posix_types.h
>> +++ b/include/linux/posix_types.h
>> @@ -33,6 +33,18 @@
>>  #undef __FDMASK
>>  #define      __FDMASK(d)     (1UL << ((d) % __NFDBITS))
>>
>> +#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
>> +
>> +#define NFDBITS                      __NFDBITS
>> +
>> +#define FD_SETSIZE           __FD_SETSIZE
>> +#define FD_SET(fd,fdsetp)    __FD_SET(fd,fdsetp)
>> +#define FD_CLR(fd,fdsetp)    __FD_CLR(fd,fdsetp)
>> +#define FD_ISSET(fd,fdsetp)  __FD_ISSET(fd,fdsetp)
>> +#define FD_ZERO(fdsetp)              __FD_ZERO(fdsetp)
>> +
>> +#endif /* not kernel and not glibc */
>> +
>>  typedef struct {
>>       unsigned long fds_bits [__FDSET_LONGS];
>>  } __kernel_fd_set;
>> diff --git a/include/linux/time.h b/include/linux/time.h
>> index 9f15ac7..6e612a4 100644
>> --- a/include/linux/time.h
>> +++ b/include/linux/time.h
>> @@ -254,14 +254,6 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
>>  }
>>  #endif /* __KERNEL__ */
>>
>> -#define NFDBITS                      __NFDBITS
>> -
>> -#define FD_SETSIZE           __FD_SETSIZE
>> -#define FD_SET(fd,fdsetp)    __FD_SET(fd,fdsetp)
>> -#define FD_CLR(fd,fdsetp)    __FD_CLR(fd,fdsetp)
>> -#define FD_ISSET(fd,fdsetp)  __FD_ISSET(fd,fdsetp)
>> -#define FD_ZERO(fdsetp)              __FD_ZERO(fdsetp)
>> -
>>  /*
>>   * Names of the interval timers, and structure
>>   * defining a timer setting:
>
>
>
