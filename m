Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2EYGn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:43:56 -0400
Received: from natasha.panasas.com ([67.152.220.90]:43537 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2EYGny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:43:54 -0400
Message-ID: <4FBF29F7.6030808@panasas.com>
Date: Fri, 25 May 2012 09:43:03 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Kent Overstreet <koverstreet@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>, <dm-devel@redhat.com>,
        <linux-fsdevel@vger.kernel.org>, <tj@kernel.org>, <axboe@kernel.dk>,
        <agk@redhat.com>, <neilb@suse.de>, <drbd-dev@lists.linbit.com>,
        <mpatocka@redhat.com>, <sage@newdream.net>, <yehuda@hq.newdream.net>
Subject: Re: [PATCH v2 08/14] block: Kill bi_destructor
References: <1337817771-25038-1-git-send-email-koverstreet@google.com> <1337817771-25038-9-git-send-email-koverstreet@google.com> <20120524195202.GG27550@redhat.com>
In-Reply-To: <20120524195202.GG27550@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 10:52 PM, Vivek Goyal wrote:

> In fact I am not even sure that for one driver we should introduce
> bio_reset() in generic block layer. So to me we should get rid of bio_reset()
> and let all the gory details remain in driver.
> 


I disagree. The kind of trick we do where up to BIO_RESET_BYTES
the struct is memset **must** stay at header, very close to the
structure.

I would though make bio_reset() inline at header, it's a single
memset. Even the memset is inlined by the compiler.

> Thanks
> Vivek


Thanks
Boaz
