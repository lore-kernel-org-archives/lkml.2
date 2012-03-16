Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2CPFcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 01:32:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46623 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab2CPFcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 01:32:11 -0400
X-AuditID: cbfee60f-b7bd0ae00000422c-66-4f62d05aa131
Date: Fri, 16 Mar 2012 05:32:09 +0000 (GMT)
From: Yong-Sul Oh <yongsul96.oh@samsung.com>
Subject: Re: Re: [PATCH] USB: Gadget: Composite: Added error handling codes to
 prevent a memory leak case when the configuration's bind function failed
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: yongsul96.oh@samsung.com
MIME-version: 1.0
X-MTR: 20120316052554170@yongsul96.oh
Msgkey: 20120316052554170@yongsul96.oh
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120316052554170@yongsul96.oh
X-ParentMTR: 
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <3092434.202651331875926961.JavaMail.weblogic@epml26>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2G5WouG008863

Dear Sergei Shtylyov

I appreciate your guideline.
(i will check again the "submittingpatches & submitchecklist")
I will fix it & try to send it soundly again.

Best regards,  
Yongsul Oh

------- Original Message -------
Sender : Sergei Shtylyov
Date : 2012-03-15 22:57 (GMT+09:00)
Title : Re: [PATCH] USB: Gadget: Composite: Added error handling codes to prevent a memory leak case when the configuration's bind function failed

Hello.

On 15-03-2012 5:23, Yongsul@vger.kernel.org wrote:

> From: yongsul96.oh@samsung.com

>   In some usb gadget driver, for example usb gadget serial driver(serial.c),
> multifunction composite driver(multi,c), nokia composite gadget driver(nokia.c),
> HID composite driver(hid.c), CDC composite driver(cdc2.c).., the configuration's
> bind function by called the 'usb_add_config()' has multiple bind config functions
> for each functionality, for example cdc2 configuration bind function -'cdc_do_config()'
> has two functionality bind config functions -'ecm_bind_config()'&  'acm_bind_config()'
> in CDC composite driver.
>   In each functionality bind config function, new instance for each functionality is
> allocated&  initialized by 'kzalloc()' ,and finally the new instance is added by
> 'usb_add_function()'. After 'usb_add_function' state, already created the instance
> is only handled by its configuration&  freed from functionality unbind function.
>   So, If an error occurred during the second functionality bind config state, for example
> an error occurred at 'acm_bind_config()' after succeeding 'ecm_bind_function()',
> The created instance by 'acm_bind_config()' cannot be freed.
> And it makes memory leak situation.

> This patch fixes this issue.

> Signed-off-by: yongsul96.oh@samsung.com 

    Real name is required on the left, not another copy of email.

WBR, Sergei






Oh, Yong-Sul
Engineer

Mobile S/W Platform Lab.
Telecommunication R&D Center
Telecommunication Network Business

SAMSUNG ELECTRONICS CO.,LTD

Tel : +82-31-279-0284
Mobile : +82-10-9530-0284
Fax : +82-31-279-5521
E-mail : yongsul96.oh@samsung.com




Copyrightâ“’ 2005 Samsung Electronics Co., Ltd. All rights reserved | Confidential

The information contained in this message is confidential and may be legally privileged. The message is intended solely for the addressee(s). If you are not the intended recipient, you are hereby notified that any use, dissemination, or reproduction is strictly prohibited and may be unlawful. If you are not the intended recipient, please contact the sender by return e-mail and destroy all copies of the original message. ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
