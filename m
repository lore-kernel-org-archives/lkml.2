Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2BFQSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:18:43 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:57501 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab2BFQSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:18:40 -0500
Date: Mon, 6 Feb 2012 17:18:02 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, bp@amd64.org,
        tony.luck@intel.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcos.mage@gmail.com,
        prasad@linux.vnet.ibm.com
Subject: Re: [PATCH] x86, mce: Fix rcu splat in drain_mce_log_buffer()
Message-ID: <20120206161802.GC31237@aftab>
References: <20120111142213.16610.85866.stgit@srivatsabhat.in.ibm.com>
 <20120111161153.GA2925@linux.vnet.ibm.com>
 <4F102353.1040109@linux.vnet.ibm.com>
 <20120113214435.GC2909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113214435.GC2909@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 01:44:35PM -0800, Paul E. McKenney wrote:
> Looks good to me, but I do need to defer to people who know this code
> better than do I.  The key thing that (from what I can see) makes
> rcu_dereference() unnecessary is that the smp_rmb() used in conjunction
> with polling the .finished field takes care of ordering.

Right, this was me trying hard not to screw up touching mcelog.next,
thus trying to use the rcu_dereference_index_check() primitive without
thinking it through too much. But you're right, I'm polling the
->finished field 4 times (totally arbitrary, btw) which should suffice
while the mce_log() routine above writes those entries.

Although, the question still remains, since mce_log() accesses
mcelog.next through the rcu_dereference_index_check() primitive,
shouldn't I do it the same way?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
