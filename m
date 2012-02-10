Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab2BJXMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:12:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:37383 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616Ab2BJWmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="65477654"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "seiji.aguchi@hds.com" <seiji.aguchi@hds.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mjg@redhat.com" <mjg@redhat.com>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>
Subject: RE: [PATCH 2/2] x86, reschedule: check to see if system is shutting
 down
Thread-Topic: [PATCH 2/2] x86, reschedule: check to see if system is
 shutting down
Thread-Index: AQHM6DdWXhMuiUWedkmvGJM5sNRJdpY2uPkQ
Date: Fri, 10 Feb 2012 22:42:24 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F03AA72@ORSMSX104.amr.corp.intel.com>
References: <1328907735-6226-1-git-send-email-dzickus@redhat.com>
 <1328907735-6226-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1328907735-6226-3-git-send-email-dzickus@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-		WARN_ON(1);
+		if (atomic_read(&stopping_cpu) == -1)
+			/* system is not shutting down.. yell */
+			WARN_ON(1);

Should that be written as:

		/* system is not shutting down.. yell */
		WARN_ON(atomic_read(&stopping_cpu) == -1);

the
		if (something)
			WARN_ON(1);

looks weird.

-Tony
