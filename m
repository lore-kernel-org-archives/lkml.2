Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2IUBtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 21:49:13 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:51020 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714Ab2IUBtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 21:49:11 -0400
From: Feng Hong <hongfeng@marvell.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serge@hallyn.com>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Sep 2012 18:45:47 -0700
Subject: RE: [PATCH V2] poweroff: fix bug in orderly_poweroff
Thread-Topic: [PATCH V2] poweroff: fix bug in orderly_poweroff
Thread-Index: Ac2Xj5MJVI7DAK9HQWWm9QRQfEIGVgACqoFQ
Message-ID: <E62404B31D39064FBDD0B843ADF05A7D2D395FCD76@SC-VEXCH4.marvell.com>
References: <1348036677-28626-1-git-send-email-hongfeng@marvell.com>
	<20120920170647.GA26278@mail.hallyn.com>
	<E62404B31D39064FBDD0B843ADF05A7D2D395FCD2F@SC-VEXCH4.marvell.com>
 <20120920172513.a23d061c.akpm@linux-foundation.org>
In-Reply-To: <20120920172513.a23d061c.akpm@linux-foundation.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8L1nIt4007730

Hi, Serge, Andrew,

Will following an acceptable change log ?

/////////////////////////////////////////////////////////////////////////////////////////////////
orderly_poweroff is trying to poweroff platform by two steps:
step 1: Call user space application to poweroff
step 2: If user space poweroff fail, then do a force power off if force param is set.
The bug here is, step 1 is always successful with param UMH_NO_WAIT, which obey
the design goal of orderly_poweroff.

We have two choices here:
UMH_WAIT_EXEC which means wait for the exec, but not the process;
UMH_WAIT_PROC which means wait for the process to complete.
we need to trade off the two choices:

If using UMH_WAIT_EXEC, there is potential issue comments by Serge E. Hallyn: The exec will
have started, but may for whatever (very unlikely) reason fail.

If using UMH_WAIT_PROC, there is potential issue comments by Eric W. Biederman: If the caller
is not running in a kernel thread then we can easily get into a case where the user space caller
will block waiting for us when we are waiting for the user space caller.

Thanks for their excellent ideas, based on the above discussion, we finally choose UMH_WAIT_EXEC,
which is much more safe, if the user application really fails, we just complain the application
itself, it seems a better choice here.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

--
Best Regards,
Feng Hong
Application Processor Software Engnieer 
Marvell Technology (Shanghai) Ltd


-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: 2012Äê9ÔÂ21ÈÕ 8:25
To: Feng Hong
Cc: Serge E. Hallyn; gorcunov@openvz.org; keescook@chromium.org; serge.hallyn@canonical.com; ebiederm@xmission.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] poweroff: fix bug in orderly_poweroff

On Thu, 20 Sep 2012 17:16:35 -0700
Feng Hong <hongfeng@marvell.com> wrote:

> I am just a graduate and it's my first time to send a patch to
> opensource, so thank you very much for reminding me the "changelog
> affairs", it seems this patch has been added to -mm tree as attached
> mail, and I have no chance to change the comments, right ?  Then I must
> remember this and be careful next time.  Thanks again for reminding me!

It depends.  If the person who committed the patch was using a git tree
then it can be difficult for them to alter a changelog.

But the -mm tree is not mastered in git (for this and other reasons),
and I alter changelogs all the time.  So please feel free to send
replacement text and I shall copy-n-paste that text straight into the patch.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
