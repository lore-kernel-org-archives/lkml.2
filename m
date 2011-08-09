Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1HIQUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:20:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47463 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1HIQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:19:58 -0400
Date: Tue, 9 Aug 2011 18:19:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <msnitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch] block: properly handle flush/fua requests in
 blk_insert_cloned_request
Message-ID: <20110809161953.GD23842@htj.dyndns.org>
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
 <20110809153826.GB23842@htj.dyndns.org>
 <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
 <20110809161334.GC23842@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809161334.GC23842@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 09, 2011 at 06:13:34PM +0200, Tejun Heo wrote:
> AFAICS, the breakages are...
> 
> * ELEVATOR_INSERT_FLUSH not used properly from insert paths.
> 
> * Short circuit not kicking in for the dm requests. (the above and the
>   policy patch should solve this, right?)

Ooh... right, and we also need to add empty seq detection in
blk_insert_flush() as it would be bypassing the one in
__generic_make_request(), right?

Thanks.

-- 
tejun
