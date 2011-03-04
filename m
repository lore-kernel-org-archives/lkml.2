Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab1CDVKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:10:42 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:62671 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab1CDVKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:10:37 -0500
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
        cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTimvhHxsMCf2FX0O8VqksOa2EAMz=S_C3LQKvE60@mail.gmail.com>
References: <1299174652.2071.12.camel@dan> <1299185882.3062.233.camel@calx>
	 <1299186986.2071.90.camel@dan> <1299188667.3062.259.camel@calx>
	 <1299191400.2071.203.camel@dan>
	 <2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
	 <AANLkTimpfk8EHjVKYsJv0p_G7tS2yB-n=PPbD2v7xefV@mail.gmail.com>
	 <1299260164.8493.4071.camel@nimitz>
	 <AANLkTim+XcYiiM9u8nT659FHaZO1RPDEtyAgFtiA8VOk@mail.gmail.com>
	 <1299262495.3062.298.camel@calx>
	 <AANLkTimRN_=APe_PWMFe_6CHHC7psUbCYE-O0qc=mmYY@mail.gmail.com>
	 <1299271041.2071.1398.camel@dan>
	 <AANLkTimvhHxsMCf2FX0O8VqksOa2EAMz=S_C3LQKvE60@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 16:10:34 -0500
Message-ID: <1299273034.2071.1417.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 22:58 +0200, Pekka Enberg wrote:
> On Fri, Mar 4, 2011 at 10:37 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> > This patch makes these techniques more difficult by making it hard to
> > know whether the last attacker-allocated object resides before a free or
> > allocated object.  Especially with vulnerabilities that only allow one
> > attempt at exploitation before recovery is needed to avoid trashing too
> > much heap state and causing a crash, this could go a long way.  I'd
> > still argue in favor of removing the ability to know how many objects
> > are used in a given slab, since randomizing objects doesn't help if you
> > know every object is allocated.
> 
> So if the attacker knows every object is allocated, how does that help
> if we're randomizing the initial freelist?

If you know you've got a slab completely full of your objects, then it
doesn't matter that they happened to be allocated in a random fashion -
they're still all allocated, and by freeing one of them and
reallocating, you'll still be next to your target.

