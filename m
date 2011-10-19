Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1JSHvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:51:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:54616 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1JSHvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:51:20 -0400
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>
Date: Wed, 19 Oct 2011 09:50:59 +0200
In-Reply-To: <alpine.DEB.2.00.1110181336150.2639@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <1318925436.9641.23.camel@marge.simson.net>
	 <1318927355.21167.3.camel@twins>
	 <1318927629.9641.27.camel@marge.simson.net>
	 <1318928763.21167.5.camel@twins>
	 <1318929825.9641.32.camel@marge.simson.net>
	 <1318932693.6748.5.camel@marge.simson.net>
	 <alpine.DEB.2.00.1110181336150.2639@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1319010659.29774.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 13:38 -0700, David Rientjes wrote:
> 
> Eek, this seems like complete overkill, there may be cgroups now or in the 
> future that it would be perfectly acceptable to move kthreadd into without 
> any negative effects.  There's no reason to restrict it this broadly, 
> that's why I thought your change to cpusets was fine and acked it.  It's 
> the perfect candidate for what the ->can_attach() pointer for a cgroup can 
> identify is problematic for _that_ cgroup. 

My thinking is that kthreadd is the mother of all kernel threads and the
kernel assumes it can spawn kthreads without constraints, a valid
assumption IMO.

Therefore the kthreadd thread should live in the root cgroup at all
times, irrespective of whatever controllers are or aren't actually safe.


