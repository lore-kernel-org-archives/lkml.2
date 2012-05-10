Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056Ab2EJVKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:10:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:1783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582Ab2EJVKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:10:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139247506"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Thread-Topic: [PATCH v22] edac, ras/hw_event.h: use events to handle hw
 issues
Thread-Index: AQHNLucGAM9WTwKCAkugBSt4/JhDM5bD8d8A//+OUNA=
Date: Thu, 10 May 2012 21:10:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com>
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com>
 <20120510204042.GA4598@aftab.osrc.amd.com>
In-Reply-To: <20120510204042.GA4598@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	TP_printk(HW_ERR "mce#%d: %s error %s on memory stick \"%s\" (%s %s %s)",
>
> This still says "mce" and it should say "MC" or "mem_ctl" or similar.

I'm trying to look at how this will look to an end user who is not intimately
acquainted with the internals of how memory subsystems work.

Whether the string starts with "mce" or "MC" or whatever ... what will the
user do with the mc_index that is printed with that first %d?  I don't think
it helps them find the DIMM when they open the box.  I suppose it is useful
if there are multiple messages ... and they see that the same memory controller
is mentioned in each. But I almost think it belongs inside the parentheses at
the end as the "low level details that most users won't need to care about.

Next %s is "Corrected" or "Fatal" or "Uncorrected" ... that's good.

What are the options for the next "%s" (msg)?

"memory stick"?? I suppose "DIMM" is a bit implementation dependent (SIMMs
are long gone ... but perhaps there will be some new acronym for stacked
memory ... STIMS :-) )

Then label (from SMBIOS) ... then the internal details. Good.

-Tony
