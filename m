Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab0KLEtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 23:49:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204Ab0KLEtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 23:49:14 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
References: <20101109124610.GB11477@amd> <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop> <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd> <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Nov 2010 20:48:38 -0800
Message-ID: <AANLkTimn623-N1R_Bn4sF4U6OX55TQZ2w7jGOq+kB5Pz@mail.gmail.com>
Subject: Re: [patch 1/6] fs: icache RCU free inodes
To: Nick Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 5:24 PM, Nick Piggin <npiggin@gmail.com> wrote:
>
> So this is really not a "oh, maybe someone will see 10-20% slowdown", or even
> 1-2% slowdown.

You ignored my bigger issue: the _normal_ way - and the better way -
to handle these thingsis with SLAB_DESTROY_BY_RCU.

So what are the advantages of using the inferior approach?  I really
don't see why you push the whole "free the damn things individually"
approach. We've had experience with that, and it's resulted in long
RCU queues with memory being held up in queuing etc (hopefully we've
improved on the queuing issues with RCU itself, but..)

So the thing is, SLAB_DESTROY_BY_RCU is just the RightThing(tm). Why fight it?

                   Linus
