Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1FIPAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:00:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54834 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab1FIPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:00:08 -0400
Date: Thu, 9 Jun 2011 10:59:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kexec/kdump for Xen - implementation question
Message-ID: <20110609145925.GA26417@dumpdata.com>
References: <20110606160434.GA26021@router-fw-old.local.net-space.pl>
 <1307442566.775.555.camel@zakaz.uk.xensource.com>
 <20110608160445.GA6091@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608160445.GA6091@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DF0DFE6.0057:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 06:04:45PM +0200, Daniel Kiper wrote:
> On Tue, Jun 07, 2011 at 11:29:26AM +0100, Ian Campbell wrote:
> > On Mon, 2011-06-06 at 17:04 +0100, Daniel Kiper wrote:
> > > Hi,
> > >
> > > Currently, I am working on kexec/kdump for Xen with emphasis on dom0
> > > implementation issues. After reviewing relevant Xen Linux Kernel
> > > Ver. 2.6.18 code I realized (as I expected) that original kexec/kdump
> > > in mainline kernel should be extensively amended. Further, after some
> > > discussion with Konrad Rzeszutek Wilk and Ian Campbell it was clear
> > > for me that it could be done in a few diffrent ways. Due to this facts
> > > I decided to establish general implementation details with LKML and
> > > Xen-devel community to avoid extensive code rewrite in case my own
> > > proposal would not be accepted.
> > >
> > > Now I think about four solutions. I will present them in order of my
> > > preference. However, if you have another soultions to that problem
> > > please drop me a line.
> > >
> > > 1) Currently existing kexec/kdump implementation should be amended
> > >    by adding Xen specific code mainly in arch/i386. It should look
> > >    like:
> > >
> > >    void machine_kexec(struct kimage *image)
> > >    {
> > >    #ifdef CONFIG_XEN
> > >       if (xen_initial_domain()) {
> > >         ...
> > > 	Xen specific code
> > > 	...
> > >       }
> > >    #endif
> > >
> > >      ...
> > >      generic kexec/kdump code
> > >      ...
> > >    }
> >
> > This is about the ugliest way to do things and should be avoided.
> 
> I think that in this case it is to some extent. I decided put
> this solution before struct machine_kexec_ops solution because
> this (let say conditional solution) touches only x86 code (and
> if it be required IA-64). struct machine_kexec_ops proposal
> require changes for 8 archs. I am not sure it could be accepted
> by kexec/kdump and relevant archs maintainers quickly. However,

Slowly is in general how LKML works with patches. Once you have
an idea of how you want the callback/structs be set lets
email the maintainer of the kexec to get his feedback. If he is OK
then I don't think the different arch maintainers will care much
(as long as it has been tested - and that can be done with QEMU).
> I think that struct machine_kexec_ops is better as longterm
> solution.

Sounds like that is the winner then.
