Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2LUMUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 07:20:43 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:56700 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234Ab2LUMUe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 07:20:34 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Fri, 21 Dec 2012 13:20:02 +0100
Subject: RE: [RFCv2 07/11] remoteproc: Register virtio devices after vring
 allocation
Thread-Topic: [RFCv2 07/11] remoteproc: Register virtio devices after vring
 allocation
Thread-Index: Ac3fIWtLiUfJJSxzThuEewR8D0BAWgAUpWNw
Message-ID: <81C3A93C17462B4BBD7E272753C1057924576E500F@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-8-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021801.GD28692@WorkStation.localnet>
In-Reply-To: <20121221021801.GD28692@WorkStation.localnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ido,

> From: Ido Yariv [mailto:ido@wizery.com]
> > Postpone the registration of virtio devices until all
> > vritio ring resource has been allocated.
> > This fixes the following bug: The driver's start callback
> > is called before all vring notify ids are allocated and
> > max_notifyid will be increased after starting the remoteproc.
> 
> It seems that this patch wont solve this issue, since
> rproc_add_virtio_dev eventually increases max_notifyid, so the same
> problem will simply occur at a later stage.
> 
> Also, it seems that the original rproc_add_virtio_dev calls were not
> removed, so devices would be added twice.

Indeed. This was introduced by a faulty merge - I'll fix this up.

> If max_notifyid needs to be set before the first virtio device is added,
> how about counting the number of notification ids in advance before
> adding the devices, by traversing the resource list twice?

Ugh, thanks I missed this. How about calling rproc_alloc_vring from
rproc_parse_vring so that the resource allocation are done before
the virtio devices are started? 

BTW, I think most of the other review comments from you are OK. I'll
try to address them in my next patch-set sometime early next year.

Regards,
Sjur
