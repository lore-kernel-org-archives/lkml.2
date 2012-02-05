Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2BENQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 08:16:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab2BENQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 08:16:43 -0500
Message-ID: <4F2E8136.2060408@redhat.com>
Date: Sun, 05 Feb 2012 15:16:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <20120205093723.GQ23536@redhat.com> <4F2E4F8B.8090504@redhat.com> <20120205095153.GA29265@redhat.com> <4F2E5245.3070400@redhat.com> <20120205105804.GS23536@redhat.com>
In-Reply-To: <20120205105804.GS23536@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 12:58 PM, Gleb Natapov wrote:
> > > > 
> > > Reduced performance is what I mean. Obviously old guests will continue working.
> > 
> > I'm not happy about it either.
> > 
> It is not only about old guests either. In RHEL we pretend to not
> support HPET because when some guests detect it they are accessing
> its mmio frequently for certain workloads. For Linux guests we can
> avoid that by using kvmclock. For Windows guests I hope we will have
> enlightenment timers  + RTC, but what about other guests? *BSD? How often
> they access HPET when it is available? We will probably have to move
> HPET into the kernel if we want to make it usable.

If we have to, we'll do it.

> So what is the criteria for device to be emulated in userspace vs kernelspace
> in new API? Never? What about vhost-net then? Only if a device works in MSI
> mode? This may work for HPET case, but looks like artificial limitation
> since the problem with HPET is not interrupt latency, but mmio space
> access. 

The criteria is, if it's absolutely necessary.

> And BTW, what about enlightenment timers for Windows? Are we going to
> implement them in userspace or kernel?

The kernel.
-- 
error compiling committee.c: too many arguments to function

