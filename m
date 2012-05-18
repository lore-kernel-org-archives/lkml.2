Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab2ERQnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:43:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758613Ab2ERQnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:43:31 -0400
Date: Fri, 18 May 2012 17:43:19 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: koverstreet@google.com, axboe@kernel.dk, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, agk@redhat.com,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 02/13] dm: kill dm_rq_bio_destructor
Message-ID: <20120518164319.GJ29330@agk-dp.fab.redhat.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>, koverstreet@google.com,
	axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	agk@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <cover.1337308722.git.koverstreet@google.com> <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com> <20120518155729.GB19388@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518155729.GB19388@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 08:57:29AM -0700, Tejun Heo wrote:
> Please explain why this is done and how it's safe.  Alasdair / dm
> folks, can you please ack this?
 
I think it's relying on there being never more than one reference on those 
bios so that that endio fn, called exactly once, always frees it and there
are no dm_puts elsewhere.

Alasdair

