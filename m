Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0FNOM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:12:59 -0400
Received: from thunk.org ([69.25.196.29]:50165 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0FNOM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:12:58 -0400
Date: Mon, 14 Jun 2010 10:12:56 -0400
From: tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Only honor the FIGETBSZ ioctl for regular files,
 directories, and symlinks
Message-ID: <20100614141256.GB22163@thunk.org>
Mail-Followup-To: tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
References: <20100614134252.GA22163@thunk.org>
 <1276524310-25812-1-git-send-email-tytso@mit.edu>
 <20100614140730.GA30779@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614140730.GA30779@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 10:07:30AM -0400, Christoph Hellwig wrote:
> On Mon, Jun 14, 2010 at 10:05:10AM -0400, Theodore Ts'o wrote:
> > FIGETBSZ has an ioctl number of _IO(0x00,2) == 2, which can conflict
> > with device driver ioctls.  Let's avoid the potential for problems by
> > only honoring the ioctl number for files where this ioctl is likely
> > going to be useful: regular files, directories, and symlinks.
> > 
> > Thanks to Johannes Stezenbach for pointing this consequence of commit
> > 19ba0559.
> 
> ioctl operate on a file descriptor, so you never call them on
> symbolic links.

Oops, good point.

> A comment explaining why we fall through here for special files is
> almost required.  Without that the chance of breaking it during the
> next random cleanup are far too high.

Sigh.  I had fixed that, but I failed to save emacs buffer before
creating commit.  Will resend with both fixes.

						- Ted
