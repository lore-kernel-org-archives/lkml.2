Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0E2PMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 11:12:07 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32131 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab0E2PMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 11:12:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=JMmvTAHa5ZwwUtM/IHG2bMqcDYwNdRF/Ns7wvv95VSq8kLvQW2VBbk+DPsADjiBFw
	vaWiYZ/Ghl4Ozn7Ei5Vaw==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005291056490.31946-100000@netrider.rowland.org>
References: <AANLkTimyLsldXoZ_egjybwS9kE_OcxsOuZwC0F-C2HjY@mail.gmail.com>
	<Pine.LNX.4.44L0.1005291056490.31946-100000@netrider.rowland.org>
Date: Sat, 29 May 2010 08:11:58 -0700
Message-ID: <AANLkTim7LMG0kcYwmcL9AcdR5-GgcCyb2ZagJhGyt2_e@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 8:03 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 29 May 2010, Brian Swetland wrote:
>> On Sat, May 29, 2010 at 7:10 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > If no such constraints are active, the QoS-based suspend blocks in an
>> > interruptible wait until the number of active QOS_EVENTUALLY
>> > constraints drops to 0.  When that happens, it carries out a normal
>> > suspend-to-RAM -- except that it checks along the way to make sure that
>> > no new QoS constraints are activated while the suspend is in progress.
>> > If they are, the PM core backs out and fails the QoS-based suspend.
>>
>> The issue with this approach is that if userspace wants to suspend
>> while a driver is holding a QOS_EVENTUALLY constraint, it's basically
>> going to spin constantly writing "qos" and failing.
>
> No, no.  If userspace wants to suspend while a driver is holding a
> QOS_EVENTUALLY constraint, the user process blocks in an interruptible
> wait state as described in the first paragraph above.

Oops -- I misread the first paragraph.  The behavior you described is
indeed what I would want.

Brian
