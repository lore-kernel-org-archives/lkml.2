Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0CXPuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:50:44 -0400
Received: from 8bytes.org ([88.198.83.132]:58086 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab0CXPum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:50:42 -0400
Date: Wed, 24 Mar 2010 16:50:41 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100324155041.GH14800@8bytes.org>
References: <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org> <20100324152653.GA12225@redhat.com> <20100324153746.GF14800@8bytes.org> <4BAA3323.9000405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA3323.9000405@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 05:43:31PM +0200, Avi Kivity wrote:
> On 03/24/2010 05:37 PM, Joerg Roedel wrote:
>> Even better. So a guest which breaks out can't even access its own
>> /sys/kvm/ directory. Perfect, it doesn't need that access anyway.
>
> But what security label does that directory have?  How can we make sure  
> that whoever needs access to those files, gets them?
>
> Automatically created objects don't work well with that model.  They're  
> simply missing information.

If we go the /proc/<pid>/kvm way then the directory should probably
inherit the label from /proc/<pid>/?
Same could be applied to /sys/kvm/guest/ if we decide for it. The VM is
still bound to a single process with a /proc/<pid> after all.

	Joerg

