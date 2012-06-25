Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab2FYPSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:18:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2FYPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:18:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cong Wang <amwang@redhat.com>
Subject: Re: [PATCH 00/12] kmap_atomic cleanup for 3.6
Date: Mon, 25 Jun 2012 15:18:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com> <201206232111.25411.arnd@arndb.de> <1340598382.19173.3.camel@cr0>
In-Reply-To: <1340598382.19173.3.camel@cr0>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206251518.08791.arnd@arndb.de>
X-Provags-ID: V02:K0:D3LxzVVW1B/9SmY7xdDBv7U0pTcRXAcNl8E4vSXyVfp
 ll4MIIen2gLPUDXoz4NellF7W0xs9FRXnF3MQ5KMl23YOOvPk8
 SBNuQUZdV+5kj6+ntaqDZsPZd/EWeI4R+uNJDn4yoSk44sJ5hS
 T4iH5h9BzSQyzrn/nOhXIuHCD76qz4Iu5kWwsgKAs5fFFh1R4e
 rQ5ZOeWbjZM0+Nz6jqC8kUvbi4hvaQhQb+5YRW+ydn3MeDrCms
 9vq7IT7Fy2jXuwOsIY8MseviVSyG9uFp/++1E6humijZ81D5rq
 4glEqg7bsr+4xZn/Y6ugYVoE1ZKCJcEaIjxQ+ct+PnAvWDZ4e6
 +wOrhZmCxnOEQFhX4aog=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2012, Cong Wang wrote:
> On Sat, 2012-06-23 at 21:11 +0000, Arnd Bergmann wrote:
> > On Saturday 23 June 2012, Cong Wang wrote:
> > > After few releases, it seems there are no more callers
> > > using the deprecated form of kmap_atomic(), the one
> > > with two parameters. So we can remove it now and remove
> > > the KM_* definition except KM_TYPE_NR together.
> > > 
> > > All the patches are available at:
> > > 
> > >         git://github.com/congwang/linux.git #kmap_atomic
> > > 
> > 
> > What is the significance of having an architecture-specific
> > definition for KM_TYPE_NR now? Should that be replaced
> > with a fixed value in include/linux/highmem.h so we can
> > remove the asm/kmap_types.h files entirely?
> > 
> 
> Different arch has different values for KM_TYPE_NR, I am not sure if
> unifying them to a fixed value could fit all? 

Well, that's something you could find out in the review.

> For safety, I kept their original values.

My fear is that it will make it harder to clean that code up for
real, when there is no longer an indication about where the number
comes from.

The only architecture that actually seems to have a restriction
here is tile, which defines it to 8.

I would suggest putting that value into include/linux/highmem.h,
it seems more than sufficient.  I would structure the series to
have your patches 1 and 9 through 12 first, then remove
all explicit #include <asm/kmap_types.h> statements (you have
proven that they are not required already) and finally add the
define in linux/highmem.h and remove the arch specific headers.

	Arnd
