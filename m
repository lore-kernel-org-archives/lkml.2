Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0JSRV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:21:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0JSRV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:21:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Date: Tue, 19 Oct 2010 19:21:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-next-20101015+; KDE/4.5.1; x86_64; ; )
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>, "Krishnamoorthy, Balaji T" <balajitk@ti.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com> <1287387875-14168-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1287387875-14168-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010191921.21007.arnd@arndb.de>
X-Provags-ID: V02:K0:oUo8lAUw1ofP2nAKSI5ixjhDeoW4qyTFdooz9v83Ebr
 6jBpt03uDzgkXRxS/S3GfjO/rHB6yzeOxL9IUxQHU4ieCPqfV8
 ah2TJjNVGe24b/Nmleff5Y8Qa+17VC194c3QMcCKYMPtgZr+XT
 QUfGgqnldg+cHPyKIcSp3rUj7NN3sM1taaibRAPe6i4fUXSf1H
 rqpcAhCRh2FLS/cX4HRRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 October 2010 09:44:33 Ohad Ben-Cohen wrote:
> +  int omap_hwspin_lock(struct omap_hwspinlock *hwlock, unsigned long *flags);
> ...
> +     The flags parameter is a pointer to where the interrupts state of the
> +     caller will be saved at.

This seems to encourage sloppy coding: The only variant you allow is the one
that corresponds to Linux's spin_lock_irqsave(), which is generally discouraged
in all places where you know if you need to disable interrupts or not.

IMHO the default should be a version that only allows locks that don't get
taken at IRQ time and consequently don't require saving the interrupt flags.

	Arnd
