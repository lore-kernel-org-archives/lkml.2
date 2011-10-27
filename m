Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1J0PIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:08:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30389 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1J0PIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:08:40 -0400
Date: Thu, 27 Oct 2011 11:08:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: Regression: patch " hvc_console: display printk messages on
 console." causing infinite loop with 3.2-rc0 + Xen.
Message-ID: <20111027150826.GC1157@phenom.dumpdata.com>
References: <20111027053007.GA32765@phenom.dumpdata.com>
 <20111027054806.GA1377@suse.de>
 <CAB8Rdaq2r4Uc-WZK-k=wiEW8DKdixn+9dB7E4_XDL7k8jCMwSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB8Rdaq2r4Uc-WZK-k=wiEW8DKdixn+9dB7E4_XDL7k8jCMwSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4EA973F3.0077:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 07:45:07AM -0700, Miche Baker-Harvey wrote:
> Bummer.  Sorry about that.
> 
> Konrad, could you give me a hand figuring out what's up with this - I'm not
> running Zen here.  (If there's a test suite I could have run, mea culpa, and
> please point me in the right direction.)

I kind of run the nightly build/test rinse & repeat cycle using this:

git://xenbits.xen.org/xentesttools/bootstrap.git

But it might be just easier for you to install Fedora Core 16, do
'yum install xen', reboot, make sure you can boot Xen, and then build
a 3.2 kernel with your patch + debug stuff.

> 
> The "console [hvc0] enabled" message is coming from register_console() in
> printk.c, and it doesn't have any loops.
> It's called from hvc_console_init(), hvc_instantiate(), and hvc_alloc(),
> none of which have loops.  The call in hvc_alloc() is the one I added, so
> either I've inadvertently made one of the other two repeat (I'm guestting
> hvc_instantiate() is the one you're using), or you're infinitely calling
> hvc_alloc().  There's a calls to hvc_alloc() in hvc_xen.c::xen_hvc_init(),
> and in init_port_console() in virtio_console.c, but again, no loops.
>  Similarly for hvc_instantiate().
> 
> So, could I trouble you to put a breakpoint in register_console() and send
> me the stack?

A dump_stack() should suffice I presume? Yeah let me do that.
