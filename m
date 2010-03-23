Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0CWWkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:40:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab0CWWky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:40:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=or8wfyOo7abiyLACXVTXg6p/LjYzjKnf7UeTIWoHva/KA/rJitj7iiIfvQgt7rTBe
	ZpDcqWaYIUKLL7/82Lvvw==
MIME-Version: 1.0
In-Reply-To: <201003232318.11332.rjw@sisk.pl>
References: <20100323090206.33932wop73sdefm6@unsolicited.net>
	 <bd4cb8901003230631q22cdac6dg8011489b94c6d5e0@mail.gmail.com>
	 <4BA8C7A4.8050502@ladisch.de> <201003232318.11332.rjw@sisk.pl>
Date: Tue, 23 Mar 2010 23:40:47 +0100
Message-ID: <bd4cb8901003231540m8930e64va042fc1caf287a3f@mail.gmail.com>
Subject: Re: 2.6.34-rc2 - crash on shutdown
From: Stephane Eranian <eranian@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Clemens Ladisch <clemens@ladisch.de>, David R <david@unsolicited.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 11:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 23 March 2010, Clemens Ladisch wrote:
>> Stephane Eranian wrote:
>> > On Tue, Mar 23, 2010 at 1:02 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
>> > > The only pointer access in this function is cpuhw->amd_nb, but
>> > > I don't see any obvious bugs.
>> >
>> > I reported a problem with the AMD initialization just last week.
>> > There is an issue with amd_pmu_cpu_online() which gets called
>> > too early, and thus fails. That leaves some bogus state and causes
>> > a crash in amd_pmu_cpu_offline().
>> >
>> > I proposed a fix which was rejected. The alternative involves moving
>> > some the of CPU initialization code (on AMD) to an earlier position,i.e.,
>> > which would be executed before the CPU_STARTED notifier. Nobody
>> > has proposed anything else so far.
>>
>> I don't know about the early bootmem stuff, but regardless of this issue,
>> if amd_pmu_cpu_online() can fail, then amd_pmu_cpu_offline() must be able
>> to handle this without blowing up.  Something like this (untested):
>
> I guess we handle that already:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a90110c61073eab95d1986322693c2b9a8a6a5f6
>
Ok, the fix avoids the crash but perf_events support for AMD is still broken.

The root of the problem is elsewhere as I pointed out last week. Peter proposed
a patch today and I think this would be enough to avoid the crash and have
perf_events working again on AMD.
