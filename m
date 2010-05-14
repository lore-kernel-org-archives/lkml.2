Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab0ENITP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:19:15 -0400
Received: from csmtp2.one.com ([91.198.169.22]:42613 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab0ENIS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:18:59 -0400
Message-ID: <4BED0770.3080608@bitmath.org>
Date: Fri, 14 May 2010 10:18:56 +0200
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] input: mt: Simplify event bypass logic
References: <1272721779-2124-1-git-send-email-rydberg@euromail.se> <20100504064905.GB17482@core.coreip.homeip.net>
In-Reply-To: <20100504064905.GB17482@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Sat, May 01, 2010 at 03:49:39PM +0200, Henrik Rydberg wrote:
>> The input bypass mechanism is only used by the MT events. Since all
>> MT events use bypassing by construction, the current list is a mere
>> duplication of input.h. This patch replaces the bypass list by a
>> simple range test.
>>
> 
> Henrik,
> 
> I disagree with the patch. I can not guarantee that we will be able to
> maintain continuous range of ABS_MT_* events and thus current scheme is
> more flexible.

Coming back to this, the current scheme has problems, too.

With the introduction of slots, all events, not only EV_ABS events, are
implicitly partitioned into global events and per-slot events. In the current
approach, the partitioning is controlled via the hidden list in input.c, and
hinted using the prefix MT. However, expecting the usage of slots to grow
outside of a linear range of EV_ABS events, the user will inevitably need to
known the semantics of particular events in order to parse correctly. And once
the user starts to deal with that information, it can just as well be dynamic,
and controlled by the device driver.

My proposition is to add a bit field in input_dev which controls whether a
particular event is used in the slot context or the global context. This
information should be user-readable via EVIO. The driver should be able to alter
these settings, and the default should match the current behavior.

Thoughts?

Cheers,
Henrik

