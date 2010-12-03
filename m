Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab0LCFhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 00:37:34 -0500
Received: from relay3.sgi.com ([192.48.152.1]:60070 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709Ab0LCFhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 00:37:33 -0500
Date: Thu, 2 Dec 2010 23:37:27 -0600
From: Robin Holt <holt@sgi.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach v2 (resend)
Message-ID: <20101203053727.GF3344@sgi.com>
References: <20101122122847.3585b447@lilo>
 <20101122130527.c13c99d3.akpm@linux-foundation.org>
 <20101123195523.46e6addb@lilo>
 <4CEB91FA.3040209@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CEB91FA.3040209@inria.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 11:05:46AM +0100, Brice Goglin wrote:
> Le 23/11/2010 10:25, Christopher Yeoh a écrit :
> > On Mon, 22 Nov 2010 13:05:27 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >   
> >> We have a bit of a track record of adding cool-looking syscalls and
> >> then regretting it a few years later.  Few people use them, and maybe
> >> they weren't so cool after all, and we have to maintain them for
> >> ever. Bugs (sometimes security-relevant ones) remain undiscovered for
> >> long periods because few people use (or care about) the code.
> >>
> >> So I think the bar is a high one - higher than it used to be.
> >> Convince us that this feature is so important that it's worth all
> >> that overhead and risk?
> >>     
> > Well there are the benchmark results to show that there is
> > real improvement for MPI implementations (well at least for those
> > benchmarks ;-) There's also been a few papers written on something
> > quite similar (KNEM) which goes into more detail on the potential gains.
> >
> > http://runtime.bordeaux.inria.fr/knem/
> >
> > I've also heard privately that something very similar has been used in
> > at least one device driver to support intranode operations for quite a
> > while
> >   
> 
> Many HPC hardware vendors implemented something like this in their
> custom drivers to avoid going through their network loopback for local
> communication. Even if their loopback is very fast, going to the NIC and
> back to same host isn't really optimal. And I think all of them kept the
> traditional approach (double-copy across a shared-memory buffer) for
> small messages and only switched to this single-copy model for large
> messages (tens or hundreds of kB). CMA and KNEM are "standardizing" all
> this work and making it portable across multiple HPC platform/networks.

SGI used this concept even for single-byte messages both within the same
and across hosts.

Thanks,
Robin
