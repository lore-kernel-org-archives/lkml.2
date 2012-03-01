Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab2CAOwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:52:04 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:23972 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2CAOwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:52:01 -0500
Date: Thu, 1 Mar 2012 09:51:55 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
        lczerner@redhat.com
Subject: Re: getdents - ext4 vs btrfs performance
Message-ID: <20120301145155.GY5054@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Hillf Danton <dhillf@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	lczerner@redhat.com
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
 <CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
 <20120229144244.GF5054@shiny>
 <CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
 <CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
 <CAJd=RBAs3KGVO8hdUY3peoG1JuxU7_SZ4Z=H0Uy43wLpUFkh7g@mail.gmail.com>
 <CADDYkjR+d+pFYN-mQ91ZP4KcU4zzwC5jmxj1xxMDrp+X+Z8c6g@mail.gmail.com>
 <20120301141823.GV5054@shiny>
 <CADDYkjRs934T2D7DPCk_dcrazptWtLu70=A61R32p22Ee1iXsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADDYkjRs934T2D7DPCk_dcrazptWtLu70=A61R32p22Ee1iXsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F4F8D0F.0178,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 03:43:41PM +0100, Jacek Luczak wrote:
> 2012/3/1 Chris Mason <chris.mason@oracle.com>:
> > XFS will probably beat btrfs in this test.  Their directory indexes
> > reflect on disk layout very well.
> 
> True, but not that fast on small files.
> 
> Except the question I've raised in first mail there's a point in all
> those action. We are maintaining host that are used for building
> software: random access, lot of small files and dirs (always a co),
> heavy parallel IO. We were testing XFS vs ext4 a year ago and XFS was
> around 10% slower on build times. We did not - yet - done same on
> btrfs. Now we're looking for replacement for ext4 as we suffer from
> those issue - but we were not aware of that until stepped into this
> issue.
> 
> If you would like me to do some specific tests around ext4 and btrfs,
> let me know.

I'm always curious to see comparisons in real world workloads.  You
should definitely consider testing XFS again, the big three filesystems
are under pretty constant improvement.  For btrfs, please stick to 3.2
kernels and higher.

This seeky backup performance is somewhat built into ext4, but as Ted
said there are a few workarounds.

-chris

