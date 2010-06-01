Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0FAO21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:28:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:57334 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab0FAO2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:28:25 -0400
Date: Wed, 2 Jun 2010 00:28:22 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Chris Mason <chris.mason@oracle.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
Message-ID: <20100601142822.GW9453@laptop>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <1275318102.2823.47.camel@mulgrave.site>
 <4C03D5FD.3000202@panasas.com>
 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
 <1275398876.21962.6.camel@mulgrave.site>
 <20100601133341.GK8980@think>
 <1275399637.21962.11.camel@mulgrave.site>
 <yq1hblmkgka.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1hblmkgka.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 09:50:29AM -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:
> 
> James> Would it be too much work in the fs to mark the page dirty before
> James> you begin altering it (and again after you finish, just in case
> James> some cleaner noticed and initiated a write)?  Or some other flag
> James> that indicates page under modification?  All the process
> James> controlling the writeout (which is pretty high up in the stack)
> James> needs to know is if we triggered the check error by altering the
> James> page while it was in flight.
> 
> James> I agree that a block based retry would close all the holes ... it
> James> just doesn't look elegant to me that the fs will already be
> James> repeating the I/O if it changed the page and so will block.
> 
> I experimented with this approach a while back.  However, I quickly got
> into a situation where frequently updated blocks never made it to disk
> because the page was constantly being updated.  And all writes failed
> with a guard tag error.

What if you bounce in the case of a first guard error?

