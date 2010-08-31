Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0HaUU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:20:28 -0400
Received: from mx2.netapp.com ([216.240.18.37]:8655 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab0HaUU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:20:27 -0400
X-IronPort-AV: E=Sophos;i="4.56,300,1280732400"; 
   d="scan'208";a="440129510"
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
In-Reply-To: <20100831191846.GA5759@shell>
References: <20100826183340.027591901@szeredi.hu>
	 <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	 <20100827213502.31af4a4c@notabene> <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
	 <20100829144207.4fbf2713@notabene> <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
	 <20100830214027.77e197f5@notabene> <E1Oq3Lz-0004D8-MP@pomaz-ex.szeredi.hu>
	 <20100831191846.GA5759@shell>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Tue, 31 Aug 2010 16:19:47 -0400
Message-ID: <1283285987.7914.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 31 Aug 2010 20:20:11.0788 (UTC) FILETIME=[EA05CCC0:01CB4949]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 15:18 -0400, Valerie Aurora wrote:
> On Mon, Aug 30, 2010 at 02:20:47PM +0200, Miklos Szeredi wrote:
> > On Mon, 30 Aug 2010, Neil Brown wrote:
> > 
> > > Val has been following that approach and asking if it is possible to make an
> > > NFS filesystem really-truly read-only. i.e. no changes.
> > > I don't believe it is.
> > 
> > Perhaps it doesn't matter.  The nasty cases can be prevented by just
> > disallowing local modification.  For the rest NFS will return ESTALE:
> > "though luck, why didn't you follow the rules?"
> 
> I agree: Ask the server to keep it read-only, but also detect if it
> lied to prevent kernel bugs on the client.
> 
> Is detecting ESTALE and failing the mount sufficient to detect all
> cases of a cached directory being altered?

No. Files can be altered without being unlinked.

>   I keep trying to trap an
> NFS developer and beat the answer out of him but they usually get hung
> up on the impossibility of 100% enforcement of the read-only server
> option. (Agreed, impossible, just give the sysadmin a mount option so
> that it doesn't happen accidentally.)

Remind me again why mounting the filesystem '-oro' on the server (and
possibly exporting it 'ro') isn't an option?

Trond
