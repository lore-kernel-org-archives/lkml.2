Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2LFSTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:19:40 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:49653 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab2LFSTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:19:38 -0500
X-ASG-Debug-ID: 1354817977-0421b52b7d671a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50C0E1B6.5060602@fusionio.com>
Date: Thu, 6 Dec 2012 19:19:34 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jeff Moyer <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Zach Brown <zab@redhat.com>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo <mingo@redhat.com>
Subject: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
References: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com> <50BE5988.3050501@fusionio.com> <x498v9dpnwu.fsf@segfault.boston.devel.redhat.com> <50BE5C99.6070703@fusionio.com> <x494nk1pi7h.fsf@segfault.boston.devel.redhat.com> <20121206180150.GQ19802@htj.dyndns.org>
X-ASG-Orig-Subj: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
In-Reply-To: <20121206180150.GQ19802@htj.dyndns.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354817977
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116268
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-06 19:01, Tejun Heo wrote:
> As for the original patch, I think it's a bit too much to expose to
> userland.  It's probably a good idea to bind the flusher to the local
> node but do we really need to expose an interface to let userland
> control the affinity directly?  Do we actually have a use case at
> hand?

We need to expose it. Once the binding is set from the kernel side on a
kernel thread, it can't be modified.

Binding either for performance reasons or for ensuring that we
explicitly don't run in some places is a very useful feature.

-- 
Jens Axboe

