Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2EWFiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:38:20 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:36374
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132Ab2EWFiS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:38:18 -0400
X-SpamScore: 0
X-BigFish: VPS0(zz4015Izz1202hzz8275eha1495iz2fh2a8h668h839h944he5bhf0ah)
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        Lalit Chandivade <lalit.chandivade@qlogic.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Tue, 22 May 2012 22:38:11 -0700
Subject: Bug in sysfs bin attribute?
Thread-Topic: Bug in sysfs bin attribute?
Thread-Index: Ac04pj9rW4WE3pNjR0yCqlmRDigwWg==
Message-ID: <CBE2759B.EEFF%vikas.chaudhary@qlogic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.2.2.120421
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We have added sysfs bin_attribute 'fw_dump' in qla4xxx driver.
Here is patch for same: -
http://marc.info/?l=linux-scsi&m=133733192809849&w=2


In this patch in function qla4_8xxx_sysfs_write_fw_dump() if we print
string coming in 'char *buf'
from sysfs attribute it contain value we echo on sysfs attribute 'fw_dump'
plus some garbage data.


If I write "5" to sysfs attribute I am getting following string in buf : -


May 18 12:08:00 magana kernel: ----------------
May 18 12:08:00 magana kernel: buf: 5
May 18 12:08:00 magana kernel: /../../host10           <-- Garbage data
May 18 12:08:00 magana kernel: ----------------



Because of this garbage data kstrtol() fails in function
qla4_8xxx_sysfs_write_fw_dump().
If we use simple_strtol() instate of kstrtol() it works well. But
simple_strtol() is deprecated
so we can't use this API.
Solution to this, for now are writing "0" at buf[1] as we are interested
only in value at buf[0].


I am interested to know if the behavior of sysfs attribute is correct or
is it an issue?



Thanks,
Vikas.



This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

