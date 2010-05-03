Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab0ECN1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:27:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:59049 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759412Ab0ECN10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:27:26 -0400
Subject: Re: [PATCH 1/4] cpu_stop: implement stop_cpu[s]()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
In-Reply-To: <1271952554-22368-2-git-send-email-tj@kernel.org>
References: <1271952554-22368-1-git-send-email-tj@kernel.org>
	 <1271952554-22368-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 May 2010 15:26:29 +0200
Message-ID: <1272893189.5605.120.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 18:09 +0200, Tejun Heo wrote:
> +void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void
> *arg,
> +                       struct cpu_stop_work *work_buf)
> +{
> +       memset(work_buf, 0, sizeof(*work_buf));
> +       work_buf->fn = fn;
> +       work_buf->arg = arg; 

 *work_buf = (struct cpu_stop_work){ .fn = fn, .arg = arg, };


