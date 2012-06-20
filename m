Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab2FTQBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:01:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:34136 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab2FTQBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:01:42 -0400
Message-ID: <1340208092.21745.114.camel@twins>
Subject: Re: [PATCH V6 0/13] perf: Intel uncore pmu counting support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 20 Jun 2012 18:01:32 +0200
In-Reply-To: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ok, so with this stuff something like:

  perf stat -ae uncore/event=clockticks/ foo

will register a counter per cpu, which is somewhat silly since we only
need one per node. What would be the best way to 'fix' this?

We could of course create another variant of -a which iterates nodes
instead of cpus, -N or so.

Alternatively we could try and describe this in sysfs in some way, one
possibility would be to include a link to /sys/devices/system/{cpu,node}
or somesuch and use that link to iterate the correct space.

Any other suggestions?
