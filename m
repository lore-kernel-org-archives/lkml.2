Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1DDQIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:08:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53423 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab1DDQIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cjyYZmGvUQaUFhk1yQQVU0CYt6CVDK6JYB1RW1ESSC6ykBx2oV0iqB/9W1ezRyJ/wa
         fFaeVyHbNi+OMSan2G07m7ydp0DNu9RPDklYxyoF259rt8zoZtXDr0jlXVVP1J3CiLI1
         BtIaU/oGW8pDYV+dVshEbhi8ln9cIOscOPtj0=
MIME-Version: 1.0
In-Reply-To: <BANLkTikZS8zZ-oRfBsriEnzp17VMwXAjSg@mail.gmail.com>
References: <20110402103125.GA18746@elte.hu>
	<BANLkTikZS8zZ-oRfBsriEnzp17VMwXAjSg@mail.gmail.com>
Date: Mon, 4 Apr 2011 21:38:45 +0530
Message-ID: <BANLkTikhOkVOMvJwzdbiEEKgQa4Z2SUsJw@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler fixes
From: Sisir Koppaka <sisir.koppaka@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 9:15 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So I pulled this, but I think this:
>
> On Sat, Apr 2, 2011 at 3:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> -               if (interval > HZ*NR_CPUS/10)
>> -                       interval = HZ*NR_CPUS/10;
>> +               if (interval > HZ*num_online_cpus()/10)
>> +                       interval = HZ*num_online_cpus()/10;
>
> is a horrible patch.
>
> Think about what that expands to. It's going to potentially be two
> function calls. And the code is just ugly.
>
> So please, when doing search-and-replace changes like this, just clean
> up the code at the same time. Back when it was about pure constants,
> there was only a typing/ugly overhead from duplicating the constant,
> but the compiler would see a single constant.
>
> Now it's _possible_ that the compiler could do the analysis and fold
> it all back to a single thing. But it's unlikely to happen except for
> configurations that end up making it all trivial.
>
> So just add something like a
>
>   int max_interval = HZ*num_online_cpus()/10;
>
> possibly even with a comment about _why_ that is the max interval allowed.  Ok?
>
>                        Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Ok sure. You're right, I'll resend the patch.
Sisir
