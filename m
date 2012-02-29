Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab2B2KrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:47:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab2B2KrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:47:06 -0500
Message-ID: <4F4E021F.80206@redhat.com>
Date: Wed, 29 Feb 2012 12:46:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: "Daniel P. Berrange" <berrange@redhat.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4CB926.6050600@redhat.com> <4F4D7F5E.5040202@cn.fujitsu.com> <4F4DF4C6.90609@redhat.com> <20120229095842.GF5050@redhat.com> <4F4DF86C.5010407@redhat.com> <4F4DFE7C.3030501@cn.fujitsu.com>
In-Reply-To: <4F4DFE7C.3030501@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 12:31 PM, Wen Congyang wrote:
> At 02/29/2012 06:05 PM, Avi Kivity Wrote:
> > On 02/29/2012 11:58 AM, Daniel P. Berrange wrote:
> >>>
> >>> How about using a virtio-serial channel for this?  You can transfer any
> >>> amount of information (including the dump itself).
> >>
> >> When the guest OS has crashed, any dumps will be done from the host
> >> OS using libvirt's core dump mechanism. The guest OS isn't involved
> >> and is likely too dead to be of any use anyway. Likewise it is
> >> quite probably too dead to work a virtio-serial channel or any
> >> similarly complex device. We're really just after the simplest
> >> possible notification that the guest kernel has paniced.
> > 
> > If it's alive enough to panic, it's alive enough to kexec its kdump
> > kernel.  After that it can do anything.
> > 
> > Guest-internal dumps are more useful IMO that host-initiated dumps.  In
>
> Yes, guest-internal dump is better than host dump. But the user may not
> start guest-internal dump or guest-internal dump failed. So we need the
> following feature:
> 1. If the guest-internal dump does not work, the guest's status is 'crashed'.
>    And then the user does the host dump.
> 2. If the guest-internal dump is working, the guest's status should be
>    'dumping'. The user see this status and know the guest has paniced, and
>     the guest-internal dump is working.

I agree.  There is room for host dump, and we do want notification about
what the guest is doing.  The question is whether we should reuse
virtio-serial for guest-host communication in this case.  It's more
complicated, but allows us to avoid touching the hypervisor.

-- 
error compiling committee.c: too many arguments to function

