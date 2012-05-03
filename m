Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab2ECGnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:43:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47384 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2ECGnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:43:45 -0400
Message-ID: <4FA22915.6050400@zytor.com>
Date: Wed, 02 May 2012 23:43:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Jim Kukunas <james.t.kukunas@linux.intel.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86: use kernel_fpu_[begin|end] for RAID5 checksumming
References: <1335829875-18481-1-git-send-email-james.t.kukunas@linux.intel.com> <20120503145744.4e425dd5@notabene.brown>
In-Reply-To: <20120503145744.4e425dd5@notabene.brown>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/02/2012 09:57 PM, NeilBrown wrote:
> On Mon, 30 Apr 2012 16:51:15 -0700 Jim Kukunas 
> <james.t.kukunas@linux.intel.com> wrote:
> 
>> Currently, the SSE and AVX xor functions manually save and 
>> restore the [X|Y]MM registers. Instead, we should use 
>> kernel_fpu_[begin|end].
>> 
>> This patch sacrifices some throughput,~5-10% for AVX and ~2% for 
>> SSE, in exchange for safety against future FPU corruption bugs.
>> 
>> Patch applies to md/for-next.
>> 
>> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
> 
> Hi Jim, I'm really not able to assess the validity of this patch.
> I don't doubt it exactly, but I'd value a second opinion just to
> be confident. Peter: can you review and comment?
> 
> Thanks, NeilBrown
> 

Are these functions ever called with unaligned arguments?

Other than that, the patch is correct, and is the preferred way to do
this, but I'm unhappy about the cost.  I have suggested to Jim a few
ways by which we might be able to mitigate the cost or even improve
performance, but the implementation depends very much on the above
question (unlike the RAID-6 code, which assumes aligned buffers at all
times.)

	-hpa
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPoikHAAoJEL2gYIVJO6zk9Q8P/AqcdBC2fal6Wy9RSWnky4vf
BLycwd7JAK6CU6Tl/dK747gpEdzXwFOPPrGV3pbyycft8rKPvUoliBhE9esM8GN6
5wZfn9dBBXa3Gmacxdu5mj87W54LpQOCc8rGj3CSx8kfoORjBCxC0zueX3Wmno/I
KdL6JtWiSEgJ93WLRr4mYfo1V8rulJ5kAxTthntyAmuIiJi4nc4ERyMLRXEH+3p2
iam8f4v4JDhm2qVxnkSX2toPjzEVLPXSa5DDhHJq8OC9o8jl6gL8nIByG7/0hYMG
Z3mI4pG4GB7jdX8YxSI8sGo0rB1bXtnLEI61FAZo4vOJRs1xJr98m3nwiE4X81NV
OU+xucUPpd+Y5x6oC7tZyDkoKqnkNH1nNHhhyKawe4pMWWom9m8V5skkYrXufr8G
K1unlM0zfUUAH2vFbEuRqbGIMfhH2qFCWp/oywRK0M+R/HjLISVjjIIYCB87Y30K
dZ+y8z6bEYRm0WyFSw/SkEulSyAu/VfHcOAmYorvu721MG2HfPkdWiviwgbf6CD2
33bZ3IUkaian619eQC+wBliGIjvR6PexxTzilIbfV4D20t9QhvBVSkkbT9cIaFeF
38gC8LxDBvrSYyutn4v6e6NUAUQlbtQnPZJQfb8uDbtOe74Er8qsZJGsCyt1bgv1
EjeLFnHOn4F9pE/g7GNh
=wGxV
-----END PGP SIGNATURE-----
