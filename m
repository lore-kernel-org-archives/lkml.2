Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2BOF5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:57:47 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:54072 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab2BOF5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:57:17 -0500
MIME-Version: 1.0
In-Reply-To: <201202150022.26072.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<CAMP5XgeqXJroKtHZO18SESFxg1iGP=wHAa+CU1zEEXQqUEQwTA@mail.gmail.com>
	<201202150022.26072.rjw@sisk.pl>
Date: Tue, 14 Feb 2012 21:57:16 -0800
Message-ID: <CAMP5XgfgZphvsoFr62=oNoDUxXSeRXmu21Co3fGWXhZ17DgO_A@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/14 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday, February 14, 2012, Arve Hjønnevåg wrote:
>> On Mon, Feb 6, 2012 at 5:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> ...
>> but the wake-source timeout feature has some bugs or incompatible apis. An
>> init api would also be useful for embedding wake-sources in other data
>> structures without adding another memory allocation. Your patch to
>> move the spinlock init to wakeup_source_add still require the struct
>> to be zero initialized and the name set manually.
>
> That should be easy to fix.  What about the appended patch?
>

That works, but I still have to call more than one function before I
can use the wakeup-source (wakeup_source_init and wakeup_source_add)
and more than one function before I can free it (__pm_relax,
wakeup_source_remove and wakeup_source_drop). Is there any reason to
keep these separate?

Also, not copying the name when the caller provides the memory for the
wakeup-source would be a closer match to the wakelock api. Most of our
wakelocks pass a string constant as the name, and making a copy of
that string is not useful. wake_lock_init is also safe to call from
atomic context, but I don't know if anyone relies on this.

-- 
Arve Hjønnevåg
