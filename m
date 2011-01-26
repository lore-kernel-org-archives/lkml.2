Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1AZJgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:36:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38690 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1AZJgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:36:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bYLlEwQyBXmjTFAM0sAdLfZbbW1HLJDp8dwJkqQSz8/do7M6hEof2oUG08uULDuMUQ
         IYE5ZCNqGjTL/LZQ+lZ5Y2gzfrQbWTcK4AohP7ho9J03mIhjqcM9J3WGFEeQ6xm7TEx6
         8NeXwpQCXJLyaathVPuKjARI0rrgsnqc8uZ98=
Date: Wed, 26 Jan 2011 10:36:32 +0100
From: Tejun Heo <tj@kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, tytso@mit.edu,
        shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        snitzer@redhat.com, linux-kernel@vger.kernel.org, kmannth@us.ibm.com,
        cmm@us.ibm.com, linux-ext4@vger.kernel.org, rwheeler@redhat.com,
        hch@lst.de, josef@redhat.com
Subject: Re: [PATCH 3/3] ext4: Deprecate barrier= and nobarrier mount
 options
Message-ID: <20110126093632.GB12520@htj.dyndns.org>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126072329.GK27190@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126072329.GK27190@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 25, 2011 at 11:23:29PM -0800, Darrick J. Wong wrote:
> As part of migrating the FLUSH/FUA knob to the block layer, remove the support
> code for the barrier-related mount options and remove the conditionals around
> flushes in favor of always issuing the flush.  The block layer will handle
> gracefully the situation where a FLUSH or FUA request is issued to a device
> that doesn't support it.  Modify the option parsing code to print a warning if
> someone tries to use the old mount option.
> 
> Note: The nobarrier bit in the default mount flags is now useless.

The option is something which users are already quite familiar with.
I think we'll just have to carry this around.  What we can do, tho, is
moving the actual control mechanism to block layer -
ie. blkdev_skip_flush() or something like that which ignores flush
requests for the current exclusive opener.

Thanks.

-- 
tejun
