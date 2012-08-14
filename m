Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2HNMyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:54:44 -0400
Received: from 209.248.170.90.nw.nuvox.net ([209.248.170.90]:47891 "EHLO
	GVL-MAIL.koe-americas.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753342Ab2HNMyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:54:43 -0400
From: David Cullen <David.Cullen@koe-americas.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] Fix "/usr/bin/xargs: rm: Argument list too long"
 during make distclean
Thread-Topic: [PATCH RFC] Fix "/usr/bin/xargs: rm: Argument list too long"
 during make distclean
Thread-Index: AQHNeYtJ0vuHTHXr8kOIY+yAGwirYZdYdyAAgAAFDACAAAF2AIABCkQA
Date: Tue, 14 Aug 2012 12:54:41 +0000
Message-ID: <502A4A90.3070901@koe-americas.com>
References: <502957D5.1070800@koe-americas.com> <502965BE.3070406@zytor.com>
 <502969FA.6010907@koe-americas.com> <50296B34.8090502@zytor.com>
In-Reply-To: <50296B34.8090502@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713
 Thunderbird/14.0
x-originating-ip: [10.1.5.27]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C236C0ACF09F4498F9343BCA50EB71A@koe-americas.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7ECsoKu015548

On 8/13/2012 5:01 PM, H. Peter Anvin wrote:
> On 08/13/2012 01:56 PM, David Cullen wrote:
>>>
>>> That sounds like a bug in xargs...
>>>
>>
>> In my specific case, qemu-arm-static calls xargs (In fact, in my
>> cross chroot, qemu-arm-static is used to run every user mode process).
>>
>> Do you mean that qemu-arm-static is exposing a latent defect in xargs?
>>
>> Does qemu-arm-static steal some of the command line space that would
>> normally be available for xargs? If so, how would xargs figure out
>> this was happening and handle the problem?
>>
> 
> I have no idea.  Perhaps strace can help you see what is happening, I
> don't know.  More likely it is qemu-arm-static that is broken and it is
> trying to enforce the old 128K limit that we used to have before 2.6.23.
>  This could cause a mismatch between what sysconf(_SC_ARG_MAX) returns
> and what the actual limit is.
> 
> Anyway, even more so the reason to reject this patch.


I submitted a bug report on xargs:

    http://savannah.gnu.org/bugs/index.php?37093

I also submitted a bug report on QEMU:

    https://bugs.launchpad.net/qemu/+bug/1036645
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
