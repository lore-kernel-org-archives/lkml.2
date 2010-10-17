Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab0JQSHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:07:01 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:40261 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab0JQSHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:07:00 -0400
X-ASG-Debug-ID: 1287338818-6959414b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CBB3B3D.5050800@fusionio.com>
Date: Sun, 17 Oct 2010 20:06:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Dan Carpenter <error27@gmail.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "cbe-oss-dev@lists.ozlabs.org" <cbe-oss-dev@lists.ozlabs.org>
Subject: Re: [PATCH] block: Turn bvec_k{un,}map_irq() into static inline 
 functions
References: <alpine.DEB.2.00.1010171335400.919@ayla.of.borg>
X-ASG-Orig-Subj: Re: [PATCH] block: Turn bvec_k{un,}map_irq() into static inline 
 functions
In-Reply-To: <alpine.DEB.2.00.1010171335400.919@ayla.of.borg>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1287338818
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4877 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.43966
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-17 13:38, Geert Uytterhoeven wrote:
> Convert bvec_k{un,}map_irq() from macros to static inline functions if
> !CONFIG_HIGHMEM, so we can easier detect mistakes like the one fixed in
> 93055c31045a2d5599ec613a0c6cdcefc481a460 ("ps3disk: passing wrong variable to
> bvec_kunmap_irq()")

Does this cause any warnings on the existing kernel? It's the same issue
we have with the kunmap_atomic() API, and they are generally used to map
structures etc as well. So char * isn't necessarily always a good
choice, and hence the "fix" there is to just check whether a page struct
is being passed in or not.

OK, so did a quick grep, and there's just the two users of it. So pretty
straight forward, I'll add your patch. Thanks!

-- 
Jens Axboe

