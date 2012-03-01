Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2CATCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:02:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64631 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab2CATCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:02:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of vda.linux@googlemail.com designates 10.180.95.34 as permitted sender) smtp.mail=vda.linux@googlemail.com; dkim=pass header.i=vda.linux@googlemail.com
MIME-Version: 1.0
In-Reply-To: <4F4FC037.4060201@am.sony.com>
References: <4F4E6915.1010209@am.sony.com> <m2mx81pi7x.fsf@firstfloor.org>
 <4F4E8E6A.2020601@am.sony.com> <201203010812.54769.vda.linux@googlemail.com> <4F4FC037.4060201@am.sony.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 1 Mar 2012 20:02:33 +0100
Message-ID: <CAK1hOcOdqvSDkR18FQzvP27jsFjH3Hu9ftQDM26Vo-sFkTjhFQ@mail.gmail.com>
Subject: Re: Questions about ptrace on a dying process
To: Tim Bird <tim.bird@am.sony.com>
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        linux kernel <linux-kernel@vger.kernel.org>, tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 7:30 PM, Tim Bird <tim.bird@am.sony.com> wrote:
>>> Yeah - I may be doing something new here.  Android uses ptrace
>>> in debuggerd, which is their crash reporting tool, but they wake
>>> it up with signals before the dying program goes into coredump.
>>
>> I think ptrace API does not provide guarantees that it is possible
>> to attach to the process when it coredumps.
>>
>> It might work in current kernels, but might break in new ones.
>
> If it's not too much trouble, it would be nice to continue
> this behaviour.   Admittedly, my style of crash handling appears
> to be new, and I don't want to unnecessarily burden the code,
> but so far it works really well, and currently requires very
> minimal change to the existing ptrace code.  One thing that's
> nice about what I'm doing, is that I don't rely on the
> whole signal state machine of the process to interact with it
> (since a dying process can't respond correctly).
>
> So hopefully, continuing to support ptrace for a dying process
> won't interfere or burden the existing (rather complex)
> state processing in the current code.
>
> Just for reference, below is the patch I settled on for my own kernel.

You added yet another quirk to ptrace API - and this API
already has no shortage of quirks.
Of course you can maintain it for your kernel, but
adding it in mainline is a bizarre proposition.

I'm not even sure that _if_ PTRACE_SEIZE with PTRACE_O_TRACEEXIT
option works on semi-dead core-dumping process today without
patching, it is guaranteed to do so in the future.


> I'm planning taking a look at the PTRACE_SEIZE code to see if it
> accomplishes what I need, but haven't done that yet.
>
> I do have a question, though - how will a tracer know that it can
> use PTRACE_SEIZE?

By looking at kernel version.

-- 
vda
