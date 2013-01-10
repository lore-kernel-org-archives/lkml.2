Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3AJIpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:45:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:34293 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3AJIpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:45:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="189671189"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Bi, Chao" <chao.bi@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "pavan_savoy@ti.com" <pavan_savoy@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ST_CORE: Error triggered by convert "char" to "int"
Thread-Topic: [PATCH] ST_CORE: Error triggered by convert "char" to "int"
Thread-Index: AQHN7wn18PsyKHpelUWRPXiesKSfwphCPgKA
Date: Thu, 10 Jan 2013 08:45:05 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A2005F1@SHSMSX101.ccr.corp.intel.com>
References: <1357806449.8296.32.camel@bichao>
In-Reply-To: <1357806449.8296.32.camel@bichao>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0A8jHYu013305



> -----Original Message-----
> From: Bi, Chao
> Sent: Thursday, January 10, 2013 4:27 PM
> To: alan@linux.intel.com; gregkh@linuxfoundation.org;
> akpm@linux-foundation.org; pavan_savoy@ti.com
> Cc: Liu, Chuansheng; linux-kernel@vger.kernel.org
> Subject: [PATCH] ST_CORE: Error triggered by convert "char" to "int"
> 
> 
> When st driver decodes protocol index received from raw data,
> it does a value convert from "char" to "int". Because it's sign
> extension from bit8 to bit32, the "int" value maybe minus, in
> another word, the protocol index might be minus, but driver doesn't
> filter such case and may continue access memory pointed by this
> minus index.
> 
> This patch is to change the variable type of index from "int"
> to "unsigned char", so that it avoids do such kind of type
> conversion.
> 
Some infos:
when the type is minus, it will cause panic, because the below code
just consider type >= ST_MAX_CHANNELS case, no type < 0 case,
but it really happened.
			if ((type >= ST_MAX_CHANNELS) ||
					(st_gdata->list[type] == NULL)) {

Changing type from int to unsigned char can get benefit from the above
code.
If possible:
Acked-by: liu chuansheng <chuansheng.liu@intel.com>

Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
