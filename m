Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab2L0GHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 01:07:53 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:42289 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2L0GHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 01:07:51 -0500
MIME-Version: 1.0
In-Reply-To: <50DB5531.90500@redhat.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	<20121221185147.4ae48ab5@annuminas.surriel.com>
	<20121221185613.1f4c9523@annuminas.surriel.com>
	<20121222033339.GF27621@home.goodmis.org>
	<50D52E0C.6000103@redhat.com>
	<1356549008.20133.20856.camel@edumazet-glaptop>
	<50DB5531.90500@redhat.com>
Date: Wed, 26 Dec 2012 22:07:50 -0800
Message-ID: <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay factor
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Herbert <therbert@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 11:51 AM, Rik van Riel <riel@redhat.com> wrote:
> On 12/26/2012 02:10 PM, Eric Dumazet wrote:
>> We might try to use a hash on lock address, and an array of 16 different
>> delays so that different spinlocks have a chance of not sharing the same
>> delay.
>>
>> With following patch, I get 982 Mbits/s with same bench, so an increase
>> of 45 % instead of a 13 % regression.

Awesome :)

> I will probably keep it as a separate patch 4/4, with
> your report and performance numbers in it, to preserve
> the reason why we keep multiple hashed values, etc...
>
> There is enough stuff in this code that will be
> indishinguishable from magic if we do not document it
> properly...

If we go with per-spinlock tunings, I feel we'll most likely want to
add an associative cache in order to avoid the 1/16 chance (~6%) of
getting 595Mbit/s instead of 982Mbit/s when there is a hash collision.

I would still prefer if we could make up something that didn't require
per-spinlock tunings, but it's not clear if that'll work. At least we
now know of a simple enough workload to figure it out :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
