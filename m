Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0KJOKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:10:13 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42120 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0KJOKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:10:10 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
References: <1289339119.2191.92.camel@laptop>
	 <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 15:10:07 +0100
Message-ID: <1289398207.2191.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 14:01 +0100, Stephane Eranian wrote:
> Peter,

> > 6
> 
> And then, what do you do with 6?
> I assume you have to pass it in the attr struct.

perf_event_attr::type, as said in the initial changelog.

> How do you plan on doing this while keeping what is already there?

+       if (type < 0) {
+               err = idr_get_new_above(&pmu_idr, pmu, PERF_TYPE_MAX, &type);

and

+       rcu_read_lock();
+       pmu = idr_find(&pmu_idr, event->attr.type);
+       rcu_read_unlock();
+       if (pmu)
+               goto unlock;


So we start dynamic IDs at the top of the static range, and only do
dynamic IDs for those that don't already have a static number.


