Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938012Ab0CPRef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:34:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53977 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab0CPRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:34:34 -0400
Message-ID: <4B9FC11A.1070507@linux.vnet.ibm.com>
Date: Tue, 16 Mar 2010 12:34:18 -0500
From: Anthony Liguori <aliguori@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Frank Ch. Eigler" <fche@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9F84C0.70706@redhat.com> <20100316133114.GB575@elte.hu> <y0mbpeo1f1y.fsf@fche.csb> <20100316155221.GA19699@elte.hu>
In-Reply-To: <20100316155221.GA19699@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 10:52 AM, Ingo Molnar wrote:
> You are quite mistaken: KVM isnt really a 'random unprivileged application' in
> this context, it is clearly an extension of system/kernel services.
>
> ( Which can be seen from the simple fact that what started the discussion was
>    'how do we get /proc/kallsyms from the guest'. I.e. an extension of the
>    existing host-space /proc/kallsyms was desired. )
>    

Random tools (like perf) should not be able to do what you describe.  
It's a security nightmare.

If it's desirable to have /proc/kallsyms available, we can expose an 
interface in QEMU to provide that.  That can then be plumbed through 
libvirt and QMP.

Then a management tool can use libvirt or QMP to obtain that information 
and interact with the kernel appropriately.

> In that sense the most natural 'extension' would be the solution i mentioned a
> week or two ago: to have a (read only) mount of all guest filesystems, plus a
> channel for profiling/tracing data. That would make symbol parsing easier and
> it's what extends the existing 'host space' abstraction in the most natural
> way.
>
> ( It doesnt even have to be done via the kernel - Qemu could implement that
>    via FUSE for example. )
>    

No way.  The guest has sensitive data and exposing it widely on the host 
is a bad thing to do.  It's a bad interface.  We can expose specific 
information about guests but only through our existing channels which 
are validated through a security infrastructure.

Ultimately, your goal is to keep perf a simple tool with little 
dependencies.  But practically speaking, if you want to add features to 
it, it's going to have to interact with other subsystems in the 
appropriate way.  That means, it's going to need to interact with 
libvirt or QMP.

If you want all applications to expose their data via synthetic file 
systems, then there's always plan9 :-)

Regards,

Anthony Liguori
