Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab1CDVa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:30:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37414 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760210Ab1CDVa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:30:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DSl+XLcO1ZzmVa3uVJhDn0vLBfIg5ccd2a6AYGUocmS2nkA4nmeOkGqsI6jJc9AdCp
         znrEgdbwluAx2CpPu+AkZrK3v39mWlhep5psvSbGw2mMCtvXO9owspZ7sdyBgdIlqaDB
         GVkgykv6k7WoULUyRorn44+2mYwSn7oNJIepg=
MIME-Version: 1.0
In-Reply-To: <1299272907.2071.1415.camel@dan>
References: <1299174652.2071.12.camel@dan>
	<1299185882.3062.233.camel@calx>
	<1299186986.2071.90.camel@dan>
	<1299188667.3062.259.camel@calx>
	<1299191400.2071.203.camel@dan>
	<2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
	<AANLkTimpfk8EHjVKYsJv0p_G7tS2yB-n=PPbD2v7xefV@mail.gmail.com>
	<1299260164.8493.4071.camel@nimitz>
	<AANLkTim+XcYiiM9u8nT659FHaZO1RPDEtyAgFtiA8VOk@mail.gmail.com>
	<1299262495.3062.298.camel@calx>
	<AANLkTimRN_=APe_PWMFe_6CHHC7psUbCYE-O0qc=mmYY@mail.gmail.com>
	<1299270709.3062.313.camel@calx>
	<1299271377.2071.1406.camel@dan>
	<AANLkTik6tAfaSr3wxdQ1u_Hd326TmNZe0-FQc3NuYMKN@mail.gmail.com>
	<1299272907.2071.1415.camel@dan>
Date: Fri, 4 Mar 2011 23:30:55 +0200
X-Google-Sender-Auth: _k966kXGijmEtED3rHPysFNeYaU
Message-ID: <AANLkTina+O77BFV+7mO9fX2aJimpO0ov_MKwxGtMwqG+@mail.gmail.com>
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Pekka Enberg <penberg@kernel.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Matt Mackall <mpm@selenic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
        cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

[ Thanks to you and Matt for taking the time to explain this to me. ]

On Fri, Mar 4, 2011 at 11:08 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> I could be mistaken on this, so feel free to correct me.  What if you
> just fill more than one slab with the object you'd like to overflow
> into, then pick an object that's guaranteed to reside in a slab filled
> with your objects.  Upon freeing that object and allocating a new
> to-be-overflowed object (that's sized so it's handled by the same slab
> cache), this new object will be guaranteed to be sitting immediately
> before one of your objects (or before the end of the slab if you're
> unlucky).  You can still win because it doesn't matter which specific
> object you overflow, only that you overflow one of them.

Right. So you fill a slab with objects A that you want to overflow
(struct shmid_kernel in the example exploit) then free one of them,
allocate object B, smash it (and the next object), and find the
smashed object A.

But doesn't that make the whole /slab/procinfo discussion moot? You
can always use brute force to allocate N objects (where N is larger
than max objects in a slab) and then just free nth object that's most
likely to land on the slab you have full control over (as explained by
Matt).

                        Pekka
