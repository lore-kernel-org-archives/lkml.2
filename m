Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938227Ab0CPRxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:53:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60532 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938186Ab0CPRxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:53:09 -0400
Date: Tue, 16 Mar 2010 18:52:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <aliguori@linux.vnet.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100316175243.GC23859@elte.hu>
References: <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9F84C0.70706@redhat.com>
 <20100316133114.GB575@elte.hu>
 <y0mbpeo1f1y.fsf@fche.csb>
 <20100316155221.GA19699@elte.hu>
 <4B9FC11A.1070507@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9FC11A.1070507@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anthony Liguori <aliguori@linux.vnet.ibm.com> wrote:

> On 03/16/2010 10:52 AM, Ingo Molnar wrote:
> >You are quite mistaken: KVM isnt really a 'random unprivileged application' in
> >this context, it is clearly an extension of system/kernel services.
> >
> >( Which can be seen from the simple fact that what started the discussion was
> >   'how do we get /proc/kallsyms from the guest'. I.e. an extension of the
> >   existing host-space /proc/kallsyms was desired. )
> 
> Random tools (like perf) should not be able to do what you describe. It's a 
> security nightmare.

A security nightmare exactly how? Mind to go into details as i dont understand 
your point.

> If it's desirable to have /proc/kallsyms available, we can expose an 
> interface in QEMU to provide that.  That can then be plumbed through libvirt 
> and QMP.
> 
> Then a management tool can use libvirt or QMP to obtain that information and 
> interact with the kernel appropriately.
> 
> > In that sense the most natural 'extension' would be the solution i 
> > mentioned a week or two ago: to have a (read only) mount of all guest 
> > filesystems, plus a channel for profiling/tracing data. That would make 
> > symbol parsing easier and it's what extends the existing 'host space' 
> > abstraction in the most natural way.
> >
> > ( It doesnt even have to be done via the kernel - Qemu could implement that
> >   via FUSE for example. )
> 
> No way.  The guest has sensitive data and exposing it widely on the host is 
> a bad thing to do. [...]

Firstly, you are putting words into my mouth, as i said nothing about 
'exposing it widely'. I suggest exposing it under the privileges of whoever 
has access to the guest image.

Secondly, regarding confidentiality, and this is guest security 101: whoever 
can access the image on the host _already_ has access to all the guest data!

A Linux image can generally be loopback mounted straight away:

  losetup -o 32256 /dev/loop0 ./guest-image.img
  mount -o ro /dev/loop0 /mnt-guest

(Or, if you are an unprivileged user who cannot mount, it can be read via ext2 
tools.)

There's nothing the guest can do about that. The host is in total control of 
guest image data for heaven's sake!

All i'm suggesting is to make what is already possible more convenient.

	Ingo
