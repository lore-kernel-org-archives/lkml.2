Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab1LOAcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 19:32:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27580 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab1LOAcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 19:32:19 -0500
X-AuditID: cbfee612-b7c0fae0000024d1-34-4ee9400d9f0a
Date: Thu, 15 Dec 2011 00:32:13 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
To: Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>
Cc: =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111215000848258@myungjoo.ham
Msgkey: 20111215000848258@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111215000848258@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <33434703.581501323909131767.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBF0WaVZ005522

> On Monday 12 December 2011, Samuel Ortiz wrote:
> > On Thu, Nov 24, 2011 at 06:12:18PM +0900, Donggeun Kim wrote:
> > > The MUIC function in MAX8997 device can be used as
> > > a USB port detector and switch.
> > > This patch supports the MUIC feature of MAX8997.
> > 
> > I'm queueing this one to my for-next branch as it depends on your previous MFD
> > patch.
> > I'm also cc'ing Arnd in case he has some objections.
> 
> Thanks for the notification!
> 
> First of all, every new user space interface including new sysfs files
> and uevent messages needs documentation in the Documentation/ABI
> directory.
> 
> The part that is not clear to me is how this new driver fits in
> with the first fsa9480 driver and the currently discussed extcon
> subsystem, apparently all written by the same team at Samsung.
> Is this misc driver still useful when the extcon framework gets
> merged?

When extcom gets merged, this driver should be updated. It looks like allowing the interrupt handler to update extcon state would be enough. Bascially, this is all this driver is required for extcon to work. (and the prvious author of extcon--"extended" switch class at that time--was the author of this patch.)

Anyway, this patch has just told me that I'll need to add more sysfs entries for extcon to show the list of cable names and/or to show the status for each of them, soon or later.

> 
> I very much believe that we should avoid introducing user interfaces
> in a driver specific way when we have multiple pieces of hardware
> that try to do the same thing. The extcon subsystem seems to handle
> this correctly on the high-level (I have not done a detailed
> review yet but I trust that it will be ok), so I don't understand
> why we want another driver for the MAX8997 MUIC.

This sysfs entry is a bit confusing to me (that userspace may update this CONTROL register). I'll consult Donggeun when he arrives and will write again about this one. If it is not writable, this is supported by extcon framework, so this sysfs entry will disappear adapting extcon.


Cheers!
MyungJoo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
