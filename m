Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab1CDVVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:21:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab1CDVVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:21:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] power: disable hibernation if module loading is disabled
Date: Fri, 4 Mar 2011 22:21:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@lists.linux-foundation.org
References: <1299255084-4390-1-git-send-email-segoon@openwall.com> <201103042142.09247.rjw@sisk.pl> <20110304211035.GA28842@albatros>
In-Reply-To: <20110304211035.GA28842@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103042221.02852.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 04, 2011, Vasiliy Kulikov wrote:
> On Fri, Mar 04, 2011 at 21:42 +0100, Rafael J. Wysocki wrote:
> > That "everyone" is actually the "full root" (in the case of /sys/power/state)
> > or someone having CAP_SYS_ADMIN in the /dev/snapshot case, right?
> 
> Yes, sorry for my bad english.  "Everyone" is indeed misleading :-D
> 
> > Second, there's _zero_ relationship between /proc/sys/kernel/modules_disabled
> > and the hibernation interface, so please find a different way to solve the
> > problem (if there is any).
> 
> If modules_disabled is set to 1, then nobody, even full root may not write
> to the kernel, right?  So, if something permits to indirectly pass
> modules_disabled restriction, this is a bug.  Otherwise,
> modules_disabled is confusing as it gives false sense of security.
> 
> -OR-
> 
> modules_disabled's documentation should be changed to note that it
> doesn't prevent rootkit uploading, but only forbids modprob'ing modules
> via the "official" init_module(2) gate, disallowing e.g. module autoloading.

Why not to change that documentation, then?

Also, please note that in order to "write" into memory using the hibernation
interface you need to have write access to swap, which you can use to corrupt
memory regardless of the modules_disabled setting AFAICS.

Thanks,
Rafael
