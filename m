Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1BOPqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:46:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1BOPqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:46:37 -0500
Date: Tue, 15 Feb 2011 15:46:25 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>,
        Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
	read-write for read-only mappings
Message-ID: <20110215154625.GG5825@agk-dp.fab.redhat.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
References: <4D5A6EF4.3030905@redhat.com> <20110215124629.GF5825@agk-dp.fab.redhat.com> <20110215152033.GK3160@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215152033.GK3160@htj.dyndns.org>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 04:20:33PM +0100, Tejun Heo wrote:
> Hmmm... but -EACCES is the correct one here.  The device node itself
> is rejecting RW access.  There's no FS which is enforcing RO.

Exactly:)  If the filesystem permissions were what was blocking this
(say r--) then I'd agree with EACCES.  Interpret those man pages in the
context of 'pathname refers to a block device not a file'.
 
If it's EACCES, I just need to gain more privilege/capabilities and then
repeat the system call and it could succeed.

But EROFS tells me however much extra privilege I get it's going to make
no difference.

That's why I'm arguing EACCES is not a good error to return and EROFS is
more appropriate.

Alasdair

