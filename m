Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0CVOM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab0CVOM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:12:56 -0400
Date: Mon, 22 Mar 2010 14:01:06 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Avi Kivity <avi@redhat.com>,
       Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, libguestfs@redhat.com
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100322140106.GN23276@amd.home.annexia.org>
References: <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com> <20100321212009.GE30194@elte.hu> <4BA70F9A.8030304@redhat.com> <20100322114824.GF3483@elte.hu> <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com> <20100322123726.GH21874@redhat.com> <20100322125440.GB12475@elte.hu> <20100322130513.GJ21874@redhat.com> <20100322135647.GA14201@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322135647.GA14201@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 02:56:47PM +0100, Ingo Molnar wrote:
> Just curious: any plans to extend this to include live read/write access as 
> well?
>
> I.e. to have the 'agent' (guestfsd) running universally, so that
> tools such as perf and by users could rely on the VFS integration as
> well, not just disaster recovery tools?

Totally.  That's not to say there is a definite plan, but we're very
open to doing this.  We already wrote the daemon in such a way that it
doesn't require the appliance part, but could run inside any existing
guest (we've even ported bits of it to Windoze ...).

The only remaining issue is how access control would be handled.  You
obviously wouldn't want anything in the host that can get access to
the vmchannel socket to start sending destructive write commands into
guests.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
