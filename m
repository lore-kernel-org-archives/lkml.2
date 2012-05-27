Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab2E0LCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 07:02:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33512 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751163Ab2E0LC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 07:02:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+X3p5GvkKXzriDsjZPJF+Jv08OxnZedzjyYys+kO
	88YN4l39UDvFpz
Message-ID: <1338116545.27146.22.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Sun, 27 May 2012 13:02:25 +0200
In-Reply-To: <1338110259.7678.77.camel@marge.simpson.net>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop> <1337865641.9783.149.camel@laptop>
	 <1337926468.5415.48.camel@marge.simpson.net>
	 <1338014259.7302.26.camel@marge.simpson.net>
	 <1338017364.14636.9.camel@twins>
	 <1338020834.7747.8.camel@marge.simpson.net>
	 <1338110259.7678.77.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, there's something pretty darn strange going on in westmere land.
Take a peek at this, note how upset it gets at large size, and how it
then can't keep up with crusty old Q6600.  Numbers are a bit erratic,
but you'll see it.  Identical kernels, not that kernel matters. 

Q6600
marge:/usr/local/tmp/lmbench3 # !968
for m in 16K 32K 64K 128K 256K 512K 1M 2M 4M 8M; do bin/x86_64-linux-gnu/bw_tcp -P 1 -N 3 -m $m localhost; done

select_idle_sibling()              !select_idle_sibling()
0.016384 1655.83 MB/sec            1628.55 MB/sec
0.032768 1816.77 MB/sec            2086.87 MB/sec
0.065536 3148.80 MB/sec            2117.82 MB/sec
0.131072 2356.40 MB/sec            1493.96 MB/sec
0.262144 2827.00 MB/sec            1908.48 MB/sec
0.524288 3301.68 MB/sec            1908.48 MB/sec
1.048576 3359.03 MB/sec            1553.58 MB/sec
2.097152 3143.11 MB/sec            2259.11 MB/sec
4.194304 3020.53 MB/sec            1949.93 MB/sec
8.388608 2823.97 MB/sec            1868.70 MB/sec

E5620
rtbox:/usr/local/tmp/lmbench3 # !877
for m in 16K 32K 64K 128K 256K 512K 1M 2M 4M 8M; do bin/x86_64-linux-gnu/bw_tcp -P 1 -N 3 -m $m localhost; done

select_idle_sibling()              !select_idle_sibling()
0.016384 3461.28 MB/sec            2687.59 MB/sec
0.032768 4400.77 MB/sec            2939.77 MB/sec
0.065536 4517.30 MB/sec            2738.92 MB/sec
0.131072 3441.09 MB/sec            1894.25 MB/sec
0.262144 3919.65 MB/sec            2479.68 MB/sec
0.524288 1232.65 MB/sec            2341.83 MB/sec
1.048576 1230.15 MB/sec            2398.64 MB/sec
2.097152 1875.09 MB/sec            1591.16 MB/sec
4.194304 1382.21 MB/sec            1791.67 MB/sec
8.388608 1406.07 MB/sec            1078.92 MB/sec


