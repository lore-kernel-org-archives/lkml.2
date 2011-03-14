Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1CNPpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:45:19 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:61003 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab1CNPpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:45:17 -0400
X-AuditID: 83cfa826-b7c18ae00000543e-42-4d7e380a81eb
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <arnd@arndb.de>
CC: <matti.j.aaltonen@nokia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>
Date: Mon, 14 Mar 2011 17:45:08 +0200
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcviXUj59/y3/2e3ShWHyWMJxXT6IgAADn7g
Message-ID: <99B09243E1A5DA4898CDD8B7001114481082FAE15A@EXMB04.eu.tieto.com>
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <201103101720.53782.arnd@arndb.de>
 <99B09243E1A5DA4898CDD8B7001114481082FAE10A@EXMB04.eu.tieto.com>
 <201103141634.10865.arnd@arndb.de>
In-Reply-To: <201103141634.10865.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Most serial drivers do this, see drivers/tty/serial for a 
>number of examples, or drivers/serial on older kernels.

Thanks, will check it.

>That would depend on your hardware. The only important part is 
>that you make sure you can send out data at any time. If 
>i2c_master_send() causes accesses to your buffer after 
>returning, there has to be an i2c method of making sure that 
>it has completed.
>
>If the usleep_range is trying to synchronize between the NFC 
>and the I2C chip, you must wait for a notication from the NFC 
>hardware that it's done.

No, it's simply there as I have been faceing i2c write error while I do two consecutive writes.
The second fails now and then. That's seems to be a chip issue. I will try to investigate this issue.

>> What's more, I guess the i2c_master_send  is a synchronous call and 
>> when it returnes we know it flushed data. Right?
>
>If i2c_master_send is synchronous, you might not need the 
>usleep_range() at all. Removing that call would be entirely reasonable.

Will see how to approach that.

/Waldek