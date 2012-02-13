Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2BMOl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:41:29 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21546 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab2BMOl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:41:27 -0500
Date: Mon, 13 Feb 2012 09:41:07 -0500
From: Chris Mason <chris.mason@oracle.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-fsdevel@vger.kernel.org
Subject: Re: Kernel bug with btrfs on laptop with external hd and suspend and
 resume.
Message-ID: <20120213144107.GC1573@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	"Nathan A. Mourey II" <nmoureyii@ne.rr.com>,
	linux-kernel@vger.kernel.org,
	Linux PM mailing list <linux-pm@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-fsdevel@vger.kernel.org
References: <1328990690.2464.6.camel@firefly>
 <4F391B83.7080703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F391B83.7080703@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F392110.00E7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 07:47:39PM +0530, Srivatsa S. Bhat wrote:
> Adding some Cc's.
> 
> On 02/12/2012 01:34 AM, Nathan A. Mourey II wrote:
> 
> > I just installed the new kernel with yum update.  I have an external eSATA hard drive that is 
> > formatted with btrfs.  I closed the lid once it had booted up, I had not logged in yet.  Latter I opened
> > the lid and had the following message on the screen.  Hope it helps.
> > 
> > 
> > Feb 11 14:39:03 firefly kernel: [  253.236050] ------------[ cut here ]------------
> > Feb 11 14:39:03 firefly kernel: [  253.236066] kernel BUG at fs/btrfs/transaction.c:1337!

This crash corresponds to:

        ret = btrfs_write_and_wait_transaction(trans, root);
        BUG_ON(ret);

Which basically means we were not able to write all the metadata for the
transaction (EIO during writeback).  Do other messages from the kernel
tell you if the crash happened before or after the suspend?

What happened when the machine rebooted?

Since the drive is external, I'm going to guess this is related to the
device going away at the wrong time.  Was it plugged in the whole time?

-chris
