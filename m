Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2ISGbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 02:31:09 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42444 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755661Ab2ISGbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 02:31:05 -0400
From: Feng Hong <hongfeng@marvell.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 18 Sep 2012 23:26:41 -0700
Subject: RE: [PATCH] poweroff: fix bug in orderly_poweroff
Thread-Topic: [PATCH] poweroff: fix bug in orderly_poweroff
Thread-Index: Ac2WK81Q80HkCHUISi2WFEwf5PsS1AAAg8aw
Message-ID: <E62404B31D39064FBDD0B843ADF05A7D2D395FC7AA@SC-VEXCH4.marvell.com>
References: <1348025233-13412-1-git-send-email-hongfeng@marvell.com>
	<87fw6eaac4.fsf@xmission.com>
	<E62404B31D39064FBDD0B843ADF05A7D2D395FC749@SC-VEXCH4.marvell.com>
 <87a9wma70f.fsf@xmission.com>
In-Reply-To: <87a9wma70f.fsf@xmission.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8J6VFNR029137

Hi, Eric,

I agree with your idea, I'll prepare another patch, thanks for remind this possible issue.

--
Best Regards,
Feng Hong
Application Processor Software Engnieer 
Marvell Technology (Shanghai) Ltd


-----Original Message-----
From: Eric W. Biederman [mailto:ebiederm@xmission.com] 
Sent: 2012Äê9ÔÂ19ÈÕ 13:58
To: Feng Hong
Cc: akpm@linux-foundation.org; gorcunov@openvz.org; keescook@chromium.org; serge.hallyn@canonical.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] poweroff: fix bug in orderly_poweroff

Feng Hong <hongfeng@marvell.com> writes:

> Hi, Eric
>
> 1. We are developing on an Android phone platform, we use thermal
> framework to monitor the temperature, when the temperature above like
> 110 degree, thermal framework will use orderly_shutdown to shutdown
> phone, however, on Android platform there is no " /sbin/poweroff " cmd
> ready . Then we want "fail ret" to trigger force shutdown (use
> kernel_power_off), but always we get "suc ret"

> 2. Here the caller just wait for "poweroff" userspace application, if
> it block the called, then it's the "poweroff" problem itself

> 3. As in the original orderly_shutdown design, we must get the right
> "ret", if this ret is always "0", then it obey orderly_poweroff design
> goal. Step 2: force shutdown is always useless code. 

That sounds like a clear case that we need to change it to
UMH_WAIT_EXEC.

Changing it to UMH_WAIT_PROC seems much more dangerous.

Eric
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
