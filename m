Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1L1RVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:21:31 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34635 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab1L1RV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:21:28 -0500
Date: Wed, 28 Dec 2011 17:21:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228172151.3a121d59@pyramind.ukuu.org.uk>
In-Reply-To: <20111228170521.GT27266@moon>
References: <20111222125639.360640574@openvz.org>
	<20111222131139.457264003@openvz.org>
	<20111228165114.04fcae0f@pyramind.ukuu.org.uk>
	<20111228170521.GT27266@moon>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It can happen in case of object re-allocated from slab. But in case
> of two living pids it's impossible to get same pointers for different
> objects. Or I misunderstood the question, Alan? It's up to application
> to not compare objects from dead tasks.

How will it know the task has not died and been reallocated, or its
resources not been freed and reallocated during the comparison ?

Your comparison appears to have a zero time validity - you can ask "is A
the same as B" but by the time you get an answer your answer may no
longer be true. It also externalises a current implementation
detail in a very ugly way.

Would it also not be better to do the job right and simply have an
interface to ask "who shares with A" or even something a bit more high
level, it seems you are creating something nastier by trying to push all
this in userspace than if you did the job or part of it kernel side where
you had access to the right locking infrastructure and where the public
API doesn't need to expose innards of the kernel ?

Alan
