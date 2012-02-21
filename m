Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2BUBQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:16:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47632 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab2BUBQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:16:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.218.161 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 20 Feb 2012 17:15:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [RFC] block: fix __blkdev_get and add_disk race condition
Message-ID: <20120221011552.GB15898@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120218172609.GA11478@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120218172609.GA11478@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Nice catch.

On Sat, Feb 18, 2012 at 06:26:13PM +0100, Stanislaw Gruszka wrote:
> As drawback, I do not teardown on sysfs file create error, because I do
> not know how to nullify disk->ev (since it can be used).

add_disk() error handling is mostly non-existent and the error
behavior should be acceptable (no sysfs files created but everything
else behaves the same).

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
