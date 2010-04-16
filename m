Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985Ab0DPEN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 00:13:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33785 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0DPEN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 00:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vPPOQvK/PclFsdo+4fzQ1SdZv62LZHpQqTnZxZmql18j/SoptTNhgtdGnO4VU8flNV
         LXEIV4Btp7E2DCJXpLrqPHyuGOulcydPDo1mUfsxMlcG7NF5RYgH0Io3Rl4W4VPeMARj
         0nxEtAxokk8s9kinbVNapELgnQD8zEO8tKhS4=
MIME-Version: 1.0
In-Reply-To: <20100415231529.GB15570@nowhere>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
	 <1271262016-18650-2-git-send-email-chase.douglas@canonical.com>
	 <20100415205739.GF5069@nowhere>
	 <v2t40ec3ea41004151449x70e7077flb8d1fea5e8d46167@mail.gmail.com>
	 <20100415231529.GB15570@nowhere>
Date: Thu, 15 Apr 2010 21:13:25 -0700
X-Google-Sender-Auth: 49e6840697cd54df
Message-ID: <m2i40ec3ea41004152113kf902102ex31e35c1bff5060ab@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add tracing_off_event() calls to BUG() and WARN() 
	paths
From: Chase Douglas <chase.douglas@canonical.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 4:15 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Apr 15, 2010 at 02:49:05PM -0700, Chase Douglas wrote:
>> On Thu, Apr 15, 2010 at 1:57 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > On Wed, Apr 14, 2010 at 12:20:15PM -0400, Chase Douglas wrote:
>> >> This change adds tracing_off_event() calls, which stop debug tracing,
>> >> when a BUG() or WARN() function is called. The stoppage depends on
>> >> commandline paramenter tracing_off={bug,warn,none}. The default is
>> >> "bug", so only the BUG() paths will stop tracing.
>> >>
>> >> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>> >
>> >
>> > ACK
>> >
>> > But I can't find where we call oops_enter() from panic()
>> > I see it called in x86 from oops_begin() that is called
>> > in various places like die(), but couldn't find how it
>> > ends up beeing called from panic().
>>
>> I did not test the panic() path, but when that happens the system goes
>> down anyways. You won't be able to get the ftrace unless you enable
>> the ftrace on oops option, in which case the end of the trace will
>> likely be close enough to what you are looking for anyways.
>
>
> Yeah but there is also a sysrq that can trigger an ftrace dump.
> So if you forgot ftrace dump on oops and you want to use the sysrq
> then you don't want the tracing to continue between the panic and
> the time for your fingers to reach the keyboard (that notwithstanding
> the time to remember the right combination...which I always forget).

Ahhh, I can see where this would be useful then. I'll just add an
event to panic() like I did the other paths.

-- Chase
