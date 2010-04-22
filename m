Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0DVJNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 05:13:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43359 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0DVJNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 05:13:30 -0400
Subject: Re: [RFC][PATCH 1/4] perf: core, add group scheduling
 transactional APIs
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>, arjan@linux.intel.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1271922662.30535.107.camel@minggr.sh.intel.com>
References: <1271922662.30535.107.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 10:24:59 +0200
Message-ID: <1271924699.1776.316.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 15:51 +0800, Lin Ming wrote:
> +       if (pmu->commit_txn) {
> +               ret = pmu->commit_txn(pmu);
> +               if (!ret) {
> +                       if (pmu->stop_txn)
> +                               pmu->stop_txn(pmu);
> +
> +                       return 0;
> +               }
> +       } 

I think we can mandate that if one of the _txn methods is available,
they all are, it would be weird otherwise.

