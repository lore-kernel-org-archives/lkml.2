Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab2B2Kwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:52:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab2B2Kwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:52:44 -0500
Date: Wed, 29 Feb 2012 12:52:35 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
Message-ID: <20120229105235.GH24600@redhat.com>
References: <4F4AF1FB.6000903@cn.fujitsu.com>
 <4F4CB926.6050600@redhat.com>
 <4F4D7F5E.5040202@cn.fujitsu.com>
 <4F4DF4C6.90609@redhat.com>
 <20120229095557.GE24600@redhat.com>
 <4F4DF749.7060507@redhat.com>
 <20120229100550.GF24600@redhat.com>
 <4F4DF913.5030809@redhat.com>
 <20120229104449.GG24600@redhat.com>
 <4F4E0299.9080800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E0299.9080800@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:48:57PM +0200, Avi Kivity wrote:
> On 02/29/2012 12:44 PM, Gleb Natapov wrote:
> > > > > 
> > > > Yes, crash can be so severe that it is not even detected by a kernel
> > > > itself, so not OOPS message even printed. But in most cases if kernel is
> > > > functional enough to print OOPS it is functional enough to call single
> > > > hypercall instruction.
> > > 
> > > Why not print the oops to virtio-serial?  Or even just a regular serial
> > > port?  That's what bare metal does.
> > > 
> > The more interface is complex the more chances it will fail during
> > panic. Regular serial is likely more reliable than virtio-serial.
> > Hypercall is likely more reliable than uart. On serial user can
> > fake panic notification. 
> 
> The serial device is under control of the kernel, so the user can only
> access it if the kernel so allows.
> 
Yes, but if we will hijack UART for panic notification VM user will not
be able to use it for anything else. virtio-serial have many channels,
but AFAIK it does not work at early stages of boot process.

--
			Gleb.
