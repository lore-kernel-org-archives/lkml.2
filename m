Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab1FPWu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 18:50:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40967 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab1FPWuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 18:50:55 -0400
Message-ID: <4DFA88CC.6050306@codemonkey.ws>
Date: Thu, 16 Jun 2011 17:50:52 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
References: <1308153214.7566.6.camel@jaguar> <BANLkTi=krV7p9gT3E064aVoUCToVyZoL6w@mail.gmail.com>
In-Reply-To: <BANLkTi=krV7p9gT3E064aVoUCToVyZoL6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 09:48 AM, Pekka Enberg wrote:
> On Wed, Jun 15, 2011 at 6:53 PM, Pekka Enberg<penberg@kernel.org>  wrote:
>> - Fast QCOW2 image read-write support beating Qemu in fio benchmarks. See the
>>   following URL for test result details: https://gist.github.com/1026888
>
> It turns out we were benchmarking the wrong guest kernel version for
> qemu-kvm which is why it performed so much worse. Here's a summary of
> qemu-kvm beating tools/kvm:
>
> https://raw.github.com/gist/1029359/9f9a714ecee64802c08a3455971e410d5029370b/gistfile1.txt
>
> I'd ask for a brown paper bag if I wasn't so busy eating my hat at the moment.

np, it happens.

Is that still with QEMU with IDE emulation, cache=writethrough, and 
128MB of guest memory?

Does your raw driver support multiple parallel requests?  It doesn't 
look like it does from how I read the code.  At some point, I'd be happy 
to help ya'll do some benchmarking against QEMU.

It would be very useful to compare as we have some ugly things in QEMU 
that we've never quite been able to determine how much they affect 
performance.  Having an alternative implementation to benchmark against 
would be quite helpful.

Regards,

Anthony Liguori

>
>                          Pekka
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

