Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1DRO0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:26:04 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:31688 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754592Ab1DROZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:25:57 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: mK6DtusVM1kLigbPC3KzXs.SDeKs5hu0jY3fF0gQchBGmkY
 X.dncroIntVgjStoqWwtqV8G.sVC9hxL02GLBSAbMd1zs2v0VXVfHCCRVrx2
 NotGPGWJmub_2QrFUKfpV6fiD5WyAxZUX_imzK8.HhfK0k3hpcNjcB0pwspw
 xEzgx3G7ryUM6UPMrXaKtBHYy2YARI7lw6mxW9iXb1x7BebRZGowv1o_rpsV
 j1NkiiFRB_ZQDTJf4M95XOHVaOJPzliZwdHuD.VJR8Z72McTeh4ab1my5xXy
 SPMsGu_1iGi9eurfirLzl5fLCW.wAZYukHL0K_3DINa62or_5
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 18 Apr 2011 09:25:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Shaohua Li <shaohua.li@intel.com>
cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch v3 3/3] percpu_counter: use atomic64 for counter in SMP
In-Reply-To: <1303112625.3981.191.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1104180923530.23207@router.home>
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>  <20110414020747.411215973@sli10-conroe.sh.intel.com>  <20110415041506.GC29512@mtj.dyndns.org> <1303112625.3981.191.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011, Shaohua Li wrote:

> > Disabling preemption here doesn't make any sense.
> > percpu_counter_set() inherently requires its users to guarantee that
> > no other user is modifying the percpu counter.
> ha, ok.
> should I still rebase the patch against Christoph's patch? Looks that
> one is still not settled down.

I am a kind of confused about some of the arguments made there right now
and having your patch in that does the conversion to atomic would
simplify my patch (removes the spin_lock/unlock sequence in overflow
handling).


