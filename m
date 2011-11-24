Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1KXAMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:12:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54997 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab1KXAMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:12:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Patrik Kullman <patrik.kullman@gmail.com>
Subject: Re: EHCI powersave causes shutdown to freeze
Date: Thu, 24 Nov 2011 01:15:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <CAGPN=9Q1HMVO27jr0e8az4SV9TyC_JL48mKWZHi8kHRfhQddMQ@mail.gmail.com>
In-Reply-To: <CAGPN=9Q1HMVO27jr0e8az4SV9TyC_JL48mKWZHi8kHRfhQddMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111240115.39048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 24, 2011, Patrik Kullman wrote:
> Hi,
> 
> After creating a powersave script based on PowerTOP Tunables, this
> particular line prevented the system from being able to shutdown (Asus
> Zenbook UX31E, kernels 3.0 - 3.1.2):
> 
> ### Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced
> Host Controller #1
> echo auto > /sys/bus/pci/devices/0000:00:1d.0/power/control
> 
> 
> Kernel prints the "Power Down." message but machine doesn't power down.
> 
> Is this a known bug?
> Could this be fixed in the driver instead of:
> 
> echo on > /sys/bus/pci/devices/0000:00:1d.0/power/control
> 
> on system shutdown?

This commit should address that issue:

commit af8db1508f2c9f3b6e633e2d2d906c6557c617f9
Author: Peter Chen <peter.chen@freescale.com>
Date:   Tue Nov 15 21:52:29 2011 +0100

    PM / driver core: disable device's runtime PM during shutdown

Thanks,
Rafael
