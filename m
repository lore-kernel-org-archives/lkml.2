Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab0FJMtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:49:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:36590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab0FJMtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:49:22 -0400
Subject: Re: [PATCH 13/13] jump label v9: add docs
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
In-Reply-To: <382f7818b6a8e63ff971743ee0c4820b364c7f2f.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
	 <382f7818b6a8e63ff971743ee0c4820b364c7f2f.1276116186.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 14:49:00 +0200
Message-ID: <1276174140.2077.261.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> +The optimization depends on !CC_OPTIMIZE_FOR_SIZE. When CC_OPTIMIZE_FOR_SIZE is
> +set, gcc does not always out of line the not taken label path in the same way
> +that the "if unlikely()" paths are made out of line. Thus, with
> +CC_OPTIMIZE_FOR_SIZE set, this optimization is not always optimal. This may be
> +solved in subsequent gcc versions, that allow us to move labels out of line,
> +while still optimizing for size. In the case of !CC_OPTIMIZE_FOR_SIZE this
> +optimization is seen on high level benchmarks such as tbench where I can get
> +~1-2% higher throughput. In addition we are within .5% of the performance of no
> +tracepoints compiled in at all. 

But does it generate invalid code for whatever -f flag triggers this
(-fno-reorder-blocks ?)

