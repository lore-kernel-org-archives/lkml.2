Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab1LPFOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 00:14:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63640 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1LPFN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 00:13:59 -0500
X-AuditID: cbfee60f-b7bceae00000240c-3a-4eead396c807
Date: Fri, 16 Dec 2011 05:13:58 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
To: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Cc: =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111216050709677@myungjoo.ham
Msgkey: 20111216050709677@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111216050709677@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1396089.632011324012436902.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBG5E4QB013347

Samuel Ortiz<sameo@linux.intel.com> wrote:
> Hi Arnd,
> On Thu, Dec 15, 2011 at 03:34:01PM +0000, Arnd Bergmann wrote:
> > On Thursday 15 December 2011, MyungJoo Ham wrote:
> > > Arnd Bergmann wrote:
> > > > On Monday 12 December 2011, Samuel Ortiz wrote:
> > > > The part that is not clear to me is how this new driver fits in
> > > > with the first fsa9480 driver and the currently discussed extcon
> > > > subsystem, apparently all written by the same team at Samsung.
> > > > Is this misc driver still useful when the extcon framework gets
> > > > merged?
> > > 
> > > When extcom gets merged, this driver should be updated. It looks like allowing
> > > the interrupt handler to update extcon state would be enough. Bascially, this
> > > is all this driver is required for extcon to work. (and the prvious author of
> > > extcon--"extended" switch class at that time--was the author of this patch.)
> > > 
> > > Anyway, this patch has just told me that I'll need to add more sysfs entries
> > > for extcon to show the list of cable names and/or to show the status for each
> > > of them, soon or later.
> > 
> > I think it would be better not to merge this driver until the user interface
> > in the extcon framework has been finalized. I don't mind the driver, but I
> > want to prevent user interfaces from appearing in the kernel that we
> > intend to change anyway.
> > 
> > How about dropping the driver from the mfd tree, and adding it into the
> > extcon series for the next posting?
> Sounds good to me, I'll drop it.
> 
> Cheers,
> Samuel.
> 

To wait for extcon get merged and keep the MAX8997-MUIC without any sysfs interfaces or extcon feature, the following patch has been submitted yesterday:

http://lkml.org/lkml/2011/12/15/123

[PATCH] misc: max8997-muic: remove sysfs attribute
> The 'switch' sysfs attribute is used for
> showing and setting the switch state of the device.
> However, setting it from the userspace focibly is not appropriate.
> And showing the state can be handled from
> other places (e.g. external connector) in a unified manner.
> This patch removes the sysfs attribute.
> Plus, uevent messages for interrupts are also removed.
> 
> The initial max8997-muic driver is merged at:
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next
> 
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

We can send the patch (with extcon support) later anyway if it's going to be dropped for now.

And, this MAX8997-MUIC will be the example driver for extcon located at /drivers/extcon/.


Cheers!
MyungJoo.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
