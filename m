Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1AWUxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 15:53:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43764 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1AWUxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 15:53:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/1] Use cachable mapping for i915 opregion.
Date: Sun, 23 Jan 2011 21:52:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1295803414-5373-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de> <0d30dc$kr9u7e@orsmga001.jf.intel.com>
In-Reply-To: <0d30dc$kr9u7e@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101232152.27970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 23, 2011, Chris Wilson wrote:
> On Sun, 23 Jan 2011 18:23:34 +0100, Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de> wrote:
> > The opregion is a shared memory region between ACPI and the graphics
> > driver. As the ACPI mapping has been changed to cachable in commit
> > 6d5bbf00d251cc73223a71422d69e069dc2e0b8d, mapping the intel opregion
> > non-cachable now fails. As no bus-master hardware is involved in the
> > opregion, cachable map should do no harm.
> 
> Satisfied myself that is indeed equivalent to use the newly introduced
> acpi_os_ioremap for this purpose and applied to -fixes.

However, it might be better to use acpi_os_ioremap() in case we decide to
go back to ioremap() for some reason.  For now, ioremap_cache() seems fine,
but ...

Thanks,
Rafael
