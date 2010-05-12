Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0ELMDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:03:39 -0400
Received: from mail96.messagelabs.com ([216.82.254.19]:21776 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0ELMDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:03:37 -0400
X-VirusChecked: Checked
X-Env-Sender: Viral.Mehta@lntinfotech.com
X-Msg-Ref: server-3.tower-96.messagelabs.com!1273665813!39446564!1
X-StarScan-Version: 6.2.4; banners=lntinfotech.com,-,-
X-Originating-IP: [203.199.118.206]
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michal Nazarewicz <mina86@mina86.com>
Date: Wed, 12 May 2010 17:33:20 +0530
Subject: RE: [PATCH] USB: gadget: f_mass_storage: fix in error recovery
Thread-Topic: [PATCH] USB: gadget: f_mass_storage: fix in error recovery
Thread-Index: AcrxwP5Kq3t6taDZQ8ie23ybPXqGOwABqBss
Message-ID: <70376CA23424B34D86F1C7DE6B9973430254343AC2@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABC@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck7aofj7p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABF@VSHINMSMBX01.vshodc.lntinfotech.com>,<1148fb1fcb3a9864a2a12fbbf2e3444827c9ed4a.1273661077.git.mina86@mina86.com>
In-Reply-To: <1148fb1fcb3a9864a2a12fbbf2e3444827c9ed4a.1273661077.git.mina86@mina86.com>
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


>In to places in fsg_common_init() an unconditional call to kfree()
>on common was performed in error recovery which is not a valid
>behaviour since fsg_common structure is not always allocated by
>fsg_common_init().
>
>To fix, the calls has been replaced with a goto to a proper error
>recovery which does the correct thing.
>
>Also, refactored fsg_common_release() function.
In that case,
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Viral Mehta <viral.mehta@lntinfotech.com>
>---
>On Wed, 12 May 2010 12:33:43 +0200, Viral Mehta <Viral.Mehta@lntinfotech.com> wrote:
>> In that case, in addition to your previous patch, below hunk is needed
>>
>> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
>> index f4911c0..b1648fc 100644
>> --- a/drivers/usb/gadget/f_mass_storage.c
>> +++ b/drivers/usb/gadget/f_mass_storage.c
>> @@ -2883,15 +2883,16 @@ static void fsg_common_release(struct kref *ref)

>This is not entairly true but if you insist, attached is a bit
>different version of your proposed chang.

But, no problem with the earlier patch as well.
______________________________________________________________________

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
