Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1K2MzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:55:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab1K2MzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:55:00 -0500
Date: Tue, 29 Nov 2011 07:54:28 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Jan Kara <jack@suse.cz>
cc: Valerie Aurora <val@vaaconsulting.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        esandeen@redhat.com, Surbhi Palande <csurbhi@gmail.com>
Subject: Re: [PATCH] deadlock with suspend and quotas
In-Reply-To: <20111129111136.GC5635@quack.suse.cz>
Message-ID: <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz> <20111129102156.GA7463@quack.suse.cz>
 <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
 <20111129111136.GC5635@quack.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is technically impossible to achieve on ext2, fat or other 
> > non-transactional filesystems. These filesystems have no locks around code 
> > paths that set data or inodes dirty. And you still need working sync for 
> > ext2. So the best thing to do in sync is to wait until the filesystem is 
> > unfrozen.
>   Then suspend is effectively unsupported on the filesystem and should
> return EOPNOTSUPP? At least that's what I'd expect...
> 
> 									Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

LVM uses suspend every time it changes layout of the logical volume. For 
example when it converts to/from mirrored format, extends/shrinks the 
volume, moves the volume to a different disk, takes a snapshots, merges a 
snapshot back, on mirror or multipath failover.

For most of these actions (except taking a snapshot) it is irrelevant if 
there are dirty data in the filesystem cache or not while it is suspended. 
So there is no point in banning suspend on ext2. If you banned it, you 
couldn't use ext2 on LVM at all.

Mikulas
