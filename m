Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2ALSjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 13:39:25 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:38823 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2ALSjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 13:39:23 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Chen Gong <gong.chen@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
CC: "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>
Date: Thu, 12 Jan 2012 13:33:40 -0500
Subject: RE: [PATCH] efi: Avoid sysfs spew on reboot and panic
Thread-Topic: [PATCH] efi: Avoid sysfs spew on reboot and panic
Thread-Index: Acx5u+Mp+jsYsoIEQOWm73YqlBWCQRXnEp/Q
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C583942D2@USINDEVS01.corp.hds.com>
References: <1316552853-2000-1-git-send-email-mjg@redhat.com>
 <4E795A9C.4040508@linux.intel.com> <20110921124018.GA22155@srcf.ucam.org>
 <4E7A9BC6.9070608@linux.intel.com> <20110922131504.GA11990@srcf.ucam.org>
 <4E7C2A15.80703@linux.intel.com>
In-Reply-To: <4E7C2A15.80703@linux.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1201120185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0CIdh3J024166


>>>>>>   	mutex_lock(&psinfo->buf_mutex);
>>>>>>   	memcpy(psinfo->buf, buf, size);
>>>>>> -	id = psinfo->write(type, 0, size, psinfo);
>>>>>> +	id = psinfo->write(type, 0, KMSG_DUMP_UNKNOWN, size, psinfo);
>>>>>
>>>>> I can't say it is wrong because no real caller for this function, but I can't
>>>>> say it is right, yet. KMSG_DUMP_UNKNOWN here looks too arbirary. Do you have
>>>>> any reason to use this type here ?
>>>>
>>>> If a function calls pstore_write() directly then we have no type to
>>>> associate with it. It seems worth making this explicit.
>>>
>>> Yep, that's the point. We hope to get a more reasonable method to do it, not
>>> any assumption.
>>
>> I'm afraid I don't understand. Could you give an example of how you
>> think this should look?
>>
>If you insist on your design, I prefer deleting the function pstore_write before
>applying your patch. We all know no real users to call this function,
>every backend will register Its own callback, so this function is useless at all.

Matthew,

Do you plan to resend this patch?
Your patch will be accepted if you resend it,
because pstore_write() has been deleted by Kees.

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
