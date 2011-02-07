Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035Ab1BGJfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 04:35:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab1BGJft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 04:35:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>
Subject: Re: [PATCH 0/2] Fix hangup after creating checkpoint on Xen.
Date: Mon, 7 Feb 2011 10:35:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, xen-devel@lists.xensource.com,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
References: <20110207.180718.885783824287845425.kaz@jp.fujitsu.com>
In-Reply-To: <20110207.180718.885783824287845425.kaz@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071035.29922.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 07, 2011, SUZUKI, Kazuhiro wrote:
> Hi,

Hi,

> The following patch series fixes hangup after creating checkpoint on
> Xen. The Linux Xen guest can be saved the state to restore later, and
> also created snapshot like checkpoint via the hypervisor.
> But, when the snapshot is created for the PV guest, it will hangup.
> 
> We added 'PMSG_CANCEL' message and 'cancel' handler in dev_pm_ops
> struct in the pm-linux part.

Please don't do that, unless you can convince me there's no other way to fix
the problem you're trying to address.

In my opinion it's highly unrealistic to assume that device drivers
(or even subsystems) will implement the ->cancel() callback just for the
benefit of Xen.

And if the only subsystem that needs to implement ->cancel() is Xen, then the
issue should be addressed without modifying the device core code, in a different
way.

> In creating checkpoint mode, the resume handler of xenbus should not
> be called. In this case, it is recognized that the suspend was canceled
> in drivers/xen/manage.c and call dpm_resume_end() with PMSG_CANCEL.
> If the 'cancel' handler is defined, it is called instead of resume().
> 
> [1/2] - Fix hangup after creating checkpoint on Xen -- pm-linux part.
> [2/2] - Fix hangup after creating checkpoint on Xen -- Xen part.

Thanks,
Rafael
