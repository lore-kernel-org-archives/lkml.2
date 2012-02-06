Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab2BFRtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:49:45 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56324
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844Ab2BFRto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:49:44 -0500
Date: Mon, 6 Feb 2012 12:49:43 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] hfsplus: Add an ioctl to bless files
Message-ID: <20120206174943.GA14225@infradead.org>
References: <1328215191-4201-1-git-send-email-mjg@redhat.com>
 <1328215191-4201-2-git-send-email-mjg@redhat.com>
 <20120206173553.GB1135@infradead.org>
 <20120206174549.GA1655@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206174549.GA1655@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 05:45:49PM +0000, Matthew Garrett wrote:
> On Mon, Feb 06, 2012 at 12:35:53PM -0500, Christoph Hellwig wrote:
> > +#define HFSPLUS_IOC_BLESS              _IO('f', 0x20)
> > 
> > I'd probably move this to fs.h and follow the numbering there,
> > otherwise we are bound to run into conflicts.
> 
> Ok. Any problem with leaving something filesystem specific in there?

Leaving it in hfsplus sounds fine, but I'd avoid using 'f' then just to
reduce the chance for overlap.

> >From the spec:
> 
> "finderInfo[0] contains the directory ID of the directory containing the 
> bootable system (for example, the System Folder in Mac OS 8 or 9, or 
> /System/Library/CoreServices in Mac OS X). It is zero if there is no 
> bootable system on the volume. This value is typically equal to either 
> finderInfo[3] or finderInfo[5]."
> 
> finderInfo[3] is the OS8/9 system folder, finderInfo[5] is the OS X one. 
> I'd guess it's just to indicate whether the boot media should default to 
> OS8/9 or OS X, but it's not entirely clear.

Care to add this explanation as a comment?

