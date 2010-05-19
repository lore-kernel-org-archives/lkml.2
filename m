Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0ESTNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:13:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:39055 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab0ESTNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:13:43 -0400
From: Thomas Renninger <trenn@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] scheduler: cgroups cpuaccouting: Make cpuusage atomic
Date: Wed, 19 May 2010 21:13:51 +0200
User-Agent: KMail/1.9.10
Cc: mike@android.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       menage@google.com, containers@lists.linux-foundation.org, mingo@elte.hu
References: <1274264877.5605.10541.camel@twins> <1274295539-7798-3-git-send-email-trenn@suse.de> <1274295743.1674.1545.camel@laptop>
In-Reply-To: <1274295743.1674.1545.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005192113.52535.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 May 2010 09:02:23 pm Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 20:58 +0200, Thomas Renninger wrote:
> > and avoid locking on 32 bit.
> > This resolves an ugly dependency in cgroups_cpuaccount.c
> > to per_cpu runqueues lock variable.
>
> While I totally agree with the sentiments here, atomic64_t isn't
> available on all 32bit archs and is _terribly_ expensive on ARCH=i386.
Speed on i386 shouldn't count that much here.
Big machines run x86_64 and cgroup cpu accounting doesn't make much
sense on old i386 single core machines.

Would still be great to see the first patch go in then.
The idea of splitting was to:
  a) show the real change
  b) make at least the first go in if the snd does not work out

Thanks,

     Thomas
