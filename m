Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab0DSBdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 21:33:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:34772 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab0DSBdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 21:33:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,233,1270450800"; 
   d="scan'208";a="790470489"
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: "vatsa@in.ibm.com" <vatsa@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Srivatsa Vaddagiri <vatsa.ml@gmail.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "Yang, Xiaowei" <xiaowei.yang@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>, "Li, Xin" <xin.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Apr 2010 09:32:12 +0800
Subject: RE: VM performance issue in KVM guests.
Thread-Topic: VM performance issue in KVM guests.
Thread-Index: Acrcus1jW65uZu+eQe6RkvRYk4Yi9ACoxykQAACNDoA=
Message-ID: <BC00F5384FCFC9499AF06F92E8B78A9E026FAC6185@shsmsx502.ccr.corp.intel.com>
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com>
 <4BC0D125.9050108@redhat.com>
 <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com>
 <4BC2C07B.4040607@redhat.com>
 <p2o2eae271004142158xaa5da968ueff0c2afe6894f9d@mail.gmail.com>
 <4BC6CBE3.8020207@redhat.com> <1271338398.1674.13.camel@laptop>
 <20100415164313.GF9128@linux.vnet.ibm.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> On Thu, Apr 15, 2010 at 03:33:18PM +0200, Peter Zijlstra wrote:
>> On Thu, 2010-04-15 at 11:18 +0300, Avi Kivity wrote:
>>> 
>>> Certainly that has even greater potential for Linux guests.  Note
>>> that we spin on mutexes now, so we need to prevent preemption while
>>> the lock owner is running.
>> 
>> either that, or disable spinning on (para) virt kernels. Para virt
>> kernels could possibly extend the thing by also checking to see if
>> the owner's vcpu is running.
> 
> I suspect we will need a combination of both approaches, given that
> we will not be able to avoid preempting guests in their critical
> section always (too long critical sections or real-time tasks wanting
> to preempt). Other idea is to gang-schedule VCPUs of the same guest
> as much as possible? 
Gang-scheduling maybe the ideal solution to solve the issue, and has to change host's scheduler a lot to implement it, and it maybe hard to be upstream.  So can we figure out an easy way(maybe not best) for this ? 
Xiantao
