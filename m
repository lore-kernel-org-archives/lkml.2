Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2HQO4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:56:22 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:36202 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359Ab2HQO4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:56:17 -0400
Date: Fri, 17 Aug 2012 14:56:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: JoonSoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] slub: try to get cpu partial slab even if we get enough
 objects for cpu freelist
In-Reply-To: <CAAmzW4PXf=GK-a8-r_Ep4vR=kx54pr9h5K00iEDx3rVii5ROiA@mail.gmail.com>
Message-ID: <000001393515ab5f-b518fa1e-a5e1-4849-b711-c2ebbdfd65a1-000000@email.amazonses.com>
References: <1345045084-7292-1-git-send-email-js1304@gmail.com> <000001392af5ab4e-41dbbbe4-5808-484b-900a-6f4eba102376-000000@email.amazonses.com> <CAAmzW4M9WMnxVKpR00SqufHadY-=i0Jgf8Ktydrw5YXK8VwJ7A@mail.gmail.com>
 <000001392b579d4f-bb5ccaf5-1a2c-472c-9b76-05ec86297706-000000@email.amazonses.com> <CAAmzW4MMY5TmjMjG50idZNgRUW3qC0kNMnfbGjGXaoxtba8gGQ@mail.gmail.com> <00000139306844c8-bb717c88-ca56-48b3-9b8f-9186053359d3-000000@email.amazonses.com>
 <CAAmzW4P=w6-yrmDmK1SPo3pwgH68Q0+RCe0tpqZPXnk-QEBLMQ@mail.gmail.com> <0000013934e4a8cf-51ac82e4-ad78-46b0-abf7-8dc81be01952-000000@email.amazonses.com> <CAAmzW4PXf=GK-a8-r_Ep4vR=kx54pr9h5K00iEDx3rVii5ROiA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2012, JoonSoo Kim wrote:

> In case of !object (available =  page->objects - page->inuse;),
> "available" means the number of objects in cpu slab.

Right because we do not have allocated any cpu partial slabs yet.

> In this time, we don't have any cpu partial slab, so "available" imply
> the number of objects available to the cpu without locking.
> This is what we want.
>
>
> But, see another "available" (available = put_cpu_partial(s, page, 0);).
>
> This "available" doesn't include the number of objects in cpu slab.

Ok. Now I see.

> Therefore, I think a minor fix is needed for consistency.
> Isn't it reasonable?

Yup it is. Let me look over your patch again.

Ok so use meaningful names for the variables to clarify the issue.

cpu_objects and partial_objects or so?

Then the check would be as you proposed in the last message

if (cpu_objects + partial_objects < s->cpu_partial ...


