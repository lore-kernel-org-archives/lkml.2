Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0HaTTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:19:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab0HaTTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:19:53 -0400
Date: Tue, 31 Aug 2010 15:18:46 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100831191846.GA5759@shell>
References: <20100826183340.027591901@szeredi.hu> <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene> <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu> <20100829144207.4fbf2713@notabene> <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu> <20100830214027.77e197f5@notabene> <E1Oq3Lz-0004D8-MP@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Oq3Lz-0004D8-MP@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 02:20:47PM +0200, Miklos Szeredi wrote:
> On Mon, 30 Aug 2010, Neil Brown wrote:
> 
> > Val has been following that approach and asking if it is possible to make an
> > NFS filesystem really-truly read-only. i.e. no changes.
> > I don't believe it is.
> 
> Perhaps it doesn't matter.  The nasty cases can be prevented by just
> disallowing local modification.  For the rest NFS will return ESTALE:
> "though luck, why didn't you follow the rules?"

I agree: Ask the server to keep it read-only, but also detect if it
lied to prevent kernel bugs on the client.

Is detecting ESTALE and failing the mount sufficient to detect all
cases of a cached directory being altered?  I keep trying to trap an
NFS developer and beat the answer out of him but they usually get hung
up on the impossibility of 100% enforcement of the read-only server
option. (Agreed, impossible, just give the sysadmin a mount option so
that it doesn't happen accidentally.)

-VAL
