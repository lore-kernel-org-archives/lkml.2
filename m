Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1H2Lyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:54:47 -0400
Received: from ozlabs.org ([203.10.76.45]:56593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1H2Lym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:54:42 -0400
Date: Mon, 29 Aug 2011 21:54:39 +1000
From: Anton Blanchard <anton@samba.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: adilger.kernel@dilger.ca, eric.dumazet@gmail.com, tj@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Message-ID: <20110829215439.63353384@kryten>
In-Reply-To: <A91A91A5-9EF0-42FE-B1C3-184D65112EA9@mit.edu>
References: <20110826072622.406d3395@kryten>
	<20110826072927.5b4781f9@kryten>
	<A91A91A5-9EF0-42FE-B1C3-184D65112EA9@mit.edu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ted,

> I understand why we would want to reduce this number.
> Unfortunately, the question is what do we do if all 1024 threads try
> to do buffered writes into the file system at the same instant, when
> we have less than 4 megabytes of space left?
> 
> The problem is that we can then do more writes than we have space, and
> we will only find out about it at write back time, when the process
> may have exited already -- at which point data loss is almost
> inevitable.  (We could keep the data in cache and frantically page
> the system administrator to delete some files to make room for dirty
> data, but that's probably not going to end well….)
> 
> What we can do if we must clamp this threshold is to also increase the
> threshold at which we shift away from delayed allocation.  We'll then
> allocate each block at write time, which does mean more CPU and 
> less efficient allocation of blocks, but if we're down to our last 4
> megabytes, there's probably not much we can do that will be efficient
> as far as block layout anyway….

Thanks for the explanation, I'll go back and take another look.

Anton
