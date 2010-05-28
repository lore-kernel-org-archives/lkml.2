Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab0E1VYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:24:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20967 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0E1VYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:24:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=uD5RZXfW6hXfaXs1qnxjk/smZAaySe8hyUNqH1e/TrLc+48pXgsjxV92x91KiOXmT
	A7rI7Cw3OD89U96/Scwnw==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005281351380.4045@localhost.localdomain>
References: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
	<1275026521-30835-1-git-send-email-lenb@kernel.org>
	<c4716a7a5639fd8f82dc6f2046b127e65a3851c5.1275026041.git.len.brown@intel.com>
	<AANLkTikRUyXMcIkqc3dRCtLPkKBOwOeyy_j1iILHeypj@mail.gmail.com>
	<alpine.LFD.2.00.1005281351380.4045@localhost.localdomain>
Date: Fri, 28 May 2010 14:24:11 -0700
Message-ID: <AANLkTikL7DZUhen_QaVPJ2FYoL8Xqfv8kQm3WU6iKtGt@mail.gmail.com>
Subject: Re: [PATCH 7/8] ACPI: acpi_idle: touch TS_POLLING only in the 
	non-MWAIT case
From: Venkatesh Pallipadi <venki@google.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 10:59 AM, Len Brown <lenb@kernel.org> wrote:
> On Fri, 28 May 2010, Venkatesh Pallipadi wrote:
>
>> On Thu, May 27, 2010 at 11:02 PM, Len Brown <lenb@kernel.org> wrote:
>> > From: Len Brown <len.brown@intel.com>
>> >
>> > commit d306ebc28649b89877a22158fe0076f06cc46f60
>> > (ACPI: Be in TS_POLLING state during mwait based C-state entry)
>> > fixed an important power & performance issue where ACPI c2 and c3 C-states
>> > were clearing TS_POLLING even when using MWAIT (ACPI_STATE_FFH).
>> > That bug had been causing us to receive redundant scheduling interrups
>> > when we had already been woken up by MONITOR/MWAIT.
>> >
>> > Following up on that...
>> >
>> > In the MWAIT case, we don't have to subsequently
>> > check need_resched(), as that c heck was there
>> > for the TS_POLLING-clearing case.
>> >
>> > Note that not only does the cpuidle calling function
>> > already check need_resched() before calling us, the
>> > low-level entry into monitor/mwait calls it twice --
>> > guaranteeing that a write to the trigger address
>> > can not go un-noticed.
>>
>> Ack this part of the change.
>>
>> > Also, in this case, we don't have to set TS_POLLING
>> > when we wake, because we never cleared it.
>>
>> I thought about this part of the change while working on the original
>> patch. But decided to leave the set to be done unconditionally as in
>> this case we are replacing "one write" by either "one read and one
>> jump" or "one read and one write" and I am not sure we gain much by
>> that.
>
> I don't know if the write is more expensive than the read and branch.
> In the scheme of things, these things are free and it is the IO
> accesses and locks in the idle path that take time.
>

Acked-by: Venkatesh Pallipadi <venki@google.com>
