Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0DONdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:33:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:40100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab0DONdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:33:22 -0400
Subject: Re: VM performance issue in KVM guests.
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Srivatsa Vaddagiri <vatsa.ml@gmail.com>,
       "Zhang, Xiantao" <xiantao.zhang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "Yang, Xiaowei" <xiaowei.yang@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>, "Li, Xin" <xin.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vatsa@linux.vnet.ibm.com
In-Reply-To: <4BC6CBE3.8020207@redhat.com>
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com>
	 <4BC0D125.9050108@redhat.com>
	 <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com>
	 <4BC2C07B.4040607@redhat.com>
	 <p2o2eae271004142158xaa5da968ueff0c2afe6894f9d@mail.gmail.com>
	 <4BC6CBE3.8020207@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 15:33:18 +0200
Message-ID: <1271338398.1674.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 11:18 +0300, Avi Kivity wrote:
> 
> Certainly that has even greater potential for Linux guests.  Note that 
> we spin on mutexes now, so we need to prevent preemption while the lock 
> owner is running. 

either that, or disable spinning on (para) virt kernels. Para virt
kernels could possibly extend the thing by also checking to see if the
owner's vcpu is running.

