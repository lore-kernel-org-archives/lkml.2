Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab2ERVMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:12:32 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42422 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965340Ab2ERVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:12:30 -0400
Date: Fri, 18 May 2012 23:12:11 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120518211211.GA26464@aftab.osrc.amd.com>
References: <20120518095638.GA20215@aftab.osrc.amd.com>
 <4FB62BAB.90808@redhat.com>
 <20120518124338.GJ20215@aftab.osrc.amd.com>
 <4FB64D5B.1030301@redhat.com>
 <20120518140521.GM20215@aftab.osrc.amd.com>
 <4FB65D52.9060108@redhat.com>
 <20120518164014.GX20215@aftab.osrc.amd.com>
 <4FB6866E.7090503@redhat.com>
 <20120518185258.GE20215@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 07:10:42PM +0000, Luck, Tony wrote:
> > That's why _each_ _driver_ will have its format and the userspace tools
> > parsing it will know about it!
> 
> Sounds like a full employment program for parser writers.
> 
> There are some interesting fields that should be common to all
> drivers ... so have twenty parsers that can handle:
> 
> 	paddr: 0x1234
> 	PADDR: 0x1234
> 	Paddr = 0x1234
> 	Phys = 1234
> 	addr: 0x1234
> 	Address: 0x000000001234
> 
> looks like a lot of make-work ... when the OS can standardize in the ABI
> that there is a 64-bit binary value that is the physical address of the
> error (and another 64-bit mask saying which, if any, bits are valid).

Makes sense, I gotta say :)

> So we should be looking for the set of always relevant values that
> can be kept explicitly separate in fields in TP_PROTO, and per-driver
> specific stuff (grain/syndrome??) bits that will have to go into the
> "details" string and require some driver specific user-mode parsing to
> use.

How about we put all the values which are globally valid for all drivers
in separate fields and leave the "(...)" brackets for details where each
driver can put its own relevant stuff?

For the record, I very much like this reasoning :).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
