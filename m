Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2AJQ0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:26:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37648 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab2AJQ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:26:31 -0500
Date: Tue, 10 Jan 2012 08:26:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com
Subject: Re: [PATCH 1/2] block: introduce BIO_IN_FLIGHT flag
Message-ID: <20120110162625.GB20446@google.com>
References: <1324996113-1837-1-git-send-email-namhyung@gmail.com>
 <1324996113-1837-2-git-send-email-namhyung@gmail.com>
 <20120109015628.GB16360@mtj.dyndns.org>
 <4F0A57A7.4070508@lge.com>
 <20120109164148.GB21732@google.com>
 <4F0BC770.1090702@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0BC770.1090702@lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 10, 2012 at 02:06:56PM +0900, Namhyung Kim wrote:
> Oh I misunderstood what you said. I was thinking about filtering in
> pure userspace, but you meant in-kernel probe side.

Yeah yeah.

> Right, we can change the probe to filter BIO_BOUNCED case out. But
> IMHO BIO_CLONED is different, since it usually routed to another
> device as a separate IO request. I'll cook a patch for the former
> soon.

It'll probably get dup'd completions from rq and bio completions for
request based drivers, right?  Maybe there are better ways but
blktrace may as well just ignore bio completions if request
completions are happening.

Thanks.

-- 
tejun
