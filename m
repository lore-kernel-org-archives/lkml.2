Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab1CXSz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:55:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46660 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1CXSzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MlJpZ5stdVFIgwkZbnss4UbnKuAetDge1+XgAz4riYHrA5zZv9N/Ogim9rj8HYm+IV
         CP5ggivOOvyVtChHeeUjVL0nSUMgnc0QCSx8Nt7nVkPpw8n4cmMKVTDIW78PRCFXGr9W
         Rp/81rMkC8YoOQnXpnaqozwRWwBEx01Nokteo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103241346060.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	<20110324142146.GA11682@elte.hu>
	<alpine.DEB.2.00.1103240940570.32226@router.home>
	<AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	<20110324172653.GA28507@elte.hu>
	<alpine.DEB.2.00.1103241242450.32226@router.home>
	<AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
	<alpine.DEB.2.00.1103241300420.32226@router.home>
	<AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
	<alpine.DEB.2.00.1103241312280.32226@router.home>
	<1300990853.3747.189.camel@edumazet-laptop>
	<alpine.DEB.2.00.1103241346060.32226@router.home>
Date: Thu, 24 Mar 2011 20:55:54 +0200
X-Google-Sender-Auth: j9eNbbZqK9cJM-wXCXSMB01ByPY
Message-ID: <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 8:47 PM, Christoph Lameter <cl@linux.com> wrote:
>
> On Thu, 24 Mar 2011, Eric Dumazet wrote:
>
>> > this_cpu_cmpxchg16b_emu:
>> >         pushf
>> >         cli
>> >
>> >         cmpq %gs:(%rsi), %rax
>
>> Random guess
>>
>> Masking interrupts, and accessing vmalloc() based memory for the first
>> time ?
>
> Hmmm.. Could be. KVM would not really disable interrupts so this may
> explain that the test case works here.
>
> Simple fix would be to do a load before the cli I guess.

Btw, I tried Ingo's .config and it doesn't boot here so it's somehow
.config related.
