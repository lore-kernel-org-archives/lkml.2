Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab0HEUjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:39:45 -0400
Received: from thunk.org ([69.25.196.29]:35477 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760782Ab0HEUjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:39:36 -0400
Date: Thu, 5 Aug 2010 16:39:28 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Ric Wheeler <rwheeler@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
        djwong@us.ibm.com, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Message-ID: <20100805203928.GM2901@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jeff Moyer <jmoyer@redhat.com>,
	Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	djwong@us.ibm.com, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <20100504154553.GA22777@infradead.org>
 <20100630124832.GA1333@thunk.org>
 <4C5818A1.9070102@redhat.com>
 <20100804233206.GA2901@thunk.org>
 <4C5A1FDC.3010700@redhat.com>
 <20100805161745.GG2901@thunk.org>
 <x49pqxwc1p3.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49pqxwc1p3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:13:44PM -0400, Jeff Moyer wrote:
> > IO_CMD_FSYNC doesn't exist right now, but sure, it means we don't have
> 
> Well, there's IOCB_CMD_FSYNC.  But still, this isn't the same thing as
> what's requested.  If I understand correctly, what is requested is a
> mechanism to flush out all data for multiple file descriptors and follow
> that with a single barrier/flush (and yes, Ted did give a summary of the
> commands that would be required to accomplish that).
> 
> There still remains the question of why this should be tied to the AIO
> submission interface.

I don't think it should, personally.  The only excuse might be if
someone wanted to do an asynchronous fsync(), but I don't think that
makes sense in most cases.

					- Ted
