Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759Ab2CNKqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab2CNKqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:46:17 -0400
Date: Wed, 14 Mar 2012 12:46:08 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120314104608.GU2304@redhat.com>
References: <4F5DBC26.7060204@cn.fujitsu.com>
 <4F5DD0FD.9070904@redhat.com>
 <20120313091843.GB3800@redhat.com>
 <4F5F25BF.7060100@redhat.com>
 <4F6056FE.3020202@cn.fujitsu.com>
 <4F6063C8.8010005@redhat.com>
 <4F606A7C.9090900@cn.fujitsu.com>
 <4F606DCC.3020908@redhat.com>
 <4F60726E.3090807@cn.fujitsu.com>
 <4F607325.6050607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F607325.6050607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 12:29:57PM +0200, Avi Kivity wrote:
> On 03/14/2012 12:26 PM, Wen Congyang wrote:
> > >> If so, is this channel visible to guest userspace? If the channle is visible to guest
> > >> userspace, the program running in userspace may write the same message to the channel.
> > >>
> > > 
> > > Surely there's some kind of access control on channels.
> >
> > The virtio-serial depends on more things than touching the hypervisor. So I think touching
> > the hypervisor is more reliable than using virtio-serial device, and it is very simple and
> > easy to use.
> >
> > If we pass something from guest userspace to host, we can use virtio-serial. But If we pass
> > something from guest kernelspace to host, I still prefer to touch the hypervisor.
> 
> There's no argument that it's easier.  My concern is different, we're
> adding more and more stuff to the hypervisor because it's easier, which
> bloats it.  Every time we do it we add to compatibility and security
> problems.
> 
> The panic notification is *really* simple, so I don't expect it to cause
> a lot of problems.  But still, if it's possible not to change the
> hypervisor, we must make an effort in that direction.
> 
One more point against using virtio-serial is that it will be likely
compiled as a module which means panic during early boot will not be
reported.

--
			Gleb.
