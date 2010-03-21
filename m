Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0CUUCX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:02:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0CUUCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:02:22 -0400
Message-ID: <4BA67B2F.4030101@redhat.com>
Date: Sun, 21 Mar 2010 22:01:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA250BF.80704@codemonkey.ws> <20100318162853.GB447@elte.hu> <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu>
In-Reply-To: <20100321191742.GD25922@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 09:17 PM, Ingo Molnar wrote:
>
> Adding any new daemon to an existing guest is a deployment and usability
> nightmare.
>    

The logical conclusion of that is that everything should be built into 
the kernel.  Where a failure brings the system down or worse.  Where you 
have to bear the memory footprint whether you ever use the functionality 
or not.  Where to update the functionality you need to deploy a new 
kernel (possibly introducing unrelated bugs) and reboot.

If userspace daemons are such a deployment and usability nightmare, 
maybe we should fix that instead.

> The basic rule of good instrumentation is to be transparent. The moment we
> have to modify the user-space of a guest just to monitor it, the purpose of
> transparent instrumentation is defeated.
>    

You have to modify the guest anyway by deploying a new kernel.

> Please try think with the heads of our users and developers and dont suggest
> some weird ivory-tower design that is totally impractical ...
>    

inetd.d style 'drop a listener config here and it will be executed on 
connection' should work.  The listener could come with the kernel 
package, though I don't think it's a good idea.  module-init-tools 
doesn't and people have survived somehow.

> And no, you have to code none of this, we'll do all the coding. The only thing
> we are asking is for you to not stand in the way of good usability ...
>    

Thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

