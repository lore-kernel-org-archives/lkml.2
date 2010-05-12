Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0ELIb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:31:28 -0400
Received: from mail96.messagelabs.com ([216.82.254.19]:26141 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab0ELIbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:31:25 -0400
X-VirusChecked: Checked
X-Env-Sender: Viral.Mehta@lntinfotech.com
X-Msg-Ref: server-14.tower-96.messagelabs.com!1273653082!49683305!1
X-StarScan-Version: 6.2.4; banners=lntinfotech.com,-,-
X-Originating-IP: [203.199.118.207]
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 13:59:02 +0530
Subject: RE: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Topic: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Index: Acrxq3EP2BExQmvVRDWkkJniKdMvuwAAbvaN
Message-ID: <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
In-Reply-To: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
________________________________________
>From: linux-usb-owner@vger.kernel.org [linux-usb-owner@vger.kernel.org] On Behalf Of Michal Nazarewicz [m.nazarewicz@samsung.com]
>Sent: Wednesday, May 12, 2010 1:46 PM
>To: linux-usb@vger.kernel.org
>Cc: Kyungmin Park; Marek Szyprowski; linux-kernel@vger.kernel.org
>Subject: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init() error recovery

>In to places in fsg_common_init() an unconditional call to kfree()
>on common was performed in error recovery which is not a valid

If I am not wrong, common can not be NULL since it was already checked above.

2685         if (!common) {
2686                 common = kzalloc(sizeof *common, GFP_KERNEL);
2687                 if (!common)
2688                         return ERR_PTR(-ENOMEM);
2689                 common->free_storage_on_release = 1;


>behaviour since fsg_common structure is not always allocated by
>fsg_common_init().

>To fix, the calls has been replaced with a goto to a proper error
>recovery which does the correct thing.
---

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
