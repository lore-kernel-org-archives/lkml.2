Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab2EOPAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:00:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab2EOPAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:00:19 -0400
Date: Tue, 15 May 2012 18:00:05 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515150005.GG6948@redhat.com>
References: <20120515111255.GJ32036@redhat.com>
 <4FB23C09.7060300@suse.de>
 <20120515115917.GK32036@redhat.com>
 <20120515144945.339e742f@pyramind.ukuu.org.uk>
 <20120515141214.GB6948@redhat.com>
 <20120515151849.54a12175@pyramind.ukuu.org.uk>
 <20120515142129.GC6948@redhat.com>
 <20120515153614.4b5b4525@pyramind.ukuu.org.uk>
 <20120515144810.GE6948@redhat.com>
 <20120515155450.13040d1f@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515155450.13040d1f@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 03:54:50PM +0100, Alan Cox wrote:
> > > Sample case of .. 1
> > > 
> > Not one. Any system with SCSI disk. Revert the patch and check on yours.
> 
> I don't have a SCSI disk. In fact most users don't have a SCSI disk 8)
> 
Most of them have SATA which is not even defined by Phoenix spec 8)

> > > Actual systems in the field are using both 3.0 and 4.0 so we need to deal
> > > with that as part of fixing this. That is the reality of the situation.
> > Again let me correct myself. This is not about 3.0 versus 4.0. This is
> > about Phoenix vs T13 spec. The code was written to support only T13.
> 
> Well actually the code was written to mishandle both in different ways.
This is simply not true. The code defines device path structure
according to T13 spec and clearly states in the header which spec it was
written to support. May be this is not clear from the thread but the code
still provides every other information except device path from Phoenix
EDD. You can still see pci device from /sys/firmware/edd/int13_80.

> You propose to change it to handle one correctly and completely fail on
> the other. That isn't what needs to happen.
> 
Not completely fail, only suppress information the code does not know
how to parse!

--
			Gleb.
