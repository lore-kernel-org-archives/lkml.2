Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0KCKtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:49:33 -0400
Received: from smtp.nokia.com ([192.100.105.134]:37800 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0KCKta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:49:30 -0400
From: <samu.p.onkalo@nokia.com>
To: <alan@linux.intel.com>, <gregkh@suse.de>
CC: <hmh@hmh.eng.br>, <alan@lxorguk.ukuu.org.uk>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 3 Nov 2010 11:48:42 +0100
Subject: RE: sysfs and power management
Thread-Topic: sysfs and power management
Thread-Index: Act7Q7EqQonA4m4WQISwIzFfT8Ak8wAAGfsg
Message-ID: <62697B07E9803846BC582181BD6FB6B836EB55EE74@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1288177143.12206.22.camel@4fid08082>
	<20101027124816.7087436a@linux.intel.com>
	<62697B07E9803846BC582181BD6FB6B836EB2994F4@NOK-EUMSG-02.mgdnok.nokia.com>
	<20101027152809.39701917@lxorguk.ukuu.org.uk>
	<20101029195039.GA26401@suse.de>
	<20101030140047.GA24464@khazad-dum.debian.net>
	<1288526275.2313.14.camel@noppispoppis.nmp.nokia.com>
	<20101031142539.GA25480@suse.de>	<1288608087.26073.6.camel@4fid08082>
	<20101101165701.2fc30368@linux.intel.com>	<20101101180740.GA17148@suse.de>
 <20101103094452.0cfae4ec@linux.intel.com>
In-Reply-To: <20101103094452.0cfae4ec@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Nov 2010 10:48:45.0270 (UTC) FILETIME=[B01A5760:01CB7B44]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: ext Alan Cox [mailto:alan@linux.intel.com]
>Sent: 03 November, 2010 11:45
>To: Greg KH
>Cc: Onkalo Samu.P (Nokia-MS/Tampere); ext Henrique de Moraes Holschuh;
>Alan Cox; akpm@linux-foundation.org; linux-kernel@vger.kernel.org
>Subject: Re: sysfs and power management
>
>On Mon, 1 Nov 2010 11:07:40 -0700
>Greg KH <gregkh@suse.de> wrote:
>
>> On Mon, Nov 01, 2010 at 04:57:01PM +0000, Alan Cox wrote:
>> > > I took a look to that. It seems that iio is more or less sysfs
>> > > based. There are ring buffers and event device which are chardev
>> > > based but still the data outside ring buffer and the control is
>> > > sysfs based.
>> >
>> > IIO is sysfs dependant, heavyweight and makes no sense for some of
>> > the sysfs based drivers. IIO is also staging based and Linus
>> > already threw out the last attempt to unify these drivers sanely
>> > with an ALS layer - which was smaller, cleaner and better !
>>
>> I think we need to revisit this issue again, before iio is merged to
>> the main kernel tree.  I've been totally ignoring the iio user/kernel
>> api at the moment, waiting for things to settle down there
>
>Actually I think there is another way to do it cleanly
>
>Keep a flag per device (or per runtime pm struct of device)
>
>And on the open/close do
>
>	if (runtime_pm on device && device has SYSFS_PM set)
>		pm_runtime_foo
>
>so that devices that need to be powered up to handle sysfs requests can
>set a single flag and just work.

That is one quite clean way.
sysfs_ops still needs function pointer to device core function which does pm_runtime
calls.
And there is one drawback. Driver doesn't know about new users after the first one.
It may want to refresh results whenever a new user appears. But that is probably not
a big issue.

-Samu






