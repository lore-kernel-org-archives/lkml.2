Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2EGB1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 21:27:41 -0400
Received: from tundra.namei.org ([65.99.196.166]:48090 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab2EGB1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 21:27:39 -0400
Date: Mon, 7 May 2012 11:26:29 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, zohar@us.ibm.com,
        David Howells <dhowells@redhat.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/mpi: Fixed erroneous check on return value of
 mpi_resize()
In-Reply-To: <201205051230.GCC69709.OQFLSOVtMHJFFO@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.02.1205071125510.31172@tundra.namei.org>
References: <1336182667-9784-1-git-send-email-root@hackmaster.in> <201205051230.GCC69709.OQFLSOVtMHJFFO@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2012, Tetsuo Handa wrote:

> Adarsh J wrote:
> > mpi_resize() returns -ENOMEM on error and 0 on success.
> 
> Good catch.
> 
> But it seems to me that mpi_fromstr() has no in-tree users.
> Also, mpi_fromstr() in RHEL 5.8/6.2 has no users.
> We forgot to exclude when adding MPI support?

If that's the case, then it should be removed.

(Removed root@ from cc:)

> 
> > 
> > Signed-off-by: Adarsh J <root@hackmaster.in>
> > ---
> >  lib/mpi/mpicoder.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
> > index f26b41f..9949b69 100644
> > --- a/lib/mpi/mpicoder.c
> > +++ b/lib/mpi/mpicoder.c
> > @@ -98,7 +98,7 @@ int mpi_fromstr(MPI val, const char *str)
> >  	nbytes = (nbits + 7) / 8;
> >  	nlimbs = (nbytes + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB;
> >  	if (val->alloced < nlimbs)
> > -		if (!mpi_resize(val, nlimbs))
> > +		if (mpi_resize(val, nlimbs) < 0)
> >  			return -ENOMEM;
> >  	i = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
> >  	i %= BYTES_PER_MPI_LIMB;
> > -- 
> > 1.7.9.5
> 

-- 
James Morris
<jmorris@namei.org>
