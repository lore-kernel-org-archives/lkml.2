Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab1LNXS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:18:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58399 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab1LNXSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:18:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/2 v2] PM / Sleep: Simplify generic system suspend callbacks
Date: Thu, 15 Dec 2011 00:19:39 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201111180037.22157.rjw@sisk.pl> <201111271341.36155.rjw@sisk.pl> <201112100005.24798.rjw@sisk.pl>
In-Reply-To: <201112100005.24798.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112150019.39645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

One more udate here.

I forgot about the comments in this patch:

On Saturday, December 10, 2011, Rafael J. Wysocki wrote:
> On Sunday, November 27, 2011, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The pm_runtime_suspended() check in __pm_generic_call() doesn't
> > really help and may cause problems to happen, because in some cases
> > the system suspend callbacks need to be called even if the given
> > device has been suspended by runtime PM.  For example, if the device
> > generally supports remote wakeup and is not enabled to wake up
> > the system from sleep, it should be prevented from generating wakeup
> > signals during system suspend and that has to be done by the
> > suspend callbacks that the pm_runtime_suspended() check prevents from
> > being executed.
> > 
> > Similarly, it may not be a good idea to unconditionally change
> > the runtime PM status of the device to 'active' in
> > __pm_generic_resume(), because the driver may want to leave the
> > device in the 'suspended' state, depending on what happened to it
> > before the system suspend and whether or not it is enabled to
> > wake up the system.
> > 
> > For the above reasons, remove the pm_runtime_suspended()
> > check from __pm_generic_call() and remove the code changing the
> > device's runtime PM status from __pm_generic_resume().
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

so the updated one becomes [1/2] in the new series.

In addition to that I noticed that __pm_generic_call() and
__pm_generic_resume() may be merged after [1/2], which is done by [2/2].

I regard these patches as 3.3 material, if there are no objections.

Thanks,
Rafael

