Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2EYSsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 14:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab2EYSst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 14:48:49 -0400
Date: Fri, 25 May 2012 14:48:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 11/14] block: Rework bio splitting
Message-ID: <20120525184827.GA8300@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-12-git-send-email-koverstreet@google.com>
 <4FBE6823.50904@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBE6823.50904@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 07:56:03PM +0300, Boaz Harrosh wrote:

[..]
> In the split you have a single bio with or without bvects allocation
> should you not let the caller make sure not to set __GFP_WAIT.
> 
> For me, inspecting current->bio_list is out of context and a complete
> hack. The caller should take care of it, which has more context.
> 
> For example I might want to use split from OSD code where I do
> not use an elevator at all, and current->bio_list could belong
> to a completely different device. (Maybe)

FWIW, I too think that checking for current->bio_list in bio_split() sounds
hackish and it should be left to caller to set right gfp flags. And it should
be commented well.

Thanks
Vivek
