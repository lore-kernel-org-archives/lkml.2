Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627Ab2CNKHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760331Ab2CNKHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:07:24 -0400
Message-ID: <4F606DCC.3020908@redhat.com>
Date: Wed, 14 Mar 2012 12:07:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: "Daniel P. Berrange" <berrange@redhat.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F58943E.1050402@redhat.com> <4F595B31.9090301@cn.fujitsu.com> <4F5DBC26.7060204@cn.fujitsu.com> <4F5DD0FD.9070904@redhat.com> <20120313091843.GB3800@redhat.com> <4F5F25BF.7060100@redhat.com> <4F6056FE.3020202@cn.fujitsu.com> <4F6063C8.8010005@redhat.com> <4F606A7C.9090900@cn.fujitsu.com>
In-Reply-To: <4F606A7C.9090900@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 11:53 AM, Wen Congyang wrote:
> At 03/14/2012 05:24 PM, Avi Kivity Wrote:
> > On 03/14/2012 10:29 AM, Wen Congyang wrote:
> >> At 03/13/2012 06:47 PM, Avi Kivity Wrote:
> >>> On 03/13/2012 11:18 AM, Daniel P. Berrange wrote:
> >>>> On Mon, Mar 12, 2012 at 12:33:33PM +0200, Avi Kivity wrote:
> >>>>> On 03/12/2012 11:04 AM, Wen Congyang wrote:
> >>>>>> Do you have any other comments about this patch?
> >>>>>>
> >>>>>
> >>>>> Not really, but I'm not 100% convinced the patch is worthwhile.  It's
> >>>>> likely to only be used by Linux, which has kexec facilities, and you can
> >>>>> put talk to management via virtio-serial and describe the crash in more
> >>>>> details than a simple hypercall.
> >>>>
> >>>> As mentioned before, I don't think virtio-serial is a good fit for this.
> >>>> We want something that is simple & guaranteed always available. Using
> >>>> virtio-serial requires significant setup work on both the host and guest.
> >>>
> >>> So what?  It needs to be done anyway for the guest agent.
> >>>
> >>>> Many management application won't know to make a vioserial device available
> >>>> to all guests they create. 
> >>>
> >>> Then they won't know to deal with the panic event either.
> >>>
> >>>> Most administrators won't even configure kexec,
> >>>> let alone virtio serial on top of it. 
> >>>
> >>> It should be done by the OS vendor, not the individual admin.
> >>>
> >>>> The hypercall requires zero host
> >>>> side config, and zero guest side config, which IMHO is what we need for
> >>>> this feature.
> >>>
> >>> If it was this one feature, yes.  But we keep getting more and more
> >>> features like that and we bloat the hypervisor.  There's a reason we
> >>> have a host-to-guest channel, we should use it.
> >>>
> >>
> >> I donot know how to use virtio-serial.
> > 
> > I don't either, copying Amit.
> > 
> >> I start vm like this:
> >> qemu ...\
> >>    -device virtio-serial \
> >>   -chardev socket,path=/tmp/foo,server,nowait,id=foo \
> >>   -device virtserialport,chardev=foo,name=port1 ...
> >>
> >> You said that there are too many channels. Does it mean /tmp/foo is a channel?
> > 
> > Probably.
>
> Hmm, if we use virtio-serial, the guest kernel writes something into the channel when
> the os is panicked. Is it right?

Right.

> If so, is this channel visible to guest userspace? If the channle is visible to guest
> userspace, the program running in userspace may write the same message to the channel.
>

Surely there's some kind of access control on channels.

-- 
error compiling committee.c: too many arguments to function

