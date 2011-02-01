Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1BAQSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:18:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:32896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1BAQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:18:29 -0500
Subject: Re: [PATCH v2 5/6] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296575996.5081.20.camel@mothafucka.localdomain>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-6-git-send-email-glommer@redhat.com>
	 <1296473120.15234.375.camel@laptop>
	 <1296575996.5081.20.camel@mothafucka.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 17:19:28 +0100
Message-ID: <1296577168.26581.240.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:59 -0200, Glauber Costa wrote:
> 
> Because that part is kvm-specific, and this is scheduler general.
> It seemed cleaner to me to do it this way. But I can do it differently,
> certainly. 

Well, any steal time clock will be hypervisor specific, but if we agree
that anything that enables CONFIG_PARAVIRT_TIME_ACCOUNTING provides a
u64 steal_time_clock(int cpu) function then all should be well, right?

The bit you have in kvm is almost that, except it assumes cpu ==
this_cpu.

You simply cannot rely on the silly tick accounting to drive any clock,
its archaic.



