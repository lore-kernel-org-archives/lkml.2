Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2DWP2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:28:03 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44479 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2DWP2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:28:01 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Jeff Layton <jlayton@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Malahal Naineni <malahal@us.ibm.com>,
        Steve Dickson <SteveD@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hch@infradead.org,
        michael.brantley@deshaw.com, sven.breuner@itwm.fraunhofer.de,
        chuck.lever@oracle.com, pstaubach@exagrid.com,
        trond.myklebust@fys.uio.no, rees@umich.edu
Subject: Re: [PATCH RFC v3] vfs: make fstatat retry once on ESTALE errors from getattr call
References: <20120420104055.511e15bc@tlielax.poochiereds.net>
	<4F91C49D.8070908@RedHat.com> <20120420203725.GA3512@us.ibm.com>
	<20120420171314.73801874@corrin.poochiereds.net>
	<CAJfpegt40cgMJQQo3JuNaaS1w957Y2a_NxVoyvx3bmTMj1TGOA@mail.gmail.com>
	<20120423080012.7c23ef24@tlielax.poochiereds.net>
	<20120423130009.GA13681@fieldses.org>
	<20120423091255.00f926c4@tlielax.poochiereds.net>
	<20120423133412.GB13681@fieldses.org>
	<20120423095021.1a91a23b@tlielax.poochiereds.net>
	<20120423135456.GC13681@fieldses.org>
	<87hawasdrb.fsf@tucsk.pomaz.szeredi.hu>
	<20120423111610.0259d610@tlielax.poochiereds.net>
Date: Mon, 23 Apr 2012 17:28:19 +0200
In-Reply-To: <20120423111610.0259d610@tlielax.poochiereds.net> (Jeff Layton's
	message of "Mon, 23 Apr 2012 11:16:10 -0400")
Message-ID: <87zka2qxgs.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

>
> Ok, but again, that only applies to the lookup. It has no bearing on
> the subsequent operation. For instance, if we're doing:
>
>      rename("/foo", "/bar");
>
> ...and another client is simultaneously doing:
>
>      creat("/bar/baz", 0600);
>
> ...and we get back ESTALE from the server on the create because the
> "old" /bar got replaced after the lookup of it. Then it seems like
> returning -ENOENT would not be correct since there was never a time
> where /bar didn't exist...

It may not be "correct" according to some standard.  But it's what Linux
does since day one on *all* filesystems.  And probably other OS's that
have remotely scalable lookup routines.

Thanks,
Miklos
