Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773Ab2B1OXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:23:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48222 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2B1OXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:23:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.50.47.228 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330438853.11248.90.camel@twins>
References: <1330442692.3719.7.camel@lappy> <1330435782.11248.89.camel@twins>
 <CA+1xoqfMad+s4-E-Nn29m3=bVASEkH38ZNvWg2vY99ZizdAT3Q@mail.gmail.com> <1330438853.11248.90.camel@twins>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 28 Feb 2012 16:23:31 +0200
Message-ID: <CA+1xoqdRES=RwUw8C+8=6neu7t0JZeBAxSaoT2+VA-Z+pvD6oQ@mail.gmail.com>
Subject: Re: lockdep: Warning & NULL ptr deref
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 4:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-02-28 at 16:19 +0200, Sasha Levin wrote:
>> On Tue, Feb 28, 2012 at 3:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, 2012-02-28 at 10:24 -0500, Sasha Levin wrote:
>> >>
>> >> I'll send some patches to prevent the NULL deref itself which happens
>> >> since a chunk of the code in lockdep.c assumed hlock_class() can't
>> >> return NULL.
>> >>
>> > There's tons of code actually assuming that..
>> >
>> >> This won't fix the actual problem though, I'm not sure exactly how a
>> >> held lock wouldn't have a class initialized to it.
>> >
>> > static inline struct lock_class *hlock_class(struct held_lock *hlock)
>> > {
>> >        if (!hlock->class_idx) {
>> >                /*
>> >                 * Someone passed in garbage, we give up.
>> >                 */
>> >                DEBUG_LOCKS_WARN_ON(1);
>> >                return NULL;
>> >        }
>> >        return lock_classes + hlock->class_idx - 1;
>> > }
>> >
>> > Typically that translates to severe memory corruption.
>>
>> I can also reproduce it easily by triggering sysrq once or twice after
>> trinity has stopped.
>
> What's trinity ?

Dave Jones' fuzzer tool. The git tree is located here:
http://codemonkey.org.uk/projects/trinity/trinity.git
