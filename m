Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab2JQR2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:28:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:22326 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab2JQR2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:28:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,602,1344236400"; 
   d="scan'208";a="207268255"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bp@amd64.org" <bp@amd64.org>, "lcm@us.ibm.com" <lcm@us.ibm.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: RE: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
Thread-Topic: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
Thread-Index: AQHNkOH9ZFER3S2mLUqZGgg8EveT/JeVLvsAgCjRnACAAAfHAIAAHIQAgAAsK4CAAA6oAP//leQQ
Date: Wed, 17 Oct 2012 17:28:11 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D517FF@ORSMSX108.amr.corp.intel.com>
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
 <20120912122516.3825.87838.stgit@localhost.localdomain>
 <505C51D8.6070402@linux.vnet.ibm.com>
 <20121017105940.GA14590@x1.osrc.amd.com>
 <507E9622.6090606@linux.vnet.ibm.com>
 <20121017130934.GB14590@x1.osrc.amd.com>
 <507ED31B.7010402@linux.vnet.ibm.com>
 <20121017164006.GA14596@x1.osrc.amd.com>
In-Reply-To: <20121017164006.GA14596@x1.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9HHSIKx006207

> What's wrong with userspace tools parsing /proc/cmdline and seeing that
> mce_bios_cmci_threshold has been set since this is the only way to set
> it anyway?

The argument might be on the command line, but may have been rejected
because the BIOS didn't set the thresholds? So then you'd have to look at
the command line, *and* check /var/log/messages to make sure we hadn't
printed the message saying the BIOS was unsupportive.

BUT ... I don't think that knowing this is sufficient. A userspace tool would
want to know what value had been set for each bank. So if it really wants to
do something interesting, just knowing that "bios set some thresholds" doesn't
sound like enough information.

BUT (squared) do you even really need to know that thresholds were set? You
could look at bits {52:38} in the MCi_STATUS information for the bank to see
how many corrected errors had been logged.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
