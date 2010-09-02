Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0IBURm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:17:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab0IBURk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:17:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: skip EH autopsy and recovery during suspend
Date: Thu, 2 Sep 2010 22:16:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C7F6931.4050707@gmail.com> <4C7F7649.3010409@gmail.com>
In-Reply-To: <4C7F7649.3010409@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009022216.45303.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010, Tejun Heo wrote:
> For some mysterious reason, certain hardware reacts badly to usual EH
> actions while the system is going for suspend.  As the devices won't
> be needed until the system is resumed, ask EH to skip usual autopsy
> and recovery and proceed directly to suspend.

Putting the issue at hand aside, I'm not really sure if using SCSI EH for
suspending the controller is a good idea.  It seems overly complicated and
it doesn't match the new PCI suspend model with separate ->suspend(),
->freeze() and ->poweroff() callbacks.  Moreover, the passing of pm_message_t
back and forth doesn't make things clear either.

Would it be possible to rework this thing entirely at one point?

Rafael
