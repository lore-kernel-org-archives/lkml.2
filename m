Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1AZKvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:51:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60813 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1AZKvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JJNDPptRzoPYUjPioiy9fAz1POX4hanr2QOWmgiAPGo8d/O228JM5oK+lh1DohYxGC
         JwAGHDAhn3q/8NI9D7BEz6sOBpYXMKeePDH7xz5RdTT4T3oxXKvOANprmLCZbTc3P2Nk
         9XU10SbwNl6pJ8Xx8u88m+Wlbw5E9zSB7H9Tw=
Date: Wed, 26 Jan 2011 11:51:39 +0100
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, tytso@mit.edu, shli@kernel.org, neilb@suse.de,
        adilger.kernel@dilger.ca, snitzer@redhat.com,
        linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
        linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
        josef@redhat.com
Subject: Re: [PATCH 3/3] ext4: Deprecate barrier= and nobarrier mount
 options
Message-ID: <20110126105139.GJ12520@htj.dyndns.org>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126072329.GK27190@tux1.beaverton.ibm.com>
 <20110126093632.GB12520@htj.dyndns.org>
 <20110126104734.GA23245@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126104734.GA23245@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 26, 2011 at 11:47:34AM +0100, Jan Kara wrote:
>   Ted should have a final word about this but I believe it's possible to
> deprecate the mount options. Maybe with some transition period where
> deprecation message is shown but the option actually still works. That
> being said I'm not sure what we should do when someone has a disk with two
> partitions and one partition is mounted with barriers and another one
> without them - sure, one has to think hard to find a sane use case for this
> (possibly if user does not care about data after a crash on one of the
> partitions, in which case he should probably use nojournal mode) but it
> should probably work.

The policy can be made per-bdev (which maps to per-partition), so I
don't think that's a big problem.

Thanks.

-- 
tejun
