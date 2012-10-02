Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2JBPO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:14:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:27296 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab2JBPO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:14:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,524,1344236400"; 
   d="scan'208";a="229033168"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: anish kumar <anish198519851985@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: How to schedule worker and threaded IRQ on same cpu/core
Thread-Topic: How to schedule worker and threaded IRQ on same cpu/core
Thread-Index: Ac2gmCa8Mz8HGOSiRo6E8/HEDKZlVv//qPCA//+gawCAAH+IAP//mOMw
Date: Tue, 2 Oct 2012 15:14:22 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD2A26D7@BGSMSX102.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD2A1E0A@BGSMSX102.gar.corp.intel.com>
	 <1349181465.1440.1.camel@anish-Inspiron-N5050>
	 <D854C92F57B1B347B57E531E78D05EAD2A1EE5@BGSMSX102.gar.corp.intel.com>
 <1349188326.1440.22.camel@anish-Inspiron-N5050>
In-Reply-To: <1349188326.1440.22.camel@anish-Inspiron-N5050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q92FEZ0v032524

> On Tue, 2012-10-02 at 12:54 +0000, Pallala, Ramakrishna wrote:
> > > > How can I schedule driver's worker and threaded IRQ on the same core?
> > > >
> > > > For work queue we have schedule_delayed_work_on () API available.
> > > > But how to schedule the threaded IRQ on the same core where my
> > > > worker
> > > thread is going to run?
> > > Why do you need to worry about where your worker thread is going to run?
> > > Or IOW what use case do you have in mind?
> >
> > In my driver I can get two independent events(IRQ and kernel
> > notification). One will be handled by Threaded IRQ and other will be
> > handled by a worker and the order is not guaranteed and with two cores
> Sometimes both workers are being scheduled  parallel.
> So what is the problem even if they run in parallel, it would be really help if we
> know what problem you are trying to solve?
> Even if you want to sync between these two then you can have some
> synchronisation mechanism between the two.
> What is the advantage you are going to get if they run on same core?
> 
> Sorry but these answers would really help community in resolving your problem.

I think I got what I was looking for...
synchronize_irq()

basically I need to wait/pause my worker thread execution until my threaded handler is complete.

Thanks for response.

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
