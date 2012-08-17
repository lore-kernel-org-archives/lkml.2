Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2HQOCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:02:55 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:42305 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755871Ab2HQOCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:02:47 -0400
Date: Fri, 17 Aug 2012 14:02:45 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: JoonSoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] slub: try to get cpu partial slab even if we get enough
 objects for cpu freelist
In-Reply-To: <CAAmzW4P=w6-yrmDmK1SPo3pwgH68Q0+RCe0tpqZPXnk-QEBLMQ@mail.gmail.com>
Message-ID: <0000013934e4a8cf-51ac82e4-ad78-46b0-abf7-8dc81be01952-000000@email.amazonses.com>
References: <1345045084-7292-1-git-send-email-js1304@gmail.com> <000001392af5ab4e-41dbbbe4-5808-484b-900a-6f4eba102376-000000@email.amazonses.com> <CAAmzW4M9WMnxVKpR00SqufHadY-=i0Jgf8Ktydrw5YXK8VwJ7A@mail.gmail.com>
 <000001392b579d4f-bb5ccaf5-1a2c-472c-9b76-05ec86297706-000000@email.amazonses.com> <CAAmzW4MMY5TmjMjG50idZNgRUW3qC0kNMnfbGjGXaoxtba8gGQ@mail.gmail.com> <00000139306844c8-bb717c88-ca56-48b3-9b8f-9186053359d3-000000@email.amazonses.com>
 <CAAmzW4P=w6-yrmDmK1SPo3pwgH68Q0+RCe0tpqZPXnk-QEBLMQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2012, JoonSoo Kim wrote:

> > What difference does this patch make? At the end of the day you need the
> > total number of objects available in the partial slabs and the cpu slab
> > for comparison.
>
> It doesn't induce any large difference, but this makes code robust and
> consistent.
> Consistent code make us easily knowing what code does.

Consistency depends on the way you think about the code.

> It is somewhat odd that in first loop, we consider number of objects
> kept in cpu slab,
> but second loop exclude that number and just consider number of
> objects in cpu partial slab.

In the loop we consider the number of objects available to the cpu
without locking.

First we populate the per_cpu slab and if that does not give us enough per
cpu objects then we use the per cpu partial list to increase that number
to the desired count given by s->cpu_partial.

"available" is the number of objects available for a particular cpu
without having to go to the partial slab lists (which means having to acquire a
per node lock).

