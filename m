Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1FUHYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:24:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34990 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab1FUHYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HDwu2NZNtKK0nnaG4X90hMfyNAXYt/wVvYnl0qoTAT58Fj7/rFYD/9o7eb3EwtPDcC
         2p40iw/nkmHCrpC48x0rYq59zvhLUu/q2xqQgnquVSxiAjHdyapX/8i0O75+3JRy66dq
         8NwU9pL6seml+9nPPtxCDrJv8DrhVEp5A+3XQ=
MIME-Version: 1.0
In-Reply-To: <20110620203320.GC17157@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
	<1308322240-8247-6-git-send-email-tj@kernel.org>
	<20110620203320.GC17157@redhat.com>
Date: Tue, 21 Jun 2011 09:24:15 +0200
X-Google-Sender-Auth: 9VEFdu-hAAgng3wYC-5tI3jr5BI
Message-ID: <BANLkTinDM8_vaevEtJa++hAu5JOEOYhwsA@mail.gmail.com>
Subject: Re: [PATCH 5/7] ptrace: kill clone/exec tracehooks
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 20, 2011 at 10:33 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> +     if (likely(user_mode(regs)) && !(clone_flags & CLONE_UNTRACED)) {
>
> Off-topic, but I never understood this user_mode() check... OK, a
> traced task can call kernel_thread() in kernel, but this used
> CLONE_UNTRACED.

Me neither.  I suppose it's added as a safety net.  Maybe we can turn
it into WARN_ON(!user_mode) && !CLONE_UNTRACED) but just leaving it
alone doesn't sound like a bad idea.

>> +             if (clone_flags & CLONE_VFORK)
>> +                     trace = PTRACE_EVENT_VFORK;
>> +             else if ((clone_flags & CSIGNAL) != SIGCHLD)
>> +                     trace = PTRACE_EVENT_CLONE;
>> +             else
>> +                     trace = PTRACE_EVENT_FORK;
>> +
>> +             if (likely(!ptrace_event_enabled(current, trace)))
>> +                     trace = 0;
>> +     }
>
> As I said am going to apply this all except 6/7, but imho this
> deserves a trivial helper anyway.

Yeah, maybe.  Preference, I guess.

Thanks.

-- 
tejun
