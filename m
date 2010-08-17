Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0HQMKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:10:34 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:51029 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0HQMKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:10:32 -0400
X-SpamScore: -38
X-BigFish: VPS-38(zzbb2dK1432N9370J98dN4015L9371Pzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7APT8-02-K64-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Tue, 17 Aug 2010 14:10:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-pm-link-fix; KDE/4.5.0; x86_64; ; )
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008171319.25080.rjw@sisk.pl> <4C6A7281.3030804@gmail.com>
In-Reply-To: <4C6A7281.3030804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-ID: <201008171410.21382.stephan.diestelhorst@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 17 August 2010, 13:29:05 Tejun Heo wrote:
> Hello,
> 
> On 08/17/2010 01:19 PM, Rafael J. Wysocki wrote:
> > Well, I wonder what the real reason for doing the link power management
> > thing at this particular point in the suspend code path is.  It just seems to
> > disable the link power management, but then the controller is put into a
> > low-power state and is reset from scratch during resume, so I'm not quite
> > sure how skipping that code could possibly lead to any problems.
> 
> > Perhaps we could move the link PM manipulation to the prepare stage
> > of suspend?
> 
> Yeah, one possibility is that the devices misbehave if they receive
> LPM commands while suspended.  Does commenting out sd_suspend resolve
> the issue too?

If you want me to test anything... let me know. Since I do not know
much about the ATA code, I do not know what to change where. (A simple
grep for sd_suspend in drivers/ata didn't turn up anything.)

Thanks,
  Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

