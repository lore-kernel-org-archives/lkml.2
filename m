Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0EFGjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:39:31 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56431 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0EFGja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:39:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NPfIvVyWlDQfxa3xXKFqVg29b7KN4bnteFNZ7Ia8QDigt5CApaGMZY1fnvdnpEQzdA
         bnlXpqcQcLj7J7Uv1K27uvAXP9Dj07H5ZM7MfolVr4YYemR/s/Gh15zhezCLf0wzCUOa
         1MB0FS6m2VSm1he5FPd8ohuQFd0y/3xyaUmT0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005050757370.5478@i5.linux-foundation.org>
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com>
	 <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org>
	 <20100321060607.GA4062@x200>
	 <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org>
	 <4BE160C6.90404@gmail.com>
	 <alpine.LFD.2.00.1005050757370.5478@i5.linux-foundation.org>
Date: Thu, 6 May 2010 09:39:28 +0300
Message-ID: <m2jb6fcc0a1005052339h3dd5c77cwd762c65a23180638@mail.gmail.com>
Subject: Re: Resource limits interface proposal [was: pull request for 
	writable limits]
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 6:08 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> It may also be that rlimit64 will contain flags like:
>> #define RLIM64_CUR_INFINITY     0x00000001
>> #define RLIM64_MAX_INFINITY     0x00000002
>> struct rlimit64 {
>>         __u64 rlim_cur;
>>         __u64 rlim_max;
>>         __u32 flags;
>> };
>> if I understood Alexey correctly to separate limits values from
>> infinity? flags then will be converted to ~0ul when converting from
>> rlimit64 to rlimit above too.
>
> Ok, I'm not entirely sure we need to care specially about INFINITY,
> _especially_ since INF is really rather big in 64 bits. So to some degree,
> making things 64-bit is _less_ likely to make INFINITIES a problem.

I'm _sure_, someone will mention bloat and performance degradation
on 32-bit, so there will be config option for 32-bit in-kernel limits.
And if there will be config option, infinities are better be separated.
