Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0IBPnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:43:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54310 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0IBPna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e56KUe0AIPH/IuJqPXbuGkwxqMWElp5oIbEh+ttHp191mziWFz6oQVuVbmlwlHAkKv
         8lCKpnED78PDpyHG8DQ3NFVH35L6vYUnwobrEcY0dJk79SW+iov/Bym5PqLY++zIZeS1
         kFG9XAeb+AH9k9/yddApZUMiIfYlI20Zq9o1M=
MIME-Version: 1.0
In-Reply-To: <x49iq2odv6p.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTi=O6Tpiz8TRFFknEpW7MMTGBAtqCpr7zH3abO67@mail.gmail.com>
	<x49fwxtqsh8.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikGYEuCE2-TaKwANwoCFEjVNL4KZa1AhJ2woGud@mail.gmail.com>
	<x49bp8gfeax.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimjuyHMkVPrjpPAe2sMwCAVnQjDigQkHmV4ZhAc@mail.gmail.com>
	<x49iq2odv6p.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 2 Sep 2010 16:43:28 +0100
Message-ID: <AANLkTim76cMyb8VC7TUkNGRagWmjFzbwf7-fMAMLzCd5@mail.gmail.com>
Subject: Re: I/O scheduler deadlocks on Xen virtual block devices
From: Doug Neal <dneallkml@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 4:25 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Doug Neal <dneallkml@gmail.com> writes:
>
>>>>>
>>>>> Did you try these different I/O schedulers in the domU or on the dom0?
>>>>> Does switching I/O schedulers in either place make the problem go away
>>>>> when it happens?
>>>>>
>>>>
>>>> In the domU, and the bug was present in all cases. The dom0 was using
>>>> cfq. I'll run the tests again using each scheduler in the dom0 with
>>>> domU set to noop and report back.
>>>
>>> While I think this is an interesting test, you need only test one I/O
>>> scheduler in the dom0.  Also, I think you misunderstood the second
>>> question.  I'd like to know if switching I/O schedulers while the system
>>> is in this bad state helps get I/O going again.
>>>
>> Jeff,
>>
>> Issue confirmed in the following cases:
>>
>> dom0:domU
>> noop:noop
>> noop:deadline
>> noop:anticipatory
>> cfq:noop
>> cfq:deadline
>> cfq:anticipatory
>> cfq:cfq
>>
>> I try switching schedulers in the domU during the lockup, the echo x >
>> /sys/block/xvda/queue/scheduler command also hangs. In the dom0, no
>> effect.
>
> OK.  So, this means that the I/O is not hung up in the I/O scheduler.  I
> don't have a whole lot of experience with the Xen I/O stack, but I think
> that's where I'd start digging (especially if there's nothing in the
> logs about command timed out).
>
> I hope this was a somewhat helpful exercise.  Sorry I can't be of more
> help.
>
> Cheers!
> Jeff
>

No problem, thanks for your assistance.


Doug
