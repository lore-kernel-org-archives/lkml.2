Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3ACJGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:06:07 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:53011 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3ACJF7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Thu, 3 Jan 2013 04:05:59 -0500
Message-Id: <50E5580102000078000B29D1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 03 Jan 2013 09:05:53 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Rik van Riel" <riel@redhat.com>
Cc: <eric.dumazet@gmail.com>, <rostedt@goodmis.org>, <therbert@google.com>,
        <walken@google.com>, <jeremy@goop.org>, <tglx@linutronix.de>,
        <aquini@redhat.com>, <lwoodman@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff
 delay factor
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20121221185147.4ae48ab5@annuminas.surriel.com>
 <20121221185613.1f4c9523@annuminas.surriel.com>
 <20121222033339.GF27621@home.goodmis.org> <50D52E0C.6000103@redhat.com>
 <1356549008.20133.20856.camel@edumazet-glaptop>
 <50DB5531.90500@redhat.com>
 <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com>
 <1356618448.30414.948.camel@edumazet-glaptop>
 <50DC5CC0.6010003@redhat.com>
 <50DC9662020000780009210D@nat28.tlf.novell.com>
 <50DC9CE1.9030709@redhat.com>
In-Reply-To: <50DC9CE1.9030709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.12.12 at 20:09, Rik van Riel <riel@redhat.com> wrote:
> On 12/27/2012 01:41 PM, Jan Beulich wrote:
>>>>> Rik van Riel <riel@redhat.com> 12/27/12 4:01 PM >>>
>>> On 12/27/2012 09:27 AM, Eric Dumazet wrote:
>>>> So the hash sounds good to me, because the hash key could mix both lock
>>>> address and caller IP ( __builtin_return_address(1) in
>>>> ticket_spin_lock_wait())
>>>
>>> The lock acquisition time depends on the holder of the lock,
>>> and what the CPUs ahead of us in line will do with the lock,
>>> not on the caller IP of the spinner.
>>
>> The lock holder could supply its __builtin_return_address(0) for use
>> in eventual hashing.
>>
>> Also, with all of this - did you evaluate the alternative of using
>> monitor/mwait instead?
> 
> How much bus traffic do monitor/mwait cause behind the scenes?

I would suppose that this just snoops the bus for writes, but the
amount of bus traffic involved in this isn't explicitly documented.

One downside of course is that unless a spin lock is made occupy
exactly a cache line, false wakeups are possible.

Jan

