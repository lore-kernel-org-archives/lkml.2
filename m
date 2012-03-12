Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2CLQTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:19:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:54887 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab2CLQTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:19:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117815548"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: RE: [PATCH 3/3] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Thread-Topic: [PATCH 3/3] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Thread-Index: AQHM+52OAGJLSTC5XEayndO+1KM0H5Zd7lyAgAjwwGA=
Date: Mon, 12 Mar 2012 16:18:57 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F15B61916@ORSMSX103.amr.corp.intel.com>
References: <1331040694-12558-1-git-send-email-bp@amd64.org>
 <1331040694-12558-4-git-send-email-bp@amd64.org>
 <4F563067.1090100@redhat.com>
In-Reply-To: <4F563067.1090100@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is an initial version of the patch which converts MCE decoding
> facilities to use the RAS printk buffer. When there's no userspace agent
> running (i.e., /sys/devices/system/ras/agent == 0), we fall back to the
> default printk'ing into dmesg which is what we've been doing so far.

This looks unpleasant if your userspace agent set this sysfs file, and
then dies (or gets killed).

Perhaps you need some device file that the agent keeps open (so if the
agent goes away, the kernel gets a "close" on the device to tell it
to revert). But even with this sort of solution you would still have
to worry about races.

-Tony
