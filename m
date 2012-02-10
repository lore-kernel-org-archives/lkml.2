Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab2BJPp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:45:59 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:34956 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab2BJPp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:45:57 -0500
Date: Fri, 10 Feb 2012 10:42:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        gregkh@linuxfoundation.org
Subject: Re: [Xen-devel] [PATCH] xen/cpu: Make VCPU hotplug code online CPUs
 properly.
Message-ID: <20120210154255.GA9857@phenom.dumpdata.com>
References: <1328885033-8450-1-git-send-email-konrad.wilk@oracle.com>
 <1328885033-8450-2-git-send-email-konrad.wilk@oracle.com>
 <1328886226.6133.271.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328886226.6133.271.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4F353BB0.004C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 03:03:46PM +0000, Ian Campbell wrote:
> On Fri, 2012-02-10 at 14:43 +0000, Konrad Rzeszutek Wilk wrote:
> > Offlining CPUs works. Onlining does not work anymore and it looks
> > like we were missing a cpu_up() call in the hotplug bring up path.
> 
> Wasn't this a deliberate decision as part of the pvops upstreaming to be
> consistent with native cpu hotplug? After hotplugging a CPU

Ah, hadn't seen that. Thanks for spotting that!

> administrator action is needed to actually online it.
> 
> http://xen.1045712.n5.nabble.com/cpu-down-but-no-cpu-up-in-drivers-xen-cpu-hotplug-c-td2545244.html
> 
> The fix is to add a udev rule:
> http://wiki.xen.org/wiki/Paravirt_Linux_CPU_Hotplug

Ah, so I see that it is run (the udev does it) but it actually does not bring the CPU up.

It looks as if the 'online' attribute is actually not present at all, even
after bringing the CPU "up-but-not-online". Oh joy! Should be easy to reproduce
on baremetal.
