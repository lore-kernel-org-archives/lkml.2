Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab2IGBe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 21:34:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36899 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2IGBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 21:34:25 -0400
Message-ID: <50494F1A.4080207@kernel.dk>
Date: Thu, 06 Sep 2012 19:34:18 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH v10 4/8] block: Add bio_reset()
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-5-git-send-email-koverstreet@google.com>
In-Reply-To: <1346970902-10931-5-git-send-email-koverstreet@google.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-06 16:34, Kent Overstreet wrote:
> Reusing bios is something that's been highly frowned upon in the past,
> but driver code keeps doing it anyways. If it's going to happen anyways,
> we should provide a generic method.
> 
> This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> was open coding it, by doing a bio_init() and resetting bi_destructor.
> 
> This required reordering struct bio, but the block layer is not yet
> nearly fast enough for any cacheline effects to matter here.

That's an odd and misplaced comment. Was just doing testing today at 5M
IOPS, and even years back we've had cache effects for O_DIRECT in higher
speed setups.

That said, we haven't done cache analysis in a long time. So moving
members around isn't necessarily a huge deal.

Lastly, this isn't a great commit message for other reasons. Anyone can
see that it moves members around. It'd be a lot better to explain _why_
it is reordering the struct.

BTW, I looked over the rest of the patches, and it looks OK to me.
However, you didn't CC me on the full series, so I'm missing bits 3 and
5.

-- 
Jens Axboe

