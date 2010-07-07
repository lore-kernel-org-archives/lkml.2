Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0GGN12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:27:28 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:47277 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab0GGN1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:27:25 -0400
Date: Wed, 7 Jul 2010 15:29:15 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] padata: updates
Message-ID: <20100707132915.GV10072@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jul 2010 13:27:13.0276 (UTC) FILETIME=[1C28ABC0:01CB1DD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the following changes:

1. Add a flag to mark the padata instance as invalid.
We will use this to mark the padata instace as invalid
if the padata cpumask contains no active cpu.

2. Make padata_stop to block until the padata instance is
unused. So it's save to change the cpumask after a call to
padata_stop.

3. Add a possibility to handle empty padata cpumasks.
The first three patches address a bug, found by Dan Kruchinin.
When the padata cpumask does not intersect with the active
cpumask we get a division by zero in padata_alloc_pd and we
end up with a useless padata instance. It's not possible to
trigger this bug by now, but Dan has patches that let the
cpumask change from userspace. So this bug has to be fixed
before these patches can go in.

4. Make padata_do_parallel to return zero on success.
To return -EINPROGRESS on success was considered to be odd,
so we change the API to return zero instead. Users are updated
accordingly.

5. Simplify the serialization mechanism.
As it is, we go through all the percpu reorder queues to calculate
the sequence number of the next object that needs serialization. 
This patch avoids this and minimalizes the accesses of foreign
memory. This gives some performance inprovements, in particular
on machines with many cpus.

6. Update the padata documentation.

Steffen

