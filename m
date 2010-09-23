Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0IWOjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:39:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37427 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab0IWOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:39:39 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        l-o <linux-omap@vger.kernel.org>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        linux-doc <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3] power: introduce library for device-specific OPPs
Organization: Deep Root Systems, LLC
References: <1285192054-454-1-git-send-email-nm@ti.com>
	<201009230203.09230.rjw@sisk.pl> <4C9A9F84.7000104@ti.com>
Date: Thu, 23 Sep 2010 07:39:33 -0700
In-Reply-To: <4C9A9F84.7000104@ti.com> (Nishanth Menon's message of "Wed, 22
	Sep 2010 19:29:56 -0500")
Message-ID: <871v8k7cd6.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> Rafael J. Wysocki had written, on 09/22/2010 07:03 PM, the following:
>> [Trimming the CC list slightly.]
> [...]
>
>> ...
>>
>> First, thanks for addressing the previous comments, things look much better
>> now.  In particular the documentation has been improved a lot in my view.
> Thanks for the excellent reviews :)
>
> [...]
>
>>> +
>>> +WARNING on OPP List Modification Vs Query operations:
>>> +----------------------------------------------------
>>> +The OPP layer's query functions are expected to be used in multiple contexts
>>> +(including calls from interrupt locked context) based on SoC framework
>>> +implementation. Only OPP modification functions are guaranteed exclusivity by
>>> +the OPP library. Exclusivity between query functions and modification functions
>>> +should be handled by the users such as the SoC framework appropriately; else,
>>> +there is a risk for the query functions to retrieve stale data.
>>
>> Well, this sounds like a good use case for RCU.
> Kevin did point out rwlock but am I confusing with
> http://lwn.net/Articles/364583/
> If I get the message right, rwlock is more or less on it's way out?

RCU is different from the reader-writer locks that are on their way out.

Let's think about RCU a little more and see if it might be worth using.

As these APIs are infrequencly accessed, I'm thinking a single spinlock
to protect the whole list from concurrent access/modification is
sufficient.

Kevin
