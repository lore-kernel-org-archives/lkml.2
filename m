Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab1EaVyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:54:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34886 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab1EaVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:54:50 -0400
Date: Tue, 31 May 2011 14:54:43 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: Cleancache and shared filesystems
Message-ID: <20110531215443.GC31742@noexit.corp.google.com>
Mail-Followup-To: Dan Magenheimer <dan.magenheimer@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	linux-kernel@vger.kernel.org,
	Sunil Mushran <sunil.mushran@oracle.com>
References: <1306504300.2857.14.camel@menhir>
 <6f0e746a-d3d1-4708-9e16-3d02ddeab824@default>
 <1306513179.2857.38.camel@menhir20110527233331.GC30232@noexit.corp.google.com>
 <790b3e0b-14b6-44da-9f4c-a4315b58e2c5@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <790b3e0b-14b6-44da-9f4c-a4315b58e2c5@default>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 07:51:36AM -0700, Dan Magenheimer wrote:
> > Hey Dan,
> > 	Steven makes a good point here.  ocfs2 could also take advantage
> > of local filesystem behavior when running in local mode.
> 
> I guess the semantics need to be more clearly defined
> (or perhaps changed if the shared-fs community wants),
> but if cleancache_init_shared_fs is called only by
> a single node, cleancache still enables all the same
> functionality** as cleancache_init_fs. 

	I don't see the ** reference in the footnotes ;-)  You're saying
that, for a single caller, you will properly keep the pagecache bits
around in cleancache as you shrink the balloon and give them back when
requested?  So an ocfs2 calling cleancache_init_share_fs() in only one
VM will have the same page lifetimes (including life inside cleancache
but not in guest pagecache) as a similar ext3?  If so, there are no
changes needed at all.

> I'm not sure I fully understand the semantics of
> local mode though, so please clarify if you think
> I am wrong or misunderstanding your point.

	ocfs2 local mode means that it is not a cluster filesystem.  The
cluster services are not enabled, and ocfs2 behaves like xfs/extN/btrfs.

Joel

-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

			http://www.jlbec.org/
			jlbec@evilplan.org
