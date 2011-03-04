Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1CDGwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:52:08 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:40149 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1CDGwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:52:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XM7sZVZwjOVDxwaiLPW9pf5HvZ5TSC1k8KbM6pK5DOrt1HbFlOgQAlQeYQ4PYamJ42
         jWMw90DwHGbFL5uvqpJdSxceCNIGSljH/YmJgfT7s0KAJOWmUO0TlIVAwiwYSpi2jgUy
         2Vi/w6ZTEPNtxKJl7bGJDNcRGrJy30haWIc/g=
MIME-Version: 1.0
In-Reply-To: <2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
References: <1299174652.2071.12.camel@dan>
	<1299185882.3062.233.camel@calx>
	<1299186986.2071.90.camel@dan>
	<1299188667.3062.259.camel@calx>
	<1299191400.2071.203.camel@dan>
	<2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
Date: Fri, 4 Mar 2011 08:52:04 +0200
X-Google-Sender-Auth: QZiLiojxnQtMV4gq37Tkpj-6ams
Message-ID: <AANLkTimpfk8EHjVKYsJv0p_G7tS2yB-n=PPbD2v7xefV@mail.gmail.com>
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Pekka Enberg <penberg@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Matt Mackall <mpm@selenic.com>,
        cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 3, 2011, at 5:30 PM, Dan Rosenberg wrote:
>> I appreciate your input on this, you've made very reasonable points.
>> I'm just not convinced that those few real users are being substantially
>> inconvenienced, even if there's only a small benefit for the larger
>> population of users who are at risk for attacks.  Perhaps others could
>> contribute their opinions to the discussion.

On Fri, Mar 4, 2011 at 2:50 AM, Theodore Tso <tytso@mit.edu> wrote:
> Being able to monitor /proc/slabinfo is incredibly useful for finding various
> kernel problems.  We can see if some part of the kernel is out of balance,
> and we can also find memory leaks.   I once saved a school system's Linux
> deployment because their systems were crashing once a week, and becoming
> progressively more unreliable before they crashed, and the school board
> was about to pull the plug.

Indeed. However, I'm not sure we need to expose the number of _active
objects_ to non-CAP_ADMIN users (which could be set to zeros if you
don't have sufficient privileges). Memory leaks can be detected from
the total number of objects anyway, no?

On Fri, Mar 4, 2011 at 2:50 AM, Theodore Tso <tytso@mit.edu> wrote:
> I wonder if there is some other change we could make to the slab allocator
> that would make it harder for exploit writers without having to protect the
> /proc/slabinfo file.  For example, could we randomly select different free
> objects in a page instead of filling them in sequentially?

We can do something like that if we can live with the performance costs.
