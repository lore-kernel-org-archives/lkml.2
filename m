Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0EZGmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:42:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574Ab0EZGmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:42:02 -0400
Date: Tue, 25 May 2010 23:41:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning in Linus'tree
Message-Id: <20100525234116.71889c71.akpm@linux-foundation.org>
In-Reply-To: <OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au>
	<20100525182040.f1882d0a.akpm@linux-foundation.org>
	<20100526140900.5b091c16.sfr@canb.auug.org.au>
	<OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 08:29:45 +0200 Joakim Tjernlund <joakim.tjernlund@transmode.se> wrote:

> Stephen Rothwell <sfr@canb.auug.org.au> wrote on 2010/05/26 06:09:00:
> >
> > Hi Andrew,
> >
> > On Tue, 25 May 2010 18:20:40 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > hmpf.  Does this fix?
> >
> > No.
> >
> > The problem is that __LITTLE_ENDIAN is only defined in
> > linux/byteorder/little_endian.h which is only included by little endian
> > architectures ...
> 
> Ah, not sure how to fix this ATM. Perhaps best to revert
>    crc32: use __BYTE_ORDER macro for endian detection
> for now.

yup.

> I suspect fixing this entails moving all endian tests to #if __BYTE_ORDER ...
> and then always define both __LITTLE_ENDIAN and __BIG_ENDIAN

Yes we can't define __LITTLE_ENDIAN to anything on big-endian without
breaking lots of other things.

