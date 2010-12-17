Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0LQSCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:02:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab0LQSCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:02:53 -0500
Date: Fri, 17 Dec 2010 13:02:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai <yinghai@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101217180242.GB12425@redhat.com>
References: <20101213100848.GA2237@redhat.com>
 <4D0663F0.2060103@kernel.org>
 <4D06783C.6040009@zytor.com>
 <20101214224135.GB19693@redhat.com>
 <20101215103954.GA2243@redhat.com>
 <4D09958D.2040907@kernel.org>
 <4D0AD976.3020504@zytor.com>
 <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org>
 <20101217170146.GC9568@redhat.com>
 <4D0BA45A.7020402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0BA45A.7020402@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 09:56:42AM -0800, H. Peter Anvin wrote:
> On 12/17/2010 09:01 AM, Vivek Goyal wrote:
> > On Thu, Dec 16, 2010 at 07:58:48PM -0800, Yinghai wrote:
> >> Please don't do that to 64 bit
> >>
> >> My big system with 1024g memory and a lot of cards with rhel 6 to make kdump work must have crashkernel=512m and second kernel need to take pci=nomsi
> >>
> > 
> > I agree here that we should not do it for 64 bit.
> > 
> > - Just because we need it for 32 bit does not mean we should limit it for
> >   64bit. And we do want to have the capability to boot the kernel from as
> >   high memory as possible so creating another aritificial limit is counter
> >   to that.
> > 
> > - I would not worry too much about backward compatibility and allow
> >   booting 32bit kernel till 768MB. The reason being that most of the
> >   distros use same kernel for crash dumping as regular kernel. Maintainig
> >   two separate kernels is big hassle.
> > 
> >   So a small set of people who run into issue, would need to change kernel
> >   command line "crashkernel=128M@64M" or something similar.
> > 
> 
> Do we have actual testing for how high the 64-bit kernel will load?

I will do some experiments on my box today and let you know.


>I'm assuming that the usage of a 32-bit kdump kernel for a 64-bit main
> kernel is nonexistent.

In the past I have run into 1-2 folks who were using 32bit kdump kernel
on 64bit main. But again for those, the workaround is to specify the
different crashkernel= syntax and explicityly specify where to reserve
memory.

Thanks
Vivek
