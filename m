Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab2LUNlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:41:03 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33809 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2LUNk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:40:58 -0500
Date: Fri, 21 Dec 2012 15:40:51 +0200
From: Ido Yariv <ido@wizery.com>
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>
Subject: Re: [RFCv2 07/11] remoteproc: Register virtio devices after vring
 allocation
Message-ID: <20121221134051.GB22252@WorkStation.localnet>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-8-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021801.GD28692@WorkStation.localnet>
 <81C3A93C17462B4BBD7E272753C1057924576E500F@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057924576E500F@EXDCVYMBSTM005.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 21, 2012 at 01:20:02PM +0100, Sjur BRENDELAND wrote:
> Hi Ido,
> 
> > From: Ido Yariv [mailto:ido@wizery.com]
> > > Postpone the registration of virtio devices until all
> > > vritio ring resource has been allocated.
> > > This fixes the following bug: The driver's start callback
> > > is called before all vring notify ids are allocated and
> > > max_notifyid will be increased after starting the remoteproc.
> > 
> > It seems that this patch wont solve this issue, since
> > rproc_add_virtio_dev eventually increases max_notifyid, so the same
> > problem will simply occur at a later stage.
> > 
> > Also, it seems that the original rproc_add_virtio_dev calls were not
> > removed, so devices would be added twice.
> 
> Indeed. This was introduced by a faulty merge - I'll fix this up.
> 
> > If max_notifyid needs to be set before the first virtio device is added,
> > how about counting the number of notification ids in advance before
> > adding the devices, by traversing the resource list twice?
> 
> Ugh, thanks I missed this. How about calling rproc_alloc_vring from
> rproc_parse_vring so that the resource allocation are done before
> the virtio devices are started? 

I don't think that would solve it - rproc_parse_vring is called from
rproc_handle_vdev which is called more than once (for each vdev), so
max_notifyid could still be increased after the first call to
rproc_add_virtio_dev.

> BTW, I think most of the other review comments from you are OK. I'll
> try to address them in my next patch-set sometime early next year.

Great, thanks!
Happy new year :)

Ido.
