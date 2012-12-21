Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2LUNvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:51:15 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:41075 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab2LUNvJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:51:09 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Fri, 21 Dec 2012 14:50:53 +0100
Subject: RE: [RFCv2 07/11] remoteproc: Register virtio devices after vring
 allocation
Thread-Topic: [RFCv2 07/11] remoteproc: Register virtio devices after vring
 allocation
Thread-Index: Ac3fgNAhdrbtPex/QxerJ+4m00M2UQAAKAVg
Message-ID: <81C3A93C17462B4BBD7E272753C1057924576E5095@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-8-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021801.GD28692@WorkStation.localnet>
 <81C3A93C17462B4BBD7E272753C1057924576E500F@EXDCVYMBSTM005.EQ1STM.local>
 <20121221134051.GB22252@WorkStation.localnet>
In-Reply-To: <20121221134051.GB22252@WorkStation.localnet>
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
> > Ugh, thanks I missed this. How about calling rproc_alloc_vring from
> > rproc_parse_vring so that the resource allocation are done before
> > the virtio devices are started?

> I don't think that would solve it - rproc_parse_vring is called from
> rproc_handle_vdev which is called more than once (for each vdev), so
> max_notifyid could still be increased after the first call to
> rproc_add_virtio_dev.

Yes, but I think this will work if we allocate resources first,
and then in the next step register the virtio devices.
All the resources for all the vdevs will be allocated first
and then rproc_boot will be called.

> Great, thanks!
> Happy new year :)

Thanks, Same to you.

Regards,
Sjur
