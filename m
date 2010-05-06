Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab0EFPqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:46:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:36839 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758934Ab0EFPqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=F+dzPUunF3mjWmOcMBq7Y9nF+B5ORHgNAv/2A5H56+DtxQ3N9WgY9E7C/cSZ2msPxR
         5CP9QonO6TDH5uF4i8nB7qT0zDPT0brLx6jJk+Y39XkYaC5ZCk4/6TLnCadkKejgLW4T
         IqgkwRkzx8rzBAPOniOljs+Y3v2BR/arkcuzc=
Message-ID: <4BE2E444.9020108@gmail.com>
Date: Thu, 06 May 2010 17:46:12 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.5pre) Gecko/20100430 SUSE/3.1b2-7.1 Thunderbird/3.1b2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: Resource limits interface proposal [was: pull request for writable
 limits]
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com> <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org> <20100321060607.GA4062@x200> <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org> <4BE160C6.90404@gmail.com> <alpine.LFD.2.00.1005050757370.5478@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005050757370.5478@i5.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 05:08 PM, Linus Torvalds wrote:
> On Wed, 5 May 2010, Jiri Slaby wrote:
>> The drawback is when a 32-bit user passes down a value >= (1 << 32),
>> EINVAL shall occur.
> 
> I'd almost prefer to just turn them into RLIMIT_MAX. If somebody asks for 
> a really huge limit that is bigger than the max we already have, doesn't 
> RLIMIT_MAX sound like the right thing?

Yes, silently setting the highest possible value (INFINITY) is OK too
(as we cannot do better anyway).

>> Just a side note, we cannot use the rlimit64 name which is already
>> reserved in glibc headers for limits handling.
> 
> What does the glibc 'struct rlimit64' look like? It's the structure name 
> that matters, since the system call name would presumably be 'prlimit64()' 
> due to the pid thing.
> 
> And if the glibc rlimit64 matches what we would use, I think we can decide 
> to just re-use it.

With glibc-2.11.1 which I have includes from:
#ifdef __USE_LARGEFILE64
struct rlimit64
  {
    /* The current (soft) limit.  */
    rlim64_t rlim_cur;
    /* The hard limit.  */
    rlim64_t rlim_max;
 };
#endif

where rlim64_t expands to __u_quad_t which is
#if __WORDSIZE == 64
typedef unsigned long int __u_quad_t;
#elif defined __GLIBC_HAVE_LONG_LONG
__extension__ typedef unsigned long long int __u_quad_t;
#endif

so something like our u64. The structure is the same to what we are
about to use. If nobody objects?

-- 
js
