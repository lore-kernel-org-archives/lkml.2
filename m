Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab0ITWjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:39:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:6170 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab0ITWjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EO8jkd6aTFfEtE+87+ADccKaZuD8hhfa+OQCjtmZ6tYEv7MtwSkNFMMsLqP3UiyPZA
         ISQI5dmmyf4PxvTnx4mQ==
MIME-Version: 1.0
In-Reply-To: <4C97BFE7.6050202@zytor.com>
References: <tip-ea53069231f9317062910d6e772cca4ce93de8c8@git.kernel.org>
	<tip-a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a@git.kernel.org>
	<AANLkTimCXZWVb7ajANPg15Zuo22nst=d5p-MjXhzu1NX@mail.gmail.com>
	<4C97A5EF.4070100@zytor.com>
	<4C97BFE7.6050202@zytor.com>
Date: Mon, 20 Sep 2010 15:34:02 -0700
Message-ID: <AANLkTikJGJ_84fbtVTqGv-zsJUKUQBQO2ZG6tKQnzFCf@mail.gmail.com>
Subject: Re: [tip:x86/idle] x86, hotplug: Move WBINVD back outside the
 play_dead loop
From: Venkatesh Pallipadi <venki@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, asit.k.mallick@intel.com,
        arjan@linux.kernel.org, a.p.zijlstra@chello.hl, lenb@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 1:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/20/2010 11:20 AM, H. Peter Anvin wrote:
>> On 09/17/2010 05:48 PM, Venkatesh Pallipadi wrote:
>>>>
>>>> +       wbinvd();
>>>> +
>>>>        while (1) {
>>>> -               mb();
>>>> -               wbinvd();
>>>>                __monitor(&current_thread_info()->flags, 0, 0);
>>>>                mb();
>>>
>>>
>>> Just one observation. There are some CPUs with errata that need
>>> clflush before monitor. So, if that CPU wakesup spuriously it may have
>>> problem reentering idle. Not sure whether that will be a problem as
>>> that errata also depended on read happening on the flag. May be its
>>> better to do monitor (0, 0, 0).
>>>
>>
>> It seems the easy way to deal with that would be to just add clflush
>> before monitor... it is *probably* redundant, but it should be safe to
>> do. It means depending on X86_FEATURE_CLFLUSH as well as
>> X86_FEATURE_MWAIT, but I don't think there is any x86 processor which
>> has MWAIT and not CLFLUSH, and I highly doubt there ever will be.
>>
>> Does anyone see any downside?
>>
>
> Patch for review... anyone see any problem with it?
>

Looks good.

We can also close one of the longest standing bugs in
bugzilla.kernel.org  now :-)
https://bugzilla.kernel.org/show_bug.cgi?id=5471

Acked-by: Venkatesh Pallipadi <venki@google.com>
