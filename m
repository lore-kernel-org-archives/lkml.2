Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab1GMPGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:06:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56713 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1GMPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:06:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=D1g64L95KYrAGkWHooAX54OXpegB0+HL2P73MWab4fHxNhCD1oCXIYFc47aMJLOnx
	fxBKyA1c5HBmxOQE7KYpQ==
Date: Wed, 13 Jul 2011 08:06:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Jan Kara <jack@suse.cz>
cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] writeback: remove writeback_control.more_io
In-Reply-To: <20110713111928.GA21787@quack.suse.cz>
Message-ID: <alpine.LSU.2.00.1107130804430.4820@sister.anvils>
References: <20110607213236.634026193@intel.com> <20110607213854.888623315@intel.com> <alpine.LSU.2.00.1107111408060.13830@sister.anvils> <20110712062013.GA4654@localhost> <alpine.LSU.2.00.1107121207540.1752@sister.anvils> <alpine.LSU.2.00.1107122234460.3608@sister.anvils>
 <alpine.LSU.2.00.1107130350570.4184@sister.anvils> <20110713111928.GA21787@quack.suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011, Jan Kara wrote:
> On Wed 13-07-11 03:57:40, Hugh Dickins wrote:
> > 
> > I think we should assume that your -requeue_io +redirty_tail is a good
> > fix for the writeback freeze (if you can reassure us, that it does not
> > risk postponing some writes indefinitely)
>   Well, I_FREEING or I_WILL_FREE inodes are written back by iput_final()
> and it is reclaim code that is responsible for eventually removing them. So
> writeback code can safely ignore them. I_NEW inodes should move out of this
> state when they are fully set up and in the writeback round following that,
> we will consider them for writeback. So I think the change really makes
> sense.

That fits.  Good, thanks for the reassurance.

Hugh
