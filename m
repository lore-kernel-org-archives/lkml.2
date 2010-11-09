Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0KIVyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:54:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:53538 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab0KIVyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:54:01 -0500
Date: Tue, 9 Nov 2010 22:53:57 +0100
From: Jan Kara <jack@suse.cz>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Josef Bacik <josef@redhat.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
        cluster-devel@redhat.com
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101109215357.GI4936@quack.suse.cz>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
 <20101109011222.GD2715@dastard>
 <20101109033038.GF3099@thunk.org>
 <20101109044242.GH2715@dastard>
 <20101109214147.GK3099@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109214147.GK3099@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-11-10 16:41:47, Ted Ts'o wrote:
> On Tue, Nov 09, 2010 at 03:42:42PM +1100, Dave Chinner wrote:
> > Implementation is up to the filesystem. However, XFS does (b)
> > because:
> > 
> > 	1) it was extremely simple to implement (one of the
> > 	   advantages of having an exceedingly complex allocation
> > 	   interface to begin with :P)
> > 	2) conversion is atomic, fast and reliable
> > 	3) it is independent of the underlying storage; and
> > 	4) reads of unwritten extents operate at memory speed,
> > 	   not disk speed.
> 
> Yeah, I was thinking that using a device-style TRIM might be better
> since future attempts to write to it won't require a separate seek to
> modify the extent tree.  But yeah, there are a bunch of advantages of
> simply mutating the extent tree.
> 
> While we're on the subject of changes to fallocate, what do people
> think of FALLOC_FL_EXPOSE_OLD_DATA, which requires either root
> privileges or (if capabilities are in use) CAP_DAC_OVERRIDE &&
> CAP_MAC_OVERRIDE && CAP_SYS_ADMIN.  This would allow a trusted process
> to fallocate blocks with the extent already marked initialized.  I've
> had two requests for such functionality for ext4 already.  
> 
> (Take for example a trusted cluster filesystem backend that checks the
> object checksum before returning any data to the user; and if the
> check fails the cluster file system will try to use some other replica
> stored on some other server.)
  Hum, could you elaborate a bit? I fail to see how above fallocate() flag
could be used to help solving this problem... Just curious...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
