Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1GVWji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:39:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:51716 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab1GVWjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:39:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,249,1309762800"; 
   d="scan'208";a="33602661"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 22 Jul 2011 15:39:35 -0700
Subject: RE: [PATCH] pstore: change mutex locking to spin_locks
Thread-Topic: [PATCH] pstore: change mutex locking to spin_locks
Thread-Index: AcxIaLVQTZz8TnmJRdSilI9LTZNGDAAVzbaw
Message-ID: <987664A83D2D224EAE907B061CE93D5301E9FA0EE5@orsmsx505.amr.corp.intel.com>
References: <1311195386-22743-1-git-send-email-dzickus@redhat.com>
 <4E277584.1060200@intel.com> <20110721122731.GV3765@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E9EC9DC6@orsmsx505.amr.corp.intel.com>
 <4E28C552.8060803@intel.com> <20110722121302.GB9732@redhat.com>
In-Reply-To: <20110722121302.GB9732@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually it seems like most of the entry points into pstore_dumper would
> not require the fs to create a new file.  I think the exception is an
> oops.

Yup - oops is the only one where the current kernel continues - all the
others (halt, reboot, kexec, panic) lead to the termination of the
current kernel - and thus no user processes that would be able to
see the shiny new entry in the pstore file system.

-Tony
