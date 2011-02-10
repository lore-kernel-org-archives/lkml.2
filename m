Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1BJE6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:58:17 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:49383 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab1BJE6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:58:15 -0500
X-Greylist: delayed 1774 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Feb 2011 23:58:15 EST
Date: Thu, 10 Feb 2011 05:28:40 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: nfsd: non-standard errno: 925302784
Message-ID: <20110210042840.GF11496@MAIL.13thfloor.at>
Mail-Followup-To: Trond Myklebust <Trond.Myklebust@netapp.com>,
	LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Trond!

I'm seeing _a_lot_ of those messages on one of my
test servers (probably caused by a client doing an
rsync -aX to an nfs mount), so I added a rate limit
and a stack trace which results in those traces:

(0x37270000 looks strange for an errno)

Any ideas how to fix that properly?

Thanks in Advance,
Herbert


[89066.666981] nfsd: non-standard errno: 925302784
[89066.666984] Pid: 5233, comm: nfsd Tainted: G       A    2.6.38-rc3 #8
[89066.666986] Call Trace:
[89066.666994]  [<ffffffffa02cb118>] ? nfserrno+0x68/0x80 [nfsd]
[89066.666999]  [<ffffffffa02dcb77>] ? nfsd4_decode_fattr+0x537/0x9c0 [nfsd]
[89066.667005]  [<ffffffffa02dd034>] ? nfsd4_decode_setattr+0x34/0x40 [nfsd]
[89066.667010]  [<ffffffffa02dc102>] ? nfs4svc_decode_compoundargs+0x2c2/0x3c0 [nfsd]
[89066.667014]  [<ffffffffa02c936f>] ? nfsd_dispatch+0x7f/0x240 [nfsd]
[89066.667025]  [<ffffffffa01beb49>] ? svc_process+0x479/0x7a0 [sunrpc]
[89066.667029]  [<ffffffffa02c9a20>] ? nfsd+0x0/0x140 [nfsd]
[89066.667033]  [<ffffffffa02c9acf>] ? nfsd+0xaf/0x140 [nfsd]
[89066.667037]  [<ffffffff810672c6>] ? kthread+0x96/0xa0
[89066.667040]  [<ffffffff810038d4>] ? kernel_thread_helper+0x4/0x10
[89066.667042]  [<ffffffff81067230>] ? kthread+0x0/0xa0
[89066.667044]  [<ffffffff810038d0>] ? kernel_thread_helper+0x0/0x10

[89066.669233] nfsd: non-standard errno: 925302784
[89066.669237] Pid: 5233, comm: nfsd Tainted: G       A    2.6.38-rc3 #8
[89066.669238] Call Trace:
[89066.669248]  [<ffffffffa02cb118>] ? nfserrno+0x68/0x80 [nfsd]
[89066.669253]  [<ffffffffa02dcb77>] ? nfsd4_decode_fattr+0x537/0x9c0 [nfsd]
[89066.669258]  [<ffffffffa02dd034>] ? nfsd4_decode_setattr+0x34/0x40 [nfsd]
[89066.669264]  [<ffffffffa02dc102>] ? nfs4svc_decode_compoundargs+0x2c2/0x3c0 [nfsd]
[89066.669268]  [<ffffffffa02c936f>] ? nfsd_dispatch+0x7f/0x240 [nfsd]
[89066.669280]  [<ffffffffa01beb49>] ? svc_process+0x479/0x7a0 [sunrpc]
[89066.669284]  [<ffffffffa02c9a20>] ? nfsd+0x0/0x140 [nfsd]
[89066.669288]  [<ffffffffa02c9acf>] ? nfsd+0xaf/0x140 [nfsd]
[89066.669291]  [<ffffffff810672c6>] ? kthread+0x96/0xa0
[89066.669294]  [<ffffffff810038d4>] ? kernel_thread_helper+0x4/0x10
[89066.669297]  [<ffffffff81067230>] ? kthread+0x0/0xa0
[89066.669299]  [<ffffffff810038d0>] ? kernel_thread_helper+0x0/0x10

