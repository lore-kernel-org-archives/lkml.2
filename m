Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0JAJfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:35:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:43503 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0JAJfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:35:31 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
Date: Fri, 1 Oct 2010 11:34:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Miklos Szeredi <miklos@szeredi.hu>, linuxram@us.ibm.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, viro@zeniv.linux.org.uk
References: <20100920180404.939991832@szeredi.hu> <201009281025.00727.agruen@suse.de> <20100930215114.GD490@shell>
In-Reply-To: <20100930215114.GD490@shell>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010011134.57594.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 September 2010 23:51:15 Valerie Aurora wrote:
> On Tue, Sep 28, 2010 at 10:24:59AM +0200, Andreas Gruenbacher wrote:
> > On Monday 27 September 2010 20:47:47 Valerie Aurora wrote:
> > > Again, maybe I'm misunderstanding, but this doesn't make much sense to
> > > me.  Say I create:
> > > 
> > > /upper/a_dir/upper_file
> > > /lower/a_dir/lower_file
> > > 
> > > Then when I union mount them, I want a_dir/ to be transparent
> > > automatically and show both upper_file and lower_file, without marking
> > > it manually.
> > 
> > Why?
> 
> Hm, this was a pretty basic assumption for me - that you'd want to
> construct a topmost image offline that would be "merged" with the
> lower layers.  So, for example:
> 
> Topmost layer contains:
> 
> /etc/hostname
> 
> Lower layers contain everything else in /etc/.  So /etc/ would exist
> on the topmost layer at the time of union mount, but we would want it
> to be transparent.  But if we created a new dir *during* the union
> mount, it would be opaque.
> 
> What was your model?

The prevalent use case probably is to start out with an empty topmost layer on 
top of an existing file system.  When things are modified, changes obviously 
go into the topmost layer.  Additional layers can later be stacked on top of 
that, turning the previous topmost layer into a read-only lower layer.

Overlaying preexisting file systems doesn't seem that important; users 
commonly should be able to start out with an empty topmost layer instead.  To 
also cover the less common cases, there should be a way to convert directories 
in a union from opaque to transparent and back though, just like there should 
be a way to get rid of a whiteout.

Makes sense?

Thanks,
Andreas
