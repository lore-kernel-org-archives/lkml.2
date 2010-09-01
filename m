Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0IAN50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:57:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:55868 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab0IAN5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:57:23 -0400
Message-ID: <4C7E5BA9.7020509@kernel.org>
Date: Wed, 01 Sep 2010 15:56:57 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        dm-devel@redhat.com
Subject: Re: [PATCH 3/5] dm: relax ordering of bio-based flush implementation
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-4-git-send-email-tj@kernel.org> <20100901135120.GA25251@redhat.com>
In-Reply-To: <20100901135120.GA25251@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Sep 2010 13:56:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 03:51 PM, Mike Snitzer wrote:
> Could you please document why it is OK to remove 'flush_error' in the
> patch header?  The -EOPNOTSUPP handling removal (done in patch 2)
> obviously helps enable this but it is not clear how the
> 'num_flush_requests' flushes that __clone_and_map_flush() generates do
> not need explicit DM error handling.

Sure, I'll.  It's because it now uses the same error handling path in
dec_pending() all other bio's use.  The flush_error thing was there
because flushes got executed/completed in a separate code path to
begin with.  With the special path gone, there's no need for
flush_error path either.

Thanks.

-- 
tejun
