Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2FNHaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:30:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56141 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2FNHaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:30:08 -0400
Message-ID: <4FD992F7.5050800@kernel.dk>
Date: Thu, 14 Jun 2012 09:29:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Asias He <asias@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH RFC 1/2] block: Add blk_bio_map_sg() helper
References: <1339573307-11537-1-git-send-email-asias@redhat.com> <1339573307-11537-2-git-send-email-asias@redhat.com> <20120614023156.GB3766@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120614023156.GB3766@dhcp-172-17-108-109.mtv.corp.google.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-14 04:31, Tejun Heo wrote:
> On Wed, Jun 13, 2012 at 03:41:46PM +0800, Asias He wrote:
>> Add a helper to map a bio to a scatterlist, modelled after
>> blk_rq_map_sg.
>>
>> This helper is useful for any driver that wants to create
>> a scatterlist from its ->make_request_fn method.
> 
> This may not be possible but I really wanna avoid having two copies of
> that complex logic.  Any chance blk_rq_map_bio() can be implemented in
> a way that allows blk_rq_map_sg() can be built on top of it?  Also,

Was thinking the same thing, definitely code we don't want to have
duplicated. We've had mapping bugs in the past.

Asias, this should be trivial to do, except that blk_rq_map_sg()
potentially maps across bio's as well. The tracking of the prev bio_vec
does not care about cross bio boundaries.

-- 
Jens Axboe

