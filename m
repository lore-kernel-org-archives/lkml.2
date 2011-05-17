Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1EQPa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:30:29 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:25553 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1EQPa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:30:27 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Tejun Heo <htejun@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Tue, 17 May 2011 16:30:20 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: AcwHPxHxRDZFLB3BRD+AB79Eq+ch2gNZjy0A
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com>
References: <4DA45CA7.9040102@teksavvy.com> <4DA467FB.6020905@teksavvy.com>
 <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
 <20110425162242.GB30828@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
 <20110426135027.GI878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
 <20110426155229.GM878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com>
 <20110430140109.GJ29280@htj.dyndns.org>
In-Reply-To: <20110430140109.GJ29280@htj.dyndns.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

> So, here's the patch which should fix the problem you're seeing and
> doesn't break the controllers which generate spurious hotplug events
> during reset.  Please test this when you come back and let me know the
> result.

I have tested this patch out a fair amount, and it seemed to make things
much more reliable, but I have managed to lock up the port again this
afternoon. Below is some tracing showing ata4 being frozen and not thawed:

__ata_port_freeze: ata4 port frozen
ata4: hard resetting link
sata_link_hardreset: ENTER
ata4: COMRESET failed (errno=-32)
sata_link_hardreset: EXIT, rc=-32
ata4: reset failed (errno=-32), retrying in 33 secs
__ata_port_freeze: ata4 port frozen
ata4: hard resetting link
sata_link_hardreset: ENTER
ata4: COMRESET failed (errno=-32)
sata_link_hardreset: EXIT, rc=-32
ata4: reset failed, giving up
ata_eh_recover: EXIT, rc=-32
ata4.00: disabled
ata4: EH complete
ata_scsi_error: EXIT

The IRQ for that port is masked off afterwards.


Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
