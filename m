Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1K3NFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:05:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab1K3NFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:05:48 -0500
Date: Wed, 30 Nov 2011 13:05:14 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Jan Kara <jack@suse.cz>,
        Alasdair G Kergon <agk@redhat.com>, esandeen@redhat.com,
        Surbhi Palande <csurbhi@gmail.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Message-ID: <20111130130514.GU7595@agk-dp.fab.redhat.com>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Jan Kara <jack@suse.cz>, Alasdair G Kergon <agk@redhat.com>,
	esandeen@redhat.com, Surbhi Palande <csurbhi@gmail.com>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	Valerie Aurora <val@vaaconsulting.com>
References: <20111129102156.GA7463@quack.suse.cz> <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com> <20111129111136.GC5635@quack.suse.cz> <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com> <20111129130913.GE5635@quack.suse.cz> <20111129131811.GS7595@agk-dp.fab.redhat.com> <20111129133239.GA9926@quack.suse.cz> <Pine.LNX.4.64.1111300143340.31264@hs20-bc2-1.build.redhat.com> <20111130111657.GA4541@quack.suse.cz> <Pine.LNX.4.64.1111300700190.27712@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111300700190.27712@hs20-bc2-1.build.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 07:14:18AM -0500, Mikulas Patocka wrote:
> On Wed, 30 Nov 2011, Jan Kara wrote:
> > > So if you skip sync of frozen filesystems, you introduce a data
> > > corruption if someone takes a snapshot of ext2.
> >   Yes, because ext2 cannot really be frozen, it is (errorneously) marked
> > as such but it is not frozen...

This is just getting into semantics.  AFAIK (and it was before my involvement)
LVM used the term 'lockfs' for this operation when it was introduced to ext2.
It later got renamed in-kernel to 'frozen' to bring it into line with newer
filesystems.  But userspace and the interface still retain the original
'lockfs' name.

There is no further I/O sent to the filesystem during the 'lockfs' operation:
LVM uses dm to block that.

Alasdair

