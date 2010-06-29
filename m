Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0F2SDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:03:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343Ab0F2SDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:03:30 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinr_Ljn48o3YecbuYt15xbP02sbg9D6qqobt1wE@mail.gmail.com>
References: <20100624030212.676457061@suse.de>
	<20100624030725.885831564@suse.de>
	<20100629130214.GA21410@infradead.org>
	<20100629145617.GG28364@laptop>
	<AANLkTinCVQdekiLlU4_tRkkcSGYWV6NG7nlvTirl5xZF@mail.gmail.com>
	<20100629174122.GN28364@laptop>
	<AANLkTinr_Ljn48o3YecbuYt15xbP02sbg9D6qqobt1wE@mail.gmail.com>
Date: Tue, 29 Jun 2010 10:58:14 -0700
Message-ID: <AANLkTilWhDhzdANZeskV__btrvZuAr-Fhmj7j5iKec-U@mail.gmail.com>
Subject: Re: [patch 02/52] fs: fix superblock iteration race
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>, Chris Clayton <chris2553@googlemail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 10:52 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Look for "2.6.35-rc3 oops trying to suspend" on lkml, for example. No
> guarantee that it's the same thing, but it's "iterate_supers()"
> getting an oops [..]

Also, "Oops during closedown with 2.6.35-rc3-git3" is an
iterate_supers oops (in the jpg) and Chris says it's repeatable for
him.

Chris - you could try testing current -git now that I've merged Nick's
patch. It's commit 57439f878af ("fs: fix superblock iteration race"),
and I just pushed it out (so it might take a few minutes to mirror out
to the public git trees, but it should be there shortly).

                         Linus
