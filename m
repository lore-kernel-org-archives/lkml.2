Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2CNGmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:42:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10191 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2CNGmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:42:22 -0400
X-AuditID: cbfee60f-b7bd0ae00000422c-20-4f603dcda051
Date: Wed, 14 Mar 2012 06:42:21 +0000 (GMT)
From: PINTU KUMAR <pintu.k@samsung.com>
Subject: Re: Re: [INFO] : Hibernation and Resume between 2 similar devices
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: pintu.k@samsung.com
MIME-version: 1.0
X-MTR: 20120314042844821@pintu.k
Msgkey: 20120314042844821@pintu.k
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120314042844821@pintu.k
X-ParentMTR: 
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <28768997.133231331707340650.JavaMail.weblogic@epml27>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2E6gUco026421

------- Original Message -------
Sender : Rafael J. Wysocki<rjw@sisk.pl> 
Date   : Mar 14, 2012 01:36 (GMT+05:00)
Title  : Re: [INFO] : Hibernation and Resume between 2 similar devices

On Tuesday, March 13, 2012, PINTU KUMAR wrote:
> Dear All,
> 
> I am just curious to know if it is possible to "Hibernate in one device" and "Resume the hibernated image from another similar device".

Not out of the box (you'd need to hack the kernel for that to work I think,
at least on x86) and the devices would need to be _exactly_ identical.
Moreover, if there is read-write mass storage in them, the filesystems on
both would have to be exactly identical as well (including metadata and data
layout etc.).

[Pintu]
I wanted to try this on arm based Linux mobile phone.
I have 2 exactly similar mobile phone.
Here exactly means: 
hardware is same, kernel version is same, platform is same, filesystem is same.
The only difference could be some user space application state.
Hmmm.....the metadata and data layout within file system....this is were the confusion is.
Suppose in "Device 1" during hibernation, I have a file say "file1.txt" opened whose inode number is say "123456".
This opened state of file1.txt will be captured in hibernation image.
Now assume that same "file1.txt" is also present (not opened) in "Device2" but whose inode number is say "567890".
Now if I reboot "Device 2" and try to resume from hibernated image of "Device 1", what would happen to "file1.txt" ??
And similarly other senarios.......
Will resume work, at least partially. Like discard whatever is not relevant to "Device 2" and continue to load others.


> Suppose, I have 2 exactly similar device (Laptop or mobile phone) with me.
> At one time I will be working on only one device at a time.
> Suppose I started my work on "Device 1"  with few opened application and later I wanted to switch to "Device 2" which is exactly similar to Device 1.
> I thought to hibernate (suspend to disk) the Device 1 and store the hibernated image as a swap file and later transfer to sd card.
> Then take of the sd card from Device 1 and put it into Device 2.
> Copy the swap file from sd card to Device 2 in some swap partition.
> Then reboot the Device 2 to Resume from this swap file.
> I will get back my Device 1 content in Device 2.
> 
> Hope this is possible ?

It may be possible to make it kind of work, but I wouldn't recommend it to
anyone.

[Pintu]
if this can be possible we can derive many use cases.
Till now we heard about hibernating and resuming from same device. And also people uses it rarely.
With the Tizen coming up (supporting multiple devices) we can think about it.
Also if "cloud" is integrated with kernel in _future_ we can save all our work from one device in cloud and restore our work from cloud in another device.
I think that make sense.


Thanks,
Rafael
<p>&nbsp;</p><p>&nbsp;</p>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
