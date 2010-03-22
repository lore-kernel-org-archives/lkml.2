Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0CVSlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:41:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:21062 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab0CVSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:41:45 -0400
Message-ID: <4BA7B9E0.5080009@codemonkey.ws>
Date: Mon, 22 Mar 2010 13:41:36 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100322111411.GC3483@elte.hu> <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu>
In-Reply-To: <20100322173400.GB15795@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 12:34 PM, Ingo Molnar wrote:
> This is really just the much-discredited microkernel approach for keeping
> global enumeration data that should be kept by the kernel ...
>
> Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by Anthony.
> There's numerous ways that this can break:
>
>   - Those special files can get corrupted, mis-setup, get out of sync, or can
>     be hard to discover.
>
>   - The ${HOME}/.qemu/qmp/ solution suggested by Anthony has a very obvious
>     design flaw: it is per user. When i'm root i'd like to query _all_ current
>     guest images, not just the ones started by root. A system might not even
>     have a notion of '${HOME}'.
>
>   - Apps might start KVM vcpu instances without adhering to the
>     ${HOME}/.qemu/qmp/ access method.
>
>   - There is no guarantee for the Qemu process to reply to a request - while
>     the kernel can always guarantee an enumeration result. I dont want 'perf
>     kvm' to hang or misbehave just because Qemu has hung.
>    

If your position basically boils down to, we can't trust userspace and 
we can always trust the kernel, I want to eliminate any userspace path, 
then I can't really help you out.

I believe we can come up with an infrastructure that satisfies your 
actual requirements within qemu but if you're also insisting upon the 
above implementation detail then there's nothing I can do.

Regards,

Anthony Liguori

