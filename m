Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab0LaKFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:05:05 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44174 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751509Ab0LaKFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:05:03 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+FAKZz0HaF3PLkqQu9qhPQzR9XDGwLURrNxj7bBk
	+eco/+leUM+HhB
Subject: Re: [PATCH] sched, cgroup: Use exit hook to avoid use-after-free
 crash
From: Mike Galbraith <efault@gmx.de>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <20101229230744.GA10557@genesis.frugalware.org>
References: <1293106330.2170.618.camel@laptop>
	 <1293107624.2170.642.camel@laptop> <1293128670.2170.748.camel@laptop>
	 <1293132304.6798.6.camel@marge.simson.net>
	 <1293132862.25981.22.camel@laptop>
	 <1293187425.7138.2.camel@marge.simson.net>
	 <1293188091.25981.200.camel@laptop>
	 <1293192999.18035.4.camel@marge.simson.net>
	 <1293206353.29444.205.camel@laptop> <20101229152522.GA23825@elte.hu>
	 <20101229230744.GA10557@genesis.frugalware.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 11:04:19 +0100
Message-ID: <1293789859.6839.97.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 00:07 +0100, Miklos Vajna wrote:
> On Wed, Dec 29, 2010 at 04:25:22PM +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > I tried this patch, but it causes a boot crash:
> 
> Hm, indeed. (I get a crash in qemu, but not on the host machine.)
> 
> qemu -enable-kvm -kernel kernel-build/arch/x86/boot/bzImage  -append "root=/dev/sda1 debug sched_debug ignore_loglevel sysrq_always_enabled console=ttyS0 init=/bin/systemd" -hda systemd.img -serial stdio -m 1G -vnc :0
> 
> does not crash here, but
> 
> qemu -enable-kvm -kernel kernel-build/arch/x86/boot/bzImage  -append "root=/dev/sda1 debug sched_debug ignore_loglevel sysrq_always_enabled console=ttyS0" -hda systemd.img -serial stdio -m 1G -vnc :0
> 
> does.
> 
> I'm attaching the config (what I already sent earlier in this thread)
> and the output of the above two commands just in case that helps Peter.

Your crash seems to be completely independent of Peter's patch.  It
crashes here with your image/config/2.6.36 here regardless, and not 100%
repeatably.  Sometimes it boots, sometimes not.

	-Mike


