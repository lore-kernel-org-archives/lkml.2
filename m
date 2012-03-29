Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab2C2Ay5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 20:54:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab2C2Ayt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 20:54:49 -0400
Date: Wed, 28 Mar 2012 20:54:42 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, viro@zeniv.linux.org.uk,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-ID: <20120329005442.GB16008@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, viro@zeniv.linux.org.uk,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	David Rientjes <rientjes@google.com>
References: <20120313182220.GA11500@redhat.com>
 <20120327155149.d41a235b.akpm@linux-foundation.org>
 <20120328001550.GA3077@redhat.com>
 <20120328043951.GA32741@dastard>
 <20120328164720.d1aea752.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328164720.d1aea752.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 04:47:20PM -0700, Andrew Morton wrote:
 > On Wed, 28 Mar 2012 15:39:51 +1100
 > Dave Chinner <david@fromorbit.com> wrote:
 > 
 > > > Well, the unusual thing was that I was fuzzing system calls for a few hours.
 > > > 
 > > > My fuzzing tool was able to trigger these very easily after an hour or two
 > > > of uptime and memory had fragmented a little, so yeah, quite trivial.
 > > 
 > > We've recently been seeing reports of xfsdump trigging a similar
 > > allocation failures in the XFS attr code when we are doing hundreds
 > > of thousands of attribute lookups to back them up.
 > > 
 > > ad650f5 xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
 > > 
 > > I think that falling back to vmalloc here is much better solution
 > > than failing to retreive the attribute - it will work no matter how
 > > fragmented memory gets. That means we don't get incomplete
 > > backups occurring after days or months of uptime and successful
 > > backups...
 > 
 > Yup.  How does the below look?

Don't see anything immediately wrong with it.
Any thoughts on what to do about the similar problem in setxattr ? (memdup_user)

	Dave
