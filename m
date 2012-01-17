Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2AQAfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:35:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37015 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2AQAfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:35:40 -0500
X-AuditID: cbfee60e-b7c59ae000007ec6-c0-4f14c258a6d1
Date: Tue, 17 Jan 2012 00:35:36 +0000 (GMT)
From: =?euc-kr?B?w9bBvsiv?= <jhbird.choi@samsung.com>
Subject: Re: Re: [PATCH] driver-core: Fix null reference in
 subsys_interface_unregister
To: Greg KH <gregkh@suse.de>,
        =?euc-kr?Q?=C3=D6=C1=BE=C8=AF?= <jhbird.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B1=E8=B1=B9=C1=F8?= <kgene.kim@samsung.com>
Reply-to: jhbird.choi@samsung.com
MIME-version: 1.0
X-MTR: 20120117002241776@jhbird.choi
Msgkey: 20120117002241776@jhbird.choi
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120117002241776@jhbird.choi
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <15905052.41411326760535818.JavaMail.weblogic@epv6ml08>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0H0ZjwN014242

Greg KH wrote:

>On Sat, Jan 14, 2012 at 11:06:03AM +0900, jhbird.choi@samsung.com wrote:
>> From: Jonghwan Choi 
> >
> >Check if the sif is not NULL before de-referencing it

>Why would it be?  Have you hit this somehow?  If so, in what code?

> thanks,

> greg k-h


diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 99dc592..4ddb38b 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -1193,13 +1193,15 @@ EXPORT_SYMBOL_GPL(subsys_interface_register);

 void subsys_interface_unregister(struct subsys_interface *sif)
 {
-       struct bus_type *subsys = sif->subsys;   // -> Sif is already used, that means sif is not null
+       struct bus_type *subsys;
        struct subsys_dev_iter iter;
        struct device *dev;

-       if (!sif)  // -> Check whether sif is null 
+       if (!sif || !sif->subsys)
                return;

+       subsys = sif->subsys;
+
        mutex_lock(&subsys->p->mutex);
        list_del_init(&sif->node);
        if (sif->remove_dev) {
-- 

sif is already used, but  null pointer check for sif later.
so i think that sif should be checked before use it.


Sorry about that, since my e-mail client has a problem,
 I couldn't send that to mailing list. I will send it to mailing list.
 Thanks.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
