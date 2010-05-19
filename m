Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0ESTCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:02:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0ESTCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:02:33 -0400
Subject: Re: [PATCH 2/2] scheduler: cgroups cpuaccouting: Make cpuusage
 atomic
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Renninger <trenn@suse.de>
Cc: mike@android.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       menage@google.com, containers@lists.linux-foundation.org, mingo@elte.hu
In-Reply-To: <1274295539-7798-3-git-send-email-trenn@suse.de>
References: <1274264877.5605.10541.camel@twins>
	 <1274295539-7798-3-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 21:02:23 +0200
Message-ID: <1274295743.1674.1545.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 20:58 +0200, Thomas Renninger wrote:
> and avoid locking on 32 bit.
> This resolves an ugly dependency in cgroups_cpuaccount.c
> to per_cpu runqueues lock variable.

While I totally agree with the sentiments here, atomic64_t isn't
available on all 32bit archs and is _terribly_ expensive on ARCH=i386.


