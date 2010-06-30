Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0F3MvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 08:51:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46577 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0F3MvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:51:13 -0400
Date: Wed, 30 Jun 2010 13:51:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Chris Clayton <chris2553@googlemail.com>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 02/52] fs: fix superblock iteration race
Message-ID: <20100630125100.GG31073@ZenIV.linux.org.uk>
References: <20100624030212.676457061@suse.de>
 <20100624030725.885831564@suse.de>
 <20100629130214.GA21410@infradead.org>
 <20100629145617.GG28364@laptop>
 <AANLkTinCVQdekiLlU4_tRkkcSGYWV6NG7nlvTirl5xZF@mail.gmail.com>
 <20100629174122.GN28364@laptop>
 <AANLkTinr_Ljn48o3YecbuYt15xbP02sbg9D6qqobt1wE@mail.gmail.com>
 <AANLkTilWhDhzdANZeskV__btrvZuAr-Fhmj7j5iKec-U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilWhDhzdANZeskV__btrvZuAr-Fhmj7j5iKec-U@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 10:58:14AM -0700, Linus Torvalds wrote:
> On Tue, Jun 29, 2010 at 10:52 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Look for "2.6.35-rc3 oops trying to suspend" on lkml, for example. No
> > guarantee that it's the same thing, but it's "iterate_supers()"
> > getting an oops [..]
> 
> Also, "Oops during closedown with 2.6.35-rc3-git3" is an
> iterate_supers oops (in the jpg) and Chris says it's repeatable for
> him.
> 
> Chris - you could try testing current -git now that I've merged Nick's
> patch. It's commit 57439f878af ("fs: fix superblock iteration race"),
> and I just pushed it out (so it might take a few minutes to mirror out
> to the public git trees, but it should be there shortly).

ACK.  I've several cleanups on top of that, but that's not a .35 fodder.
I'll put them into for-next tonight.  But yes, the hole caught by
Nick is definitely real and very likely to be responsible for all that
pile of reports.  Mea culpa.
