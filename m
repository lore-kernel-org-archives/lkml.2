Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2EBJhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:37:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21150 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2EBJhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:37:04 -0400
X-AuditID: cbfee60e-b7c91ae000006c6e-e5-4fa1003cca96
Date: Wed, 02 May 2012 09:37:00 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] MFD : add MAX77686 mfd driver
To: Andi Shyti <andi.shyti@gmail.com>,
        =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        =?euc-kr?Q?=BA=AF=C4=A1=BF=F5?= <woong.byun@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120502093054218@myungjoo.ham
Msgkey: 20120502093054218@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120502093054218@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <24380132.112141335951419265.JavaMail.weblogic@epml09>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q429bFt5019794

> Hi,
> 
> On Wed, May 02, 2012 at 02:02:55PM +0900, jonghwa3.lee@samsung.com wrote:
> > On 2012-04-30 18:17, Andi Shyti wrote:
> > > Hi,
> > > 
> > >> + mutex_lock(&max77686->iolock);
> > >> + ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
> > >> + mutex_unlock(&max77686->iolock);
> > > 
> > > Is it relly necessay to lock whenever you read/write from/to the
> > > i2c bus? Considering also that these are exported function,
> > > someone else may lock here before, so we can have a double
> > > locking on the same mutex.
> > 
> > These exported functions will be used in 77686 area only, so there is no
> > overlap locking.
> 
> OK... I think this could be a reason more to not over-use mutexes :)
> 
> When you call i2c_smbus_* functions you are not accessing to any
> private data, all the new data is allocated in a new area. The
> smbus_xfer function should take care by himself that the global
> data are locked correctly. If not, is not up to your driver to do
> it.
> If, instead, you are taking care about the concurrency in the
> bus, this should be somehow managed by the chip itself.
> In my opinion you are abusing a bit of mutex_lock/unlock.
> 
> Andi
> 
> P.S. copied and paste your reply at the bottom of my previous
> comment.

I expect MAX77686-PMIC(Regulator) driver will be using update_reg() heavily. That function requires mutexing such contexts to work correctly. You won't get correct update without a mutex as it will read a register and write to a register not atomically.

Without this mutex, updating a register (i.e., update the third bit to 1) can be disasterous with regulators.


Cheers!
MyungJoo.

> 
> 
> 


--

MyungJoo Ham (ÇÔ¸íÁÖ), PHD

System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858



 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
