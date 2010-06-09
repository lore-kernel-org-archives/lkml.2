Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0FIFzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 01:55:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0FIFzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 01:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=uFtD5wpZngclNHiSc12ZP/YcLocROX0CPsyYO7GJmjv6JovHWuzC9JEBXPIS5KGGtU
         RueZMhi0c1rFDwfPHxR0URaS/WA+0CjYtbzuujqLKKbiW7+lsLI91FsI/RYRNGhF91oe
         e95MA4EwEmtcy28tZTRwLjtnEXL0t29m3Ixeo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1006081633450.19582@chino.kir.corp.google.com>
References: <20100521211452.659982351@quilx.com>
	<20100521211537.530913777@quilx.com>
	<alpine.DEB.2.00.1006071443120.10905@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1006071729560.12482@router.home>
	<AANLkTikOKy6ZQQh2zORJDvGDE0golvyzsvlvDj-P5cur@mail.gmail.com>
	<alpine.DEB.2.00.1006072319330.31780@chino.kir.corp.google.com>
	<AANLkTikQhjlCPnwiK7AZo27Xb3h-Lj2JyCeqFQaVzpHX@mail.gmail.com>
	<alpine.DEB.2.00.1006081633450.19582@chino.kir.corp.google.com>
Date: Wed, 9 Jun 2010 08:55:18 +0300
X-Google-Sender-Auth: 8h82HPvbMqcZ4HfTAB5H2uzqD18
Message-ID: <AANLkTimFmupRJ-np-V9TeiUNAqXmnyui3uYMs3PD1bWB@mail.gmail.com>
Subject: Re: [RFC V2 SLEB 01/14] slab: Introduce a constant for a unspecified 
	node.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

(I'm LKML and Ingo to CC.)

On Tue, 8 Jun 2010, Pekka Enberg wrote:
>> > An incremental patch in this case would change everything that the
>> > original patch did, so it'd probably be best to simply revert and queue
>> > the updated version.
>>
>> If I revert it, we end up with two commits instead of one. And I
>> really prefer not to *rebase* a topic branch even though it might be
>> doable for a small tree like slab.git.

On Wed, Jun 9, 2010 at 2:35 AM, David Rientjes <rientjes@google.com> wrote:
> I commented on improvements for three of the five patches you've added as
> slub cleanups and Christoph has shown an interest in proposing them again
> (perhaps seperating patches 1-5 out as a seperate set of cleanups?), so
> it's probably cleaner to just reset and reapply with the revisions.

As I said, we can probably get away with that in slab.git because
we're so small but that doesn't work in general.

If we ignore the fact how painful the actual rebase operation is
(there's a 'sleb/core' branch that shares the commits), I don't think
the revised history is 'cleaner' by any means. The current patches are
known to be good (I've tested them) but if I just replace them, all
the testing effort was basically wasted. So if I need to do a
git-bisect, for example, I didn't benefit one bit from testing the
original patches.

The other issue is patch metadata. If I just nuke the existing
patches, I'm also could be dropping important stuff like Tested-by or
Reported-by tags. Yes, I realize that in this particular case, there's
none but the approach works only as long as you remember exactly what
you merged.

There are probably other benefits for larger trees but those two are
enough for me to keep my published branches append-only.

On Wed, Jun 9, 2010 at 2:35 AM, David Rientjes <rientjes@google.com> wrote:
> Let me know if my suggested changes should be add-on patches to
> Christoph's first five and I'll come up with a three patch series to do
> just that.

Yes, I really would prefer incremental patches on top of the
'slub/cleanups' branch.

                        Pekka
