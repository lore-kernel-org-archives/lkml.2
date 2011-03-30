Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1C3Hxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:53:44 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34686 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1C3Hxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:53:43 -0400
Message-ID: <4D92E186.5030603@kernel.dk>
Date: Wed, 30 Mar 2011 09:53:42 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
References: <20110325151530.GA4414@swordfish.minsk.epam.com> <20110325152228.GA1707@gentoo.trippels.de> <20110325154024.GA16029@redhat.com> <4D8CB9C9.5010208@kernel.dk> <20110325185455.GA2969@redhat.com> <4D8CF202.9010809@kernel.dk> <20110326042156.GB28458@redhat.com> <20110328082321.GC16530@htj.dyndns.org> <20110328221547.GA1118@redhat.com> <4D91C8E7.5070205@kernel.dk> <20110329182555.GA22898@infradead.org>
In-Reply-To: <20110329182555.GA22898@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 20:25, Christoph Hellwig wrote:
> Btw, is there any need to actually keep the elv_insert interface?
> 
> Itw has two callers in current mainline, two of them hardcode
> ELEVATOR_INSERT_REQUEUE as the reason and could opencode it, and
> the other cases could be merged into __elv_add_request.

Agree, I merged the two and killed elv_insert().

-- 
Jens Axboe

