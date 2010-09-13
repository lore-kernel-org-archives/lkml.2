Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0IMPVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:21:50 -0400
Received: from bar.sig21.net ([80.81.252.164]:33298 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab0IMPVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:21:47 -0400
Date: Mon, 13 Sep 2010 17:21:38 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: block cache replacement strategy?
Message-ID: <20100913152138.GA16334@sig21.net>
References: <20100907133429.GB3430@sig21.net>
 <20100909120044.GA27765@sig21.net>
 <20100910120235.455962c4@schatten.dmk.lab>
 <20100910160247.GA637@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910160247.GA637@sig21.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.588,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 06:02:48PM +0200, Johannes Stezenbach wrote:
> 
> Linear read heuristic might be a good guess, but it would
> be nice to hear a comment from a vm/fs expert which
> confirms this works as intended.

Apparently I'm unworthy to get a response from someone knowledgable :-(

Anyway I found lmdd (from lmbench) can do random reads,
and indeed causes the data to enter the block (page?) cache,
replacing the previous data.


Johannes


zzz:~# echo 3 >/proc/sys/vm/drop_caches

zzz:~# ./lmdd if=~js/qemu/test.img bs=1M count=1000
1000.0000 MB in 17.7554 secs, 56.3210 MB/sec
zzz:~# ./lmdd if=~js/qemu/test.img bs=1M count=1000
1000.0000 MB in 0.9112 secs, 1097.4178 MB/sec

zzz:~# ./lmdd if=~js/qemu/test2.img bs=1M count=1000 rand=1G norepeat=
norepeat on 238035072
norepeat on 724579648
1000.0000 MB in 21.4419 secs, 46.6376 MB/sec
zzz:~# ./lmdd if=~js/qemu/test2.img bs=1M count=1000 rand=1G norepeat=
norepeat on 238035072
norepeat on 724579648
1000.0000 MB in 14.3859 secs, 69.5125 MB/sec
zzz:~# ./lmdd if=~js/qemu/test2.img bs=1M count=1000 rand=1G norepeat=
norepeat on 238035072
norepeat on 724579648
1000.0000 MB in 0.8764 secs, 1141.0810 MB/sec
