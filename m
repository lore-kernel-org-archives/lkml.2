Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0HQLVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 07:21:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47418 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab0HQLVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 07:21:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Tue, 17 Aug 2010 13:19:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008171132.56431.stephan.diestelhorst@amd.com> <4C6A6145.7020707@gmail.com>
In-Reply-To: <4C6A6145.7020707@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171319.25080.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 17, 2010, Tejun Heo wrote:
> Hello,
> 
> On 08/17/2010 11:32 AM, Stephan Diestelhorst wrote:
> > Indeed. Like I said, I have similar issues on a another Samsung HDD in
> > an AMD system. I have not yet got around to try the fix there, but I
> > suspect it is the same thing.
> > 
> > I have attached the full /var/log/messages and /var/log/kern.log with
> > multiple suspend-to-ram runs and the last one failing.
> 
> Hmm... are you sure the patch is applied?  There's no debug message
> outputs in the log which the patch added.
> 
> > Would it make sense to add Rafael's workaround upstream, maybe enabling
> > it only for particular platforms / HDDs / with a parameter?
> 
> Yeah, maybe.  The problem is that I'm a bit reluctant to do that for
> all cases as it may cause other obscure failures and we don't know
> whether the problem is controller or device specific at this point,
> so...

Well, I wonder what the real reason for doing the link power management
thing at this particular point in the suspend code path is.  It just seems to
disable the link power management, but then the controller is put into a
low-power state and is reset from scratch during resume, so I'm not quite
sure how skipping that code could possibly lead to any problems.

Perhaps we could move the link PM manipulation to the prepare stage of suspend?

Thanks,
Rafael
