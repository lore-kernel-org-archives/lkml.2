Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1H2N15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:27:57 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54529 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab1H2N1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:27:51 -0400
Date: Mon, 29 Aug 2011 09:27:34 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Anton Blanchard <anton@samba.org>
Cc: adilger.kernel@dilger.ca, eric.dumazet@gmail.com, tj@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Message-ID: <20110829132734.GB12187@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Anton Blanchard <anton@samba.org>, adilger.kernel@dilger.ca,
	eric.dumazet@gmail.com, tj@kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20110826072622.406d3395@kryten>
 <20110826072927.5b4781f9@kryten>
 <A91A91A5-9EF0-42FE-B1C3-184D65112EA9@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A91A91A5-9EF0-42FE-B1C3-184D65112EA9@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 07:48:52AM -0400, Theodore Tso wrote:
> 
> I understand why we would want to reduce this number.   Unfortunately, the
> question is what do we do if all 1024 threads try to do buffered writes into
> the file system at the same instant, when we have less than 4 megabytes
> of space left?

Oops, sorry, that should be 4 GB of space left (i.e., what do we do if
all 1024 cpu's all try write 1024 4k blocks all at the same time).
Imagine an simulation application where all threads finish at more or
less the same time and then try to write out their data files at the
same time....

							- Ted
