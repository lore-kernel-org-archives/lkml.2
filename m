Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab1EaI4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:56:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232Ab1EaI4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:56:52 -0400
Subject: Re: Cleancache and shared filesystems
From: Steven Whitehouse <swhiteho@redhat.com>
To: Joel Becker <jlbec@evilplan.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
        sunil.mushran@oracle.com
In-Reply-To: <20110527233331.GC30232@noexit.corp.google.com>
References: <1306504300.2857.14.camel@menhir>
	 <6f0e746a-d3d1-4708-9e16-3d02ddeab824@default>
	 <1306513179.2857.38.camel@menhir>
	 <20110527233331.GC30232@noexit.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 31 May 2011 09:58:26 +0100
Message-ID: <1306832306.2816.3.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2011-05-27 at 16:33 -0700, Joel Becker wrote:
> On Fri, May 27, 2011 at 05:19:39PM +0100, Steven Whitehouse wrote:
> > +	if (ls->ls_ops == &gfs2_dlm_ops) {
> > +		if (gfs2_uuid_valid(sb->s_uuid))
> > +			cleancache_init_shared_fs(sb->s_uuid, sb);
> > +	} else {
> > +		cleancache_init_fs(sb);
> > +	}
> 
> Hey Dan,
> 	Steven makes a good point here.  ocfs2 could also take advantage
> of local filesystem behavior when running in local mode.
> 
> Joel
> 

There is a further issue as well - cleancache will only work when all
nodes can see the same shared cache, so we will need a mount option to
disable cleancache in the case we have (for example) a cluster of
virtual machines split over multiple physical hosts.

In fact, I think from the principle of least surprise this had better
default to off and be enabled explicitly. Otherwise I can see that
people will shoot themselves in the foot which will be very easy since
there is no automatic way that I can see to verify that all nodes are
looking at the same cache,

Steve.


