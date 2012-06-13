Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2FMBgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:36:03 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21344 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab2FMBgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:36:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0JABju1095LKXc/2dsb2JhbABFtAMEgS2BCIIYAQEFOhwjEAgDDgouFCUDIROICgy5TBSLE1CFQQOVHoETiBGGWIJy
Date: Wed, 13 Jun 2012 11:35:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20120613013549.GO22848@dastard>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 05:36:02PM +0200, Paolo Bonzini wrote:
> This patch adds the FALLOC_FL_ZERO_RANGE operation mode to fallocate,
> resembling the similar XFS ioctl.  The new mode can be used with
> or without FALLOC_FL_KEEP_SIZE, but of course not together with
> FALLOC_FL_PUNCH_HOLE.

!FALLOC_FL_KEEP_SIZE makes no sense for this operation. It is for
zeroing an existing section of a file while retaining the allocated
space, not for extending or truncating the file. It's the same
reason that FALLOC_FL_PUNCH_HOLE must have FALLOC_FL_KEEP_SIZE set.

Also, a minor nit, but you should credit where this code has
originated from in the commit messages, and describe the use case
for requiring it. i.e. based on:

http://permalink.gmane.org/gmane.linux.file-systems/62449

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
