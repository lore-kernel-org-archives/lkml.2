Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab1ENPqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 11:46:21 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:52121 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab1ENPqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 11:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=eEpi17llVdoeGBjRdMFYr87gzXojeLqGCV2m+1VwBXjTCE2w8vzazuu/W7xj6DT0OX
         6O/bEKkjMDwyj67nrUl7fTzgDJXv799JhQasDCapM9EvaeoF5jzbCg2CH9mZRcNS4fVa
         c+sWQbwnXXllinimmTXAb+cb7vJOGNCMVXM7E=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
References: <BANLkTi=XqROAp2MOgwQXEQjdkLMenh_OTQ@mail.gmail.com>
 <m2fwokj0oz.fsf@firstfloor.org> <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
 <20110512054631.GI6008@one.firstfloor.org> <BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 14 May 2011 11:46:00 -0400
X-Google-Sender-Auth: zIlbYU_DN78ySaP9IS7dxyk6HAA
Message-ID: <BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc linux-mm]

On Thu, May 12, 2011 at 7:54 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Thu, May 12, 2011 at 1:46 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>> Here's a nice picture of alt-sysrq-m with lots of memory free but the
>>> system mostly hung.  I can still switch VTs.
>>
>> Would rather need backtraces. Try setting up netconsole or crashdump
>> first.
>
> Here are some logs for two different failure mores.
>
> incorrect_oom_kill.txt is an OOM kill when there was lots of available
> swap to use.  AFAICT the kernel should not have OOM killed at all.
>
> stuck_xyz is when the system is wedged with plenty (~300MB) free
> memory but no swap.  The sysrq files are self-explanatory.
> stuck-sysrq-f.txt is after the others so that it won't have corrupted
> the output.  After taking all that data, I waited awhile and started
> getting soft lockup messges.
>
> I'm having trouble reproducing the "stuck" failure mode on my
> lockdep-enabled kernel right now (the OOM kill is easy), so no lock
> state trace.  But I got one yesterday and IIRC it showed a few tty
> locks and either kworker or kcryptd holding (kqueue) and
> ((&io->work)).
>
> I compressed the larger files.
>
> --Andy
