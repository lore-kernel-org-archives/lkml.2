Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0HXQWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:22:38 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:25429 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab0HXQWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:22:37 -0400
X-SpamScore: -45
X-BigFish: VPS-45(zzbb2dK1432N1a09M9370J98dN179dN9371P103dK853kzz1202hzz15d4Rz32i2a8h)
X-WSS-ID: 0L7NZHT-02-U9M-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Tue, 24 Aug 2010 18:07:23 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-22-generic; KDE/4.4.2; x86_64; ; )
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008191823.57915.stephan.diestelhorst@amd.com> <4C72639C.6090108@gmail.com>
In-Reply-To: <4C72639C.6090108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <201008241807.23519.stephan.diestelhorst@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 August 2010 14:03:40 Tejun Heo wrote:
> On 08/19/2010 06:23 PM, Stephan Diestelhorst wrote:
> > It says "max_performance", I have not touched anyhting. So it has been
> > like that all the time. Would this explain why your patch did not show
> > the debug printout?
> 
> Hmm... okay.  Yeah, if you haven't been using IPM at all, there won't
> be any debug messages but at the same time the posted patch should
> have had the same effect as Rafael's patch as IPM path isn't traveled
> at all.  Can you please check the followings?
> 
> * You're actually running the correct patched kernel and modules.  It
>   probably is a good idea to add a printk message.  ie. Apply the
>   patch and add a printk() in ata_host_request_pm() in libata-core.c
>   and make sure the debug messages appears.

Did that. Actually also added some printks to the XXX function, called
early during boot. Output confirms that your patch is loaded. And even
on the first resume the machine dies.

> * Rafael's patch actually fixes the problem.  If you haven't been
>   using IPM at all, Rafael's patch and mine should behave exactly the
>   same (ie. no IPM operation at all during suspend/resume).  It could
>   be that you're seeing a different issue.

That next on my list...

Many thanks!

Stephan

-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

