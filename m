Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400Ab0FRSWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 14:22:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52147 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0FRSWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 14:22:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Micha=C5=82_Nazarewicz?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 5/6] usb/gadget: Do not take BKL for gadget->ops->ioctl
Date: Fri, 18 Jun 2010 20:22:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       David Brownell <dbrownell@users.sourceforge.net>
References: <1275426285-9088-1-git-send-email-arnd@arndb.de> <1275426285-9088-6-git-send-email-arnd@arndb.de> <op.veh043ad7p4s8u@pikus>
In-Reply-To: <op.veh043ad7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201006182022.13778.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19i1cgd+GztOYPOO2xweDB9wOMhIPxLtDDM9o0
 80riM0PDGBXmpsWUmRvaiKvHGbyjitexyEwZDXcCXnJkaoIq3w
 G6FzWjS5CsV5kRp4TBp+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 June 2010, Michał Nazarewicz wrote:
> On Tue, 01 Jun 2010 23:04:44 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> > There is no gadget driver in the tree that
> > actually implements the ioctl operation, so
> > obviously it is not necessary to hold the
> > BKL around the call.
> 
> Should the callback in ops be renamed to unlocked_ioctl then as to not
> create confusion? Just a thought.

No, we decided that the .unlocked_ioctl naming was a bad idea in the other
places after all and they should eventually get renamed back to .ioctl
once all the locked versions are gone.

	Arnd
