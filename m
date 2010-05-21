Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab0EUPaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:30:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933436Ab0EUPaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:30:14 -0400
Date: Fri, 21 May 2010 11:37:45 -0400
From: Josef Bacik <josef@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/6] direct-io: do not merge logically non-contiguous
	requests
Message-ID: <20100521153745.GP32248@dhcp231-156.rdu.redhat.com>
References: <1274300694-8976-1-git-send-email-josef@redhat.com> <1274300694-8976-3-git-send-email-josef@redhat.com> <20100521152111.GB16049@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521152111.GB16049@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 11:21:11AM -0400, Christoph Hellwig wrote:
> On Wed, May 19, 2010 at 04:24:51PM -0400, Josef Bacik wrote:
> > Btrfs cannot handle having logically non-contiguous requests submitted.  For
> > example if you have
> > 
> > Logical:  [0-4095][HOLE][8192-12287]
> > Physical: [0-4095]      [4096-8191]
> > 
> > Normally the DIO code would put these into the same BIO's.  The problem is we
> > need to know exactly what offset is associated with what BIO so we can do our
> > checksumming and unlocking properly, so putting them in the same BIO doesn't
> > work.  So add another check where we submit the current BIO if the physical
> > blocks are not contigous OR the logical blocks are not contiguous.
> 
> This gets us slightly less optimal I/O patters for other filesystems in
> this case.  But it's probably corner case enough to not care and make it
> the default.
> 
> But please make the comment in the comment as verbose as the commit
> message so that people understand why we're doing this when reading the
> code in a few years.
> 

So after I sent this I thought that maybe I could make that test _only_ if we
provide submit_bio, that way it only affects btrfs and not everybody else, would
you prefer I do something like that?  I will make the commit log a bit more
verbose.  Thanks,

Josef
