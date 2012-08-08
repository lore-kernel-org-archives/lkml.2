Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2HHHJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:09:56 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:11800
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526Ab2HHHJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:09:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Wed, 8 Aug 2012 15:11:26 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Kumar Gala <galak@kernel.crashing.org>, <rjw@sisk.pl>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH 3/4] cpu: export cpu hotplug disable/enable functions as
 global functions
Message-ID: <20120808071125.GA31389@localhost.localdomain>
References: <1344329006-10645-1-git-send-email-chenhui.zhao@freescale.com>
 <1344329006-10645-3-git-send-email-chenhui.zhao@freescale.com>
 <B4FC7F5E-EA8F-4FCA-B206-353FE4481DCE@kernel.crashing.org>
 <50220382.4010405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50220382.4010405@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 11:43:22AM +0530, Srivatsa S. Bhat wrote:
> On 08/07/2012 11:21 PM, Kumar Gala wrote:
> > 
> > On Aug 7, 2012, at 3:43 AM, Zhao Chenhui wrote:
> > 
> >> The cpufreq driver of mpc85xx will disable/enable cpu hotplug temporarily.
> >> Therefore, the related functions should be exported.
> >>
> >> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> >> ---
> >> include/linux/cpu.h |    4 ++++
> >> 1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > Rafael, Srivatsa,
> > 
> > Wanted to get your ack on export these functions for direct calling by arch code.
> >
> 
> Why not just use get_online_cpus()/put_online_cpus()?
> 
> In the case of suspend/resume/hibernation, we had introduced these CPU hotplug disable
> functions because we would end up doing CPU hotplug ourselves, further down the path.
> So if we did a get_online_cpus(), we would end up deadlocking ourselves. Whereas, the
> patch 4/4 looks like a straightforward case of wanting to simply disable CPU hotplug..
> I don't see where you are doing CPU hotplug yourself in the path. So IMO, just
> get/put_online_cpus() should do.
> 
> Regards,
> Srivatsa S. Bhat
> 

Thanks for your comment. I will try to use get/put_online_cpus() in my patch.

-Chenhui

