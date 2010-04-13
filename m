Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0DMVG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:06:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35097 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0DMVG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=aMGUWQFvjWnq/SgH2dfsznzLy0pn9g6kMqYEzPnqBx7+/QenIpJpJ/5LD/lhFAB7xJ
         uub3BOmvsLTZJnsILTfF+INbBCc6uj0w9Td409GotuWvk20PdleMPvviSuSkDkm6TZUS
         Jl3S9WPcuTedby1rKTbPsW4Wa3hFV+fRaDIWA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004132302010.7682@localhost.localdomain>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
	 <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
	 <20100401122740.a1ae80a7.akpm@linux-foundation.org>
	 <z2i40ec3ea41004011256p281cc601t277c3191fef5f87b@mail.gmail.com>
	 <alpine.LFD.2.00.1004012200340.32352@localhost.localdomain>
	 <20100413133903.9d38a6ee.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004132302010.7682@localhost.localdomain>
Date: Tue, 13 Apr 2010 14:06:55 -0700
X-Google-Sender-Auth: 1468668d56b50d6f
Message-ID: <z2g40ec3ea41004131406s3667f2d9n385f898144cd57c5@mail.gmail.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till 
	after load update period
From: Chase Douglas <chase.douglas@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 2:02 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 13 Apr 2010, Andrew Morton wrote:
>
>> On Thu, 1 Apr 2010 22:01:59 +0200 (CEST)
>> Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> > On Thu, 1 Apr 2010, Chase Douglas wrote:
>> > > On Thu, Apr 1, 2010 at 3:27 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > >
>> > > Thomas Gleixner seems to think this isn't the best approach (later
>> > > email in this thread), so I'm deferring sending it unless someone is
>> > > still interested in this approach.
>> >
>> > Well, it's a good workaround for now I think, I just answered Andrews
>> > question whether we can't do any better :)
>> >
>>
>> So... should we merge Chase's patch?
>
> I have no better solution right now. Peter ?

I've made one small change to it. Checking the atomic .counter
variable probably isn't the most portable, and atomic_long_read()
should be portable and not add any overhead on sane platforms, so I
swapped out the check against .counter with an atomic_long_read().
I'll resend it shortly.

-- Chase
