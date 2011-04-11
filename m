Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab1DKIgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:36:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab1DKIgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:36:00 -0400
Subject: Re: [RFC][PATCH 2/9] perf: Clean up ctx reference counting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1302501948.29423.4.camel@minggr.sh.intel.com>
References: <20110409191739.813727025@chello.nl>
	 <20110409192141.719340481@chello.nl>
	 <1302501948.29423.4.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 10:35:40 +0200
Message-ID: <1302510940.2388.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 14:05 +0800, Lin Ming wrote:

> > +			put_ctx(ctx);
> 
> You moved the get_ctx(), so it seems that this put_ctx is missing its
> relevant get_ctx.

Yeah, its cheating since we initialize the refcount on 1.
