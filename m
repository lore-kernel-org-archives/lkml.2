Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab0GTLir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 07:38:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:48267 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab0GTLiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 07:38:46 -0400
Subject: Re: [RFC][PATCH 12/16] writeback: add to bdi_list in the forker
 thread
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100718065851.GJ23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
	 <1279284312-2411-13-git-send-email-dedekind1@gmail.com>
	 <20100718065851.GJ23811@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 14:32:12 +0300
Message-ID: <1279625532.16462.117.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Jul 2010 11:38:34.0259 (UTC) FILETIME=[15E45E30:01CB2800]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-18 at 02:58 -0400, Christoph Hellwig wrote:
> What about never removing a bdi from bdi_list?  If we have the
> correct checks for dirty_io and the task there's no need to
> ever remove a life bdi from the list.  Just add it in bdi_register
> and remove it in bdi_unregister.

But I think it will be less error-prone and nicer to still have this
patch, then move the killing logic from bdi threads to the forker task,
and then, as a separate patch on top of that, get rid of this removing
bdi from bdi_list part. I mean, this way the patch series will be more
logical and finer grained and easier to review.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

