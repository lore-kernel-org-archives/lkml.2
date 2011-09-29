Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1I2Svf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:51:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43091 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1I2Sve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:51:34 -0400
Date: Thu, 29 Sep 2011 19:51:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] fs/minix: Verify bitmap block counts before mounting
Message-ID: <20110929185132.GM2203@ZenIV.linux.org.uk>
References: <20110819185025.GD2270@zod.bos.redhat.com>
 <20110929183818.GI16720@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929183818.GI16720@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 02:38:18PM -0400, Josh Boyer wrote:
> On Fri, Aug 19, 2011 at 02:50:25PM -0400, Josh Boyer wrote:
> > Newer versions of MINIX can create filesystems that allocate an extra
> > bitmap block.  Mounting of this succeeds, but doing a statfs call will
> > result in an oops in count_free because of a negative number being used
> > for the bh index.
> > 
> > Avoid this by verifying the number of allocated blocks at mount time,
> > erroring out if there are not enough and make statfs ignore the extras
> > if there are too many.
> > 
> > This fixes https://bugzilla.kernel.org/show_bug.cgi?id=18792
> > 
> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> 
> Al, did this ever get queued up to send to Linus?

Sits in my tree, waiting for kernel.org to come back, with obvious
followup on top of it...

commit 2a0b3282ff528af4c0824c16d99c62a53d029720
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri Aug 26 22:38:50 2011 -0400

    minixfs: kill manual hweight(), simplify
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit b928f2ccce51ffd666e4238e8c166dfeb0069c28
Author: Josh Boyer <jwboyer@redhat.com>
Date:   Fri Aug 19 14:50:26 2011 -0400

    fs/minix: Verify bitmap block counts before mounting

