Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2IXUnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:43:11 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33876 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab2IXUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <5060C330.1000407@zytor.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
	<20120921220818.GA30959@redhat.com>
	<505CE5C8.80007@linux.intel.com>
	<20120922113226.GA3257@gmail.com>
	<5060C330.1000407@zytor.com>
Date: Mon, 24 Sep 2012 13:43:07 -0700
X-Google-Sender-Auth: pKINiOvAf7m6WmrGqlmFNGzs-zE
Message-ID: <CAGXu5jJraZJc2nYZUEDeroa9qwy_sN9kvFYAJvdubQ_wky25zw@mail.gmail.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linda Wang <lwang@redhat.com>, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 1:31 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/22/2012 04:32 AM, Ingo Molnar wrote:
>>
>> * H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>>> On 09/21/2012 03:08 PM, Dave Jones wrote:
>>>>
>>>> Perhaps add a printk somewhere to show that it's actually been enabled maybe ?
>>>>
>>>> Also, would it be feasible to add something like we have for test_nx ?
>>>> If this feature regresses in some way in the future, I suspect we'd like
>>>> to know about it sooner rather than later.
>>>
>>> Good idea... should add this both for SMEP and SMAP.
>>
>> Very much agreed - these exploit preventation hardware features
>> are really useful, and it's good to inform the user that they
>> are active.
>>
>
> I was thinking about this, do you think a printk would be better, or a
> new field in /proc/cpuinfo?

We use printk for displaying the possible states of NX, however, this
is rather ephemeral and scrolls away, making its harder for an admin
to find later. It might make sense for a new field in cpuinfo for all
three, however, unlike NX, the status of SMEP/SMAP isn't (normally)
discoverable from userspace. That said, their CPU feature flags are
already right there, and the cases where it would be disabled are very
small.

How about this...

mem protection  : nx smap smep

Maybe the "why" of a cpu feature being missing from the "mem
protection" line can stay in printk?

-Kees

-- 
Kees Cook
Chrome OS Security
