Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab2C2C2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:28:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38737 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2C2C2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:28:46 -0400
Date: Wed, 28 Mar 2012 23:28:39 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
Message-ID: <20120329022839.GA26111@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@intel.com>
References: <1332983958-2734-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332983958-2734-1-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

* Keith Packard <keithp@keithp.com> [2012-03-28 18:19:18 -0700]:

> This reverts commit 4b95a24ce12c4545fd7d2e3075841dc3119d1d71.
> 
> My USB bluetooth device does not show up with this patch in place.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
> 
> This patch seems so innocuous, but when added to the kernel, it keeps
> my USB bluetooth device from appearing to user mode at all. With the
> mgmt interface enabled:

It is because it changes the way the userspace <-> kernel interface. We added a
new interface and that flag was preventing the code to use it by default, but
now that we finished to implement the new interface it will be enabled by default.

A consequence is that you'll need to use newer version of bluez, at least 4.99.
Or call the bluetooth daemon (from a pre 4.99 version) with a parameter to
disable the new interface:

$ bluetoothd -P mgmtops

Then your bluetooth will be back.

	Gustavo
