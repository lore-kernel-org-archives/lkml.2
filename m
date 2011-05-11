Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1EKP7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:59:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:54156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab1EKP7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:59:07 -0400
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched
 domain
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <BANLkTin5iNMt2autv3TJpCvTQUoKsSzhTA@mail.gmail.com>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
	 <1305016329.2914.22.camel@laptop>
	 <BANLkTin5iNMt2autv3TJpCvTQUoKsSzhTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 15:54:15 +0200
Message-ID: <1305122055.2914.220.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 21:26 +0800, Hillf Danton wrote:
> Your work for rewriting NUMA support, published at
>          http://marc.info/?l=linux-kernel&m=130218515520540
> is patched by changing how level is computed and by changing how it is
> used to build the mask.
> 
> When computing, some valid levels are lost in your work.
> 
> When building mask, nodes are selected only if they have same distance,
> thus nodes of less distance are also masked out since the computation of
> level now is tough.
> 
> Without MUNA hardware, I did not test the patch:(

I do have a (tiny) NUMA box (2 nodes) but that actually booted with the
old code too, Andreas Hermann from AMD (CC'ed) is usually willing to
test such patches on somewhat larger systems. Please send a full patch
against tip/master for him to apply.

