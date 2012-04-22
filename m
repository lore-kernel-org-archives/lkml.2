Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2DVKd6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 06:33:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab2DVKd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 06:33:57 -0400
Date: Sun, 22 Apr 2012 13:33:40 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, dzickus@redhat.com,
        luto@mit.edu, gregkh@suse.de, kvm@vger.kernel.org,
        joerg.roedel@amd.com, mtosatti@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com,
        ludwig.nussel@suse.de
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
Message-ID: <20120422103340.GE12768@redhat.com>
References: <4F8FF7AC.1060309@redhat.com>
 <20120419.210119.246504497.d.hatayama@jp.fujitsu.com>
 <4F900020.5010702@redhat.com>
 <20120420.191133.488341439.d.hatayama@jp.fujitsu.com>
 <4F93D64B.50803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F93D64B.50803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 12:58:35PM +0300, Avi Kivity wrote:
> On 04/20/2012 01:11 PM, HATAYAMA Daisuke wrote:
> > From: Avi Kivity <avi@redhat.com>
> > Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information for kdump
> > Date: Thu, 19 Apr 2012 15:08:00 +0300
> >
> > > On 04/19/2012 03:01 PM, HATAYAMA Daisuke wrote:
> > >> >> It would be not helpful for the qemu crash case you are concerned
> > >> >> about. We want to use the guest state data to look into guest
> > >> >> machine's image in the crasshed qemu.
> > >> > 
> > >> > Why?
> > >> > 
> > >>
> > >> It seems natural to check the situation from guest machine's side when
> > >> qemu crashs. Suppose a service is running on the guest machine, and
> > >> then the qemu crash. Then, we may need to know the details of the
> > >> progress of the service if it's important. What has been successfully
> > >> done, and what has not yet.
> > > 
> > > How can a service on the guest be related to a qemu crash?  And how
> > > would guest registers help?
> >
> > I don't mean the service is related to qemu's crash. When qemu
> > crashes, then the guest machine also crashes (although it doesn't
> > notice anything). What I'm interested in here is guest machine side,
> > not qemu side. I want to debug guest machine, not qemu.
> 
> There is no bug in the guest, so why debug it?
> 
> It's similar to pulling out the power from a server and wanting to
> inspect the registers and memory at the time the cpu died.  Even if it's
> possible, you don't gain any information from it.
> 
> > > 
> > > You can extract the list of running processes from a qemu crash dump
> > > without looking at guest registers.  And most vcpus are running
> > > asynchronously to qemu, so their register contents is irrelevant (if a
> > > vcpu is running synchronously with qemu - it just exited to qemu and is
> > > waiting for a response - then you'd see the details in qemu's call stack).
> > > 
> >
> > Just as you say, we can refer to guest machine's memory without guest
> > registers.
> >
> > The definitely necessary data in vmcs are RSP and RIP, which are not
> > saved in anywhare of kvm module. The two registers are needed for back
> > tracing to determine what processsing is being done on the guest
> > machine at qemu crash.
> 
> What I don't understand is why you are interested in the guest machine
> at all, if it was qemu that crashed.
> 
It would be interesting to extract enough information from the core to be
able to restart the guest from the point where qemu crashed, but
decoding VMCS is not enough for that.

--
			Gleb.
