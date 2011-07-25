Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab1GYM7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:59:12 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55130 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1GYM7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:59:08 -0400
Message-ID: <4E2D6896.5010008@redhat.com>
Date: Mon, 25 Jul 2011 14:59:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Jan Kiszka <jan.kiszka@web.de>, Pekka Enberg <penberg@kernel.org>,
        mingo@elte.hu, avi@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger>  <4E2CA6DE.4040900@web.de> <1311580201.3446.30.camel@lappy>
In-Reply-To: <1311580201.3446.30.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 09:50 AM, Sasha Levin wrote:
> Anthony had a talk on last years KVM forum regarding the QEMU threading
> model (slide:
> http://www.linux-kvm.org/wiki/images/7/70/2010-forum-threading-qemu.pdf) .
>
> It was suggested that the KVM part of QEMU is having a hard time
> achieving the ideal threading model due to its need to support TCG -
> something which has nothing to do with KVM itself.

No, it is not having a hard time.  The "foot in the door" that Anthony 
mentions has been part of QEMU and qemu-kvm for a long time 
(multi-threading is necessary to support SMP!) and works quite well.


Historically, there were three main loops:

1) QEMU single-threaded;

2) QEMU multi-threaded; clean, but buggy, untested and bitrotting;

3) qemu-kvm multi-threaded, forked from (1), ugly but robust and widely 
deployed.

In 0.15 the two multi-threaded versions have been unified by Jan Kiszka. 
  I have even ported (2) to Windows with little or no pain; porting to 
Mac OS X interestingly is harder than Windows, because non-portable 
Linux assumptions about signal handling have crept in the code (to 
preempt the objections: they weren't just non-portabilities, they were 
latent bugs).  Windows just does not have signals. :)

So, right now, the only difference is that QEMU is still defaulting to 
the single-threaded main loop, while qemu-kvm enables multi-threading by 
default.  In some time even QEMU will switch.

Yes, this is of course worse than getting it right in the first place; 
Nobody is saying the opposite.

Paolo
