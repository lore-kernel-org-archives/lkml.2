Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2LUCYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:24:30 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36722 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2LUCYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:24:22 -0500
Date: Fri, 21 Dec 2012 04:18:01 +0200
From: Ido Yariv <ido@wizery.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>
Subject: Re: [RFCv2 07/11] remoteproc: Register virtio devices after vring
 allocation
Message-ID: <20121221021801.GD28692@WorkStation.localnet>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-8-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355501220-4572-8-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 14, 2012 at 05:06:56PM +0100, Sjur Brændeland wrote:
> Postpone the registration of virtio devices until all
> vritio ring resource has been allocated.
> This fixes the following bug: The driver's start callback
> is called before all vring notify ids are allocated and
> max_notifyid will be increased after starting the remoteproc.

It seems that this patch wont solve this issue, since
rproc_add_virtio_dev eventually increases max_notifyid, so the same
problem will simply occur at a later stage.

Also, it seems that the original rproc_add_virtio_dev calls were not
removed, so devices would be added twice.

If max_notifyid needs to be set before the first virtio device is added,
how about counting the number of notification ids in advance before
adding the devices, by traversing the resource list twice?

Thanks,
Ido.
