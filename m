Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891Ab0FFLSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:18:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41847 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab0FFLSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iLWjXfYsrRGZ6EfySvnDuSueDaJmVBik3dtI9Ls+jlSXi1yIxygvQpvNbiUGWIYDxE
         dRH+L0KTSSL21Sz75Vum+0RqnCUFAHn5CvSh1FTvSnw5E2C9bWZyVBh4hYwT0eML8eHA
         vrl8ENZ5fueEQuq865yz4d3jrfNjLkYoLhHc4=
MIME-Version: 1.0
In-Reply-To: <20100605152326.7ccd5160@infradead.org>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
	<20100604071354.GA14451@elte.hu>
	<AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
	<20100604083423.GD15181@elte.hu>
	<AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
	<1275653210.27810.39762.camel@twins>
	<AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com>
	<1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
	<20100605152326.7ccd5160@infradead.org>
Date: Sun, 6 Jun 2010 14:18:36 +0300
Message-ID: <AANLkTimjtNhtI0CuxYd0wdN_svthC-vl9_a5abDS2yyo@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/6 Arjan van de Ven <arjan@infradead.org>:
> On Sat, 5 Jun 2010 14:26:14 -0700
> Arve Hjønnevåg <arve@android.com> wrote:
>> > the kernel has a set of infrastructure already to help here (range
>> > timers, with which you can wakeup-limit untrusted userspace crap),
>> > timer slack for legacy background timers, etc etc.
>>
>> Range timers allows the kernel to align different timers so they don't
>> each bring the cpu out of idle individually. They do not eliminate
>> timers or make individual timers fire less often.
>
> you're incorrect.
> With range timers you can control the rate at which timers fire just
> fine.

I was wondering... Currently GLib user-space aligns itself to fire
burst of work at second boundaries without the need for IPC. But if
you want to align beyond one second you need multi-process alignment.
Say, one application says: wake me up between 30s and 1m. And the
other one says: wake me up between 10m and 20m. They could very well
align at some point if there was a central process keeping track of
all the timers.

Does the kernel provide something to solve that problem already?

-- 
Felipe Contreras
