Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2CLRAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:00:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:17941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab2CLRAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:00:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="120215598"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Thread-Topic: [PATCH 3/3] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Thread-Index: AQHM+52OAGJLSTC5XEayndO+1KM0H5Zd7lyAgAjwwGCAAHjXAP//ksOw
Date: Mon, 12 Mar 2012 16:59:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F15B61A1F@ORSMSX103.amr.corp.intel.com>
References: <1331040694-12558-1-git-send-email-bp@amd64.org>
 <1331040694-12558-4-git-send-email-bp@amd64.org>
 <4F563067.1090100@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F15B61916@ORSMSX103.amr.corp.intel.com>
 <20120312162646.GB7255@aftab>
In-Reply-To: <20120312162646.GB7255@aftab>
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

> Sounds better, especially the close-on-exit part. Please elaborate on
> the races...

Errors are happening asynchronously to everything. Race looks like:

Daemon exits (or is killed)
   <<<< race begins here
kernel close routine called
close routine updates your global variable
   <<<< race ends here

-Tony


