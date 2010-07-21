Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0GUL53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 07:57:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab0GUL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 07:57:27 -0400
Date: Wed, 21 Jul 2010 07:57:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 04/11] writeback: do not lose wake-ups in the forker
 thread - 2
Message-ID: <20100721115725.GB28745@infradead.org>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
 <1279704706-1267-5-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279704706-1267-5-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:31:39PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> Currently, if someone submits jobs for the default bdi, we can lose wake-up
> events. E.g., this can happen if 'bdi_queue_work()' is called when
> 'bdi_forker_thread()' is executing code after 'wb_do_writeback(me, 0)', but
> before 'set_current_state(TASK_INTERRUPTIBLE)'.
> 
> This situation is unlikely, and the result is not very severe - we'll just
> delay the execution of the work, but this is still not very nice.
> 
> This patch fixes the issue by checking whether the default bdi has works before
> the forker thread goes sleep.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

