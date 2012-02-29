Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2B2KF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:05:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab2B2KF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:05:56 -0500
Date: Wed, 29 Feb 2012 12:05:50 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
Message-ID: <20120229100550.GF24600@redhat.com>
References: <4F4AF1FB.6000903@cn.fujitsu.com>
 <4F4CB926.6050600@redhat.com>
 <4F4D7F5E.5040202@cn.fujitsu.com>
 <4F4DF4C6.90609@redhat.com>
 <20120229095557.GE24600@redhat.com>
 <4F4DF749.7060507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4DF749.7060507@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:00:41PM +0200, Avi Kivity wrote:
> On 02/29/2012 11:55 AM, Gleb Natapov wrote:
> > > >
> > > 
> > > How about using a virtio-serial channel for this?  You can transfer any
> > > amount of information (including the dump itself).
> > > 
> > Isn't it unreliable after the guest panicked? 
> 
> So is calling hypercalls, or dumping, or writing to the screen.  Of
> course calling a hypercall is simpler and so is more reliable.
> 
Yes, crash can be so severe that it is not even detected by a kernel
itself, so not OOPS message even printed. But in most cases if kernel is
functional enough to print OOPS it is functional enough to call single
hypercall instruction.

> > Having special kdump
> > kernel that transfers dump to a host via virtio-serial channel though
> > sounds interesting. May be that's what you mean.
> 
> Yes.  The "panic, starting dump" signal should be initiated by the
> panicking kernel though, in case the dump fails.
> 
Then panic hypercall sounds like a reasonable solution.

--
			Gleb.
