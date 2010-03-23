Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0CWOGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:06:11 -0400
Received: from 8bytes.org ([88.198.83.132]:48443 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab0CWOGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:06:09 -0400
Date: Tue, 23 Mar 2010 15:06:08 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100323140608.GJ1940@8bytes.org>
References: <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7E9D9.5060800@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 05:06:17PM -0500, Anthony Liguori wrote:
> There always needs to be a system wide entity.  There are two ways to  
> enumerate instances from that system wide entity.  You can centralize  
> the creation of instances and there by maintain an list of current  
> instances.  You can also allow instances to be created in a  
> decentralized manner and provide a standard mechanism for instances to  
> register themselves with the system wide entity.

And this system wide entity is the kvm module. It creates instances of
'struct kvm' and destroys them. I see no problem if we just attach a
name to every instance with a good default value like kvm0, kvm1 ... or
guest0, guest1 ... User-space can override the name if it wants. The kvm
module takes care about the names being unique.
This is very much the same as network card numbering is implemented in
the kernel.
Forcing perf to talk to qemu or even libvirt produces to much overhead
imho. Instrumentation only produces useful results with low overhead.

	Joerg

