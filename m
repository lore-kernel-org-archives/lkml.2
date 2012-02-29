Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab2B2Kjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:39:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2B2Kjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:39:42 -0500
Message-ID: <4F4E0061.1050508@redhat.com>
Date: Wed, 29 Feb 2012 12:39:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4CB926.6050600@redhat.com> <4F4D7F5E.5040202@cn.fujitsu.com> <4F4DF4C6.90609@redhat.com> <20120229095557.GE24600@redhat.com> <4F4DF749.7060507@redhat.com> <20120229100550.GF24600@redhat.com> <4F4DF913.5030809@redhat.com> <4F4DFB37.8060208@cn.fujitsu.com>
In-Reply-To: <4F4DFB37.8060208@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 12:17 PM, Wen Congyang wrote:
> >>>
> >> Yes, crash can be so severe that it is not even detected by a kernel
> >> itself, so not OOPS message even printed. But in most cases if kernel is
> >> functional enough to print OOPS it is functional enough to call single
> >> hypercall instruction.
> > 
> > Why not print the oops to virtio-serial?  Or even just a regular serial
> > port?  That's what bare metal does.
>
> If virtio-serial's driver has bug or the guest doesn't have such device...

We have the same issue with the hypercall; and virtio-serial is
available on many deployed versions.

> > 
> >>>> Having special kdump
> >>>> kernel that transfers dump to a host via virtio-serial channel though
> >>>> sounds interesting. May be that's what you mean.
> >>>
> >>> Yes.  The "panic, starting dump" signal should be initiated by the
> >>> panicking kernel though, in case the dump fails.
> >>>
> >> Then panic hypercall sounds like a reasonable solution.
> > 
> > It is, but I'm trying to see if we can get away with doing nothing.
> > 
>
> If we have a reliable way with doing nothing, it is better. But I donot
> find such way.

We won't have a 100% reliable way.  But I think a variant of the driver
that doesn't use interrupts, or just using the ordinary serial driver,
should be reliable enough.

-- 
error compiling committee.c: too many arguments to function

