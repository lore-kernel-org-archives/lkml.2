Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1C2S0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:26:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1C2S0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:26:06 -0400
Date: Tue, 29 Mar 2011 14:25:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110329182555.GA22898@infradead.org>
References: <20110325151530.GA4414@swordfish.minsk.epam.com>
 <20110325152228.GA1707@gentoo.trippels.de>
 <20110325154024.GA16029@redhat.com>
 <4D8CB9C9.5010208@kernel.dk>
 <20110325185455.GA2969@redhat.com>
 <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <4D91C8E7.5070205@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D91C8E7.5070205@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, is there any need to actually keep the elv_insert interface?

Itw has two callers in current mainline, two of them hardcode
ELEVATOR_INSERT_REQUEUE as the reason and could opencode it, and
the other cases could be merged into __elv_add_request.

