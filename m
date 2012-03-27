Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2C0Sfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:35:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:54007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab2C0Sfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:35:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="122324067"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Thread-Topic: [PATCH 3/3] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Thread-Index: AQHM+52OAGJLSTC5XEayndO+1KM0H5Zd7lyAgAjwwGCAAHjXAP//ksOwgACIZoCAF4MHgP//oHFg
Date: Tue, 27 Mar 2012 18:35:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F15B72395@ORSMSX104.amr.corp.intel.com>
References: <1331040694-12558-1-git-send-email-bp@amd64.org>
 <1331040694-12558-4-git-send-email-bp@amd64.org>
 <4F563067.1090100@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F15B61916@ORSMSX103.amr.corp.intel.com>
 <20120312162646.GB7255@aftab>
 <3908561D78D1C84285E8C5FCA982C28F15B61A1F@ORSMSX103.amr.corp.intel.com>
 <20120312180359.GA8214@aftab> <20120327170655.GB7937@aftab>
In-Reply-To: <20120327170655.GB7937@aftab>
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

> In any case, if during the safe period of time we haven't received
> confirmation from userspace that the item has been consumed, we switch
> irreversibly back to the kernel log buffer and reissue the decoded info
> through printk.

I'm not sure I like irreversible things.

Here's the life cycle:

1) System boots ... we have a window during this time where there is
   no daemon (or any user space at all).

2) Daemon gets started from /etc/init.d or systemd script

3) (optional) New version of daemon installed in update (old daemon is terminated, new one starts).

4) System is shutdown - all daemons terminated

5) System actually halts.


So we clearly have some gaps where there isn't a daemon.  Most of them should
be pretty short ... but I worry about the gap from #1 to #2 - which can be pretty
long if we need to fsck some disks (or we on some crazy big system that takes
many minutes just to find and spin-up all the disks).

-Tony
