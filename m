Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2GSXmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:42:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:40578 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2GSXm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:42:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="195287955"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Topic: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Index: Ac1l82ceH7I0t1QCT1GombsnNxviZAAAK4PgAABTBVAAAP4IQAAA0SRAAAJWEXA=
Date: Thu, 19 Jul 2012 23:42:26 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA97@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
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

> If you are concerned about multiple OOPS case, I think an user app which logs from /dev/pstore to /var/log should be developed.

Agreed - we need an app/daemon to do this.

> Once it is developed, we don't need to care about multiple oops case and the appropriate number is two.

Only if you can guarantee that the app/daemon will run and save the first OOPS before the next
occurs. Even if the system were running normally this might be difficult to achieve ... but in this
case we know the system isn't running normally (it just OOPSed twice!).

However - there is progressively less value in collecting additional consecutive OOPS. Perhaps
one is enough 90% or even 99% of the time. I'm naturally paranoid so having two or three
would make me feel happy that most of the remaining 10% or 1% of the cases were covered.

> - In case where system is workable after oops.
> The user app will erase an entry in NVRAM.
> And we can get the message via /var/log.

Yes - the system can keep running after many types of OOPs - so the OOPS will be logged in /var/log (or by the app/daemon
copying from pstore, or both).

> - In case where system hangs up or panics due to the oops.
> Oops is the critical message and we don't need care about subsequent events.

Yes - if the OOPs is instrumental in the path leading to the hang/panic - then the OOPS is the
first place to look for the root cause of the problem. But it will be a case by case analysis.
Sometimes the OOPS might be unconnected. If possible we'd like to log more information
to allow detective work to decide whether there is a connection. But as I mentioned above
there are severe limits to how much better things are by storing more information.

-Tony
