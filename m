Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1GZIQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:16:50 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:54467 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab1GZIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:16:43 -0400
Subject: Re: [PATCH 1/2] kernel.h: Add DIV_ROUND_UP_ULL usage
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joe Perches <joe@perches.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1311666821.26957.13.camel@Joe-Laptop>
References: <1311664225-20172-1-git-send-email-nab@linux-iscsi.org>
	 <1311666821.26957.13.camel@Joe-Laptop>
Content-Type: text/plain
Date: Tue, 26 Jul 2011 01:07:21 -0700
Message-Id: <1311667641.17766.249.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 00:53 -0700, Joe Perches wrote:
> On Tue, 2011-07-26 at 07:10 +0000, Nicholas A. Bellinger wrote:
> > Add new DIV_ROUND_UP_ULL macro usage for 32-bit architectures requiring
> > unsigned long long division of sectors * dev_max_sectors.
> []
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> []
> > +#define DIV_ROUND_UP_ULL(ll,d) \
> > +	({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
> 
> Maybe use uint64_t and a temporary for d?
> 
> #define DIV_ROUND_UP_ULL(ll, d)				\
> ({							\
> 	typeof(d) _d = d;				\
> 	uint64_t _tmp = (uint64_t)(ll) + _d - 1;	\
> 	do_div(_tmp, _d);				\
> 	_tmp;						\
> })
> 
> 

Hi Joe,

Not sure on this one myself..  Would this case ever be strictly required
for proper 32-bit operation with unsigned long long division with
sector_t..?

--nab


