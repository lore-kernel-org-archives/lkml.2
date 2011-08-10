Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1HJRLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:11:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60321 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab1HJRLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:11:02 -0400
Subject: Re: [PATCH 3/5] writeback: dirty rate control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Aug 2011 19:10:26 +0200
In-Reply-To: <20110810140002.GA29724@localhost>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.878435971@intel.com> <20110809155046.GD6482@redhat.com>
	 <1312906591.1083.43.camel@twins> <20110810140002.GA29724@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312996226.23660.43.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 22:00 +0800, Wu Fengguang wrote:
> 
> > Although I'm not quite sure how he keeps fairness in light of the
> > sleep time bounding to MAX_PAUSE.
> 
> Firstly, MAX_PAUSE will only be applied when the dirty pages rush
> high (dirty exceeded).  Secondly, the dirty exceeded state is global
> to all tasks, in which case each task will sleep for MAX_PAUSE equally.
> So the fairness is still maintained in dirty exceeded state. 

Its not immediately apparent how dirty_exceeded and MAX_PAUSE interact,
but having everybody sleep MAX_PAUSE doesn't necessarily mean its fair,
its only fair if they dirty at the same rate.
