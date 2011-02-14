Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab1BNR5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:57:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62430 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1BNR5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=htvIbo1K/B8mk6HSgbKS9/ITJg6GHDKOYWpcDKqEro2za217Kr15r6d+W1/R8J9vcV
         ObBctHn+fd+u7dCLEp0A6An0A4tjV48/7SHAItznW4q7fVEAA4M6We8nUWc8gttD2Szn
         U/r+QFixFbuQ4K9sVAoUyPQ54frJEdLvYS+OE=
MIME-Version: 1.0
In-Reply-To: <20110214173910.GA15847@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com>
 <20110214153149.GB8761@redhat.com> <AANLkTikYf1CE41x6FjE6FiZ40v8taRSy8aZ3-5tjAvok@mail.gmail.com>
 <20110214173910.GA15847@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 14 Feb 2011 18:57:31 +0100
Message-ID: <AANLkTiku4OQKgwCHF-c5dc4AZzmuCKmzk0EuTaqxK_Wr@mail.gmail.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 6:39 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/14, Denys Vlasenko wrote:
>>
>> On Mon, Feb 14, 2011 at 4:31 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 02/13, Denys Vlasenko wrote:
>> >>
>> >> $ strace -tt sleep 30
>> >> 23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
>> >> ...
>> >> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
>> >> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> >> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> >>     (I forgot again why we see it twice. Another quirk I guess...)
>> >
>> >      (this is correct, the tracee reports the signal=SIGSTOP, then
>> >       it reports it actually stopps with exit_code=SIGSTOP)
>>
>> Ah, I see. Is there any way debugger can distinguish between these two
>> different stops?
>
> IIRC, the (only?) way to distinguish is to check last_siginfo != NULL
> via ptrace(PTRACE_GETSIGINFO).

What do you think strace needs to do when it sees second SIGSTOP
(meaning "in theory", not "on current kernel which may be buggy")?

ptrace(PTRACE_SYSCALL, $PID, 0x1, 0)?
nothing?
something else?

-- 
vda
