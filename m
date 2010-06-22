Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab0FVKKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 06:10:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0FVKKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 06:10:47 -0400
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com
In-Reply-To: <4C208B09.9030003@redhat.com>
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>
	 <4C1F50D0.70205@redhat.com>
	 <1277171344.2096.567.camel@ymzhang.sh.intel.com>
	 <4C2062D8.20609@redhat.com>
	 <1277192873.2096.690.camel@ymzhang.sh.intel.com>
	 <1277193305.1875.537.camel@laptop>  <4C206D8B.4080105@redhat.com>
	 <1277198943.2096.724.camel@ymzhang.sh.intel.com>
	 <1277199060.1875.675.camel@laptop>  <4C2084BB.3040501@redhat.com>
	 <1277200010.1875.692.camel@laptop>  <4C20882C.80709@redhat.com>
	 <1277200942.1875.694.camel@laptop>  <4C208B09.9030003@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Jun 2010 12:10:28 +0200
Message-ID: <1277201428.1875.696.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 13:06 +0300, Avi Kivity wrote:

> You have a set of MSRs for real hardware (actually several sets) 
> discoverable by cpuid bits.  You have another set of MSRs, using other 
> indexes, discoverable by more CPUID bits.
> 
> The new MSR indexes will always #GP on real hardware, but will be 
> trapped and serviced by kvm.  In effect kvm will pretend to have a 
> hardware-like PMU but done according to its own specifications.

So what's the point? I thought the whole MSR interface thing was purely
to let other-o$ play with the PMU, but if you move it around like that
and make it KVM specific, nobody will find it...
