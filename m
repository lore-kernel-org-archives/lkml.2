Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1EQI7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:59:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60505 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1EQI7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tuAvIXMXnQSpLhwWwX296wpSV78/Eb3cYEuUd5bJBoMLmiuqnK17AFbmEFJMrMTyjw
         0ivyKxKcDybzG6db+1tfC2RCRGoKRPCsRaK/Vd1imY6FelYRiDJ6jWG9ePYQx2n9A8Qu
         y18oS2XRGCd7OJXAHBoxoDCYVpvlQTQRyMORE=
Subject: Re: [patch v3 3/3] percpu_counter: use percpu data to track add
 start
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org,
        cl@linux.com
In-Reply-To: <20110517084419.775071525@sli10-conroe.sh.intel.com>
References: <20110517084117.572970726@sli10-conroe.sh.intel.com>
	 <20110517084419.775071525@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 10:59:27 +0200
Message-ID: <1305622767.2850.19.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 16:41 +0800, Shaohua Li a écrit :
> pièce jointe document texte brut (percpu-counter-percpustart.patch)
> add_start causes a lot of cache bouncing because it's updated by all
> cpus. We can actually make it a percpu variable. This will completely
> reduce the cache bouncing.
> With the patch and last patch, I get about 7x faster running the
> workload that last patch described. Only with last patch, the workload
> is only about 4x faster.
> This doesn't slow down _sum because we removed lock for _sum. I did
> a stress test. 23 CPU run _add, one cpu runs _sum. In _add fast path
> (don't hold) lock, _sum runs a little slow (about 20% slower). In
> _add slow path (hold lock), _sum runs much faster (about 9x faster);
> 
> V2: uses one percpu data as Eric suggested.

I NACK this patch very much.



