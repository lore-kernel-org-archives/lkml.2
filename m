Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab2KTKJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:09:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32113 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab2KTKJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:09:50 -0500
X-IronPort-AV: E=Sophos;i="4.83,285,1352044800"; 
   d="scan'208";a="6239056"
Date: Tue, 20 Nov 2012 18:09:48 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Wen Congyang <wency@cn.fujitsu.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: Re: [PATCH v11] kvm: notify host when the guest is panicked
Message-ID: <20121120100948.GB17311@localhost.localdomain>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
 <20121031011256.GC12325@amt.cnet>
 <50908354.5070608@cn.fujitsu.com>
 <CA+1xoqdcaeAm05_=rx3h9KHph+j7Ab8vRG_w9yUk7jtn+wHuBg@mail.gmail.com>
 <20121106015835.GA11971@localhost.localdomain>
 <CA+1xoqd60YihExEuSU2qzsyFRXLS=XaeeX9AaMLhPHggfM6V3A@mail.gmail.com>
 <20121113021908.GA8176@amt.cnet>
MIME-Version: 1.0
In-Reply-To: <20121113021908.GA8176@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/20 18:09:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/20 18:09:34,
	Serialize complete at 2012/11/20 18:09:34
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

On Tue, Nov 13, 2012 at 12:19:08AM -0200, Marcelo Tosatti wrote:
> On Fri, Nov 09, 2012 at 03:17:39PM -0500, Sasha Levin wrote:
> > On Mon, Nov 5, 2012 at 8:58 PM, Hu Tao <hutao@cn.fujitsu.com> wrote:
> > > But in the case of panic notification, more dependency means more
> > > chances of failure of panic notification. Say, if we use a virtio device
> > > to do panic notification, then we will fail if: virtio itself has
> > > problems, virtio for some reason can't be deployed(neither built-in or
> > > as a module), or guest doesn't support virtio, etc.
> > 
> > Add polling to your virtio device. If it didn't notify of a panic but
> > taking more than 20 sec to answer your poll request you can assume
> > it's dead.
> > 
> > Actually, just use virtio-serial and something in userspace on the guest.
> 
> They want the guest to stop, so a memory dump can be taken by management
> interface.
> 
> Hu Tao, lets assume port I/O is the preferred method for communication.

Okey.

> Now, the following comments have still not been addressed:
> 
> 1) Lifecycle of the stopped guest and interaction with other stopped
> states in QEMU.

Patch 3 already deals with run state transitions. But in case I'm
missing something, could you be more specific?

> 
> 2) Format of the interface for other architectures (you can choose
> a different KVM supported architecture and write an example).
> 
> 3) Clear/documented management interface for the feature.

It is documented in patch 0: Documentation/virtual/kvm/pv_event.txt.
Does it need to be improved?
