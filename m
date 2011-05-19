Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab1ESOLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:11:23 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:39981 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab1ESOLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=s4euBDkynet+MP7bEXgmWNI7jPIRuRuVsUGmYM9s3dXVdZhWLF/A7fn+2SnFNylTyx
         1oJX7nAj7h1v8njgDZuqMyB6ur8imd1FBsP+TobAALmyKfGXjpR/8onNEwzCfZCzUpvF
         cQgaOr1Yt68d4LWrmZk2ZXcSgWN8KdvH62+mc=
MIME-Version: 1.0
In-Reply-To: <20110519135336.GI12317@one.firstfloor.org>
References: <8f0d3bec51be8d9a2c37bac5aeb64c35cb387640.1305811184.git.luto@mit.edu>
 <20110519135336.GI12317@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 19 May 2011 10:11:01 -0400
X-Google-Sender-Auth: 9W3xIRHcDbhTNsK9tLC1DACaRTY
Message-ID: <BANLkTin0gqQopry+nLDZX1DdQC9-c70nmA@mail.gmail.com>
Subject: Re: [PATCH] x86-64: Add time to vDSO
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 9:53 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, May 19, 2011 at 09:24:48AM -0400, Andy Lutomirski wrote:
>> The only fast implementation of time(2) we expose is through the
>> vsyscall page and we want to get userspace to stop using the
>> vsyscall page.  So make it available through the vDSO as well.
>
> User space can just use vgettimeofday() and only take the seconds.
> Adding time() too was a mistake back then.
>
> And BTW just for seconds alone you wouldn't need the seqlock.

True.  I just copied this from the vsyscall code.  I can optimize it,
but maybe that should be a followup patch.  I'd rather not duplicate
code like this, but that would need some additional infrastructure.

Note that this is five times as fast as vgettimeofday on Sandy Bridge
with my patches.  Without the patches it's seven times as fast, and on
older machines it's more like 100 times faster.  I'm not sure that
having glibc use CLOCK_REALTIME_COARSE is a good idea -- some day we
might want to get rid of the periodic tick even under load and then
time() should do something clever.

--Andy

>
> -Andi
>
