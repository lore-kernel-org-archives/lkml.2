Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1LNQgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:36:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab1LNQgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:36:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
Date: Wed, 14 Dec 2011 16:35:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        akpm@linux-foundation.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
References: <1322125938-6944-2-git-send-email-dg77.kim@samsung.com> <1322125938-6944-3-git-send-email-dg77.kim@samsung.com> <20111212170846.GO13952@sortiz-mobl>
In-Reply-To: <20111212170846.GO13952@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112141635.55071.arnd@arndb.de>
X-Provags-ID: V02:K0:NZSAJGWrl9Y4aqC5Yrsy4O3ZEMW+Wvo4ZjS9+t+m8ke
 yYIHspMWYcChbD0nP6L+HkC7BdGQWvPbuNMekY9on8nHYZBdVn
 DT00mpnrJr3EsvcVtslbZ6sXu+sOzdX3pJLW1yacKyiwrlziXw
 LZbCD3DXr9/czvJBU3AT/JRF9gWisJKzQfD2ZTxM/IHZqjusb/
 OMecOaqKdLMq0LD+X9xpwW3FSvuRk8PEf1X39mIlyFRtXaJhzg
 3yuiPu6ZD239GdUU2w81NN2NufSjp/KCLI4bpnr1rt8dUKs0NW
 KixwAkhK8aSVfDU4OF531MNsRV1IV4SQG1fv67IVgHC/E1EtrS
 /TpVymYKZaWbKnaUphu8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 December 2011, Samuel Ortiz wrote:
> On Thu, Nov 24, 2011 at 06:12:18PM +0900, Donggeun Kim wrote:
> > The MUIC function in MAX8997 device can be used as
> > a USB port detector and switch.
> > This patch supports the MUIC feature of MAX8997.
> 
> I'm queueing this one to my for-next branch as it depends on your previous MFD
> patch.
> I'm also cc'ing Arnd in case he has some objections.

Thanks for the notification!

First of all, every new user space interface including new sysfs files
and uevent messages needs documentation in the Documentation/ABI
directory.

The part that is not clear to me is how this new driver fits in
with the first fsa9480 driver and the currently discussed extcon
subsystem, apparently all written by the same team at Samsung.
Is this misc driver still useful when the extcon framework gets
merged?

I very much believe that we should avoid introducing user interfaces
in a driver specific way when we have multiple pieces of hardware
that try to do the same thing. The extcon subsystem seems to handle
this correctly on the high-level (I have not done a detailed
review yet but I trust that it will be ok), so I don't understand
why we want another driver for the MAX8997 MUIC.

	Arnd
