Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0FIKIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:08:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab0FIKIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:08:51 -0400
Subject: Re: [RFC] para virt interface of perf to support kvm guest os
 statistics collection in guest os
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
In-Reply-To: <4C0F61D3.9000402@redhat.com>
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
	 <4C0F51DD.3080200@redhat.com>
	 <1276075280.2096.427.camel@ymzhang.sh.intel.com>
	 <4C0F61D3.9000402@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Jun 2010 12:08:42 +0200
Message-ID: <1276078122.2046.1227.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 12:41 +0300, Avi Kivity wrote:
> 
> >> Disabling the watchdog is unfortunate.  Why is it necessary?
> >>      
> > perf always uses NMI, so we disable the nmi_watchdog when a perf_event is
> > set up in case they might have impact.
> >    
> 
> Ok.  Is that the case for the hardware pmus as well?  If so it might be 
> done in common code. 

The x86 hardware pmu implementation disables the lapic watchdog too, but
recent kernels come with a watchdog implementation on top of perf, the
old lapic one will be depricated.


