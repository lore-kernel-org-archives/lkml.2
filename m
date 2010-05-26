Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0EZP3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:29:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395Ab0EZP3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:29:38 -0400
Date: Wed, 26 May 2010 08:26:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: linux-next: build warning in Linus'tree
In-Reply-To: <20100525234116.71889c71.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005260819560.3689@i5.linux-foundation.org>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au> <20100525182040.f1882d0a.akpm@linux-foundation.org> <20100526140900.5b091c16.sfr@canb.auug.org.au> <OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se>
 <20100525234116.71889c71.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 May 2010, Andrew Morton wrote:
> 
> > I suspect fixing this entails moving all endian tests to #if __BYTE_ORDER ...
> > and then always define both __LITTLE_ENDIAN and __BIG_ENDIAN
> 
> Yes we can't define __LITTLE_ENDIAN to anything on big-endian without
> breaking lots of other things.

Indeed. The whole glibc thing of doing

	# if __BYTE_ORDER == __BIG_ENDIAN

(see "grep ENDIAN /usr/include/*") is a f*cking idiotic. It is way less 
readable, and insane to do. I guess it's some traditional unix disease.

The way to do it in Linux is to just do

	#ifdef __{BIG,LITTLE}_ENDIAN

which is a lot more readable. 

If anybody wants to change that, they still shouldn't change it to the 
idiotic glibc model. If you want it to be more readable, maybe somebody 
can introduce a CONFIG_{BIG,LITTLE}_ENDIAN{_BITFIELDS}

			Linus
