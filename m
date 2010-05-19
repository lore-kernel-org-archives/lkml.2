Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0ESGpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:45:32 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35185 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0ESGpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:45:30 -0400
Date: Wed, 19 May 2010 08:46:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@amd64.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100519064619.GA30320@aftab>
References: <4BF18995.6070008@redhat.com>
 <4BF2392A.9040409@jp.fujitsu.com>
 <4BF2C3D1.10009@redhat.com>
 <1274204560.17703.82.camel@Joe-Laptop.home>
 <20100518185305.GA23921@elte.hu>
 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
 <20100518191802.GG25224@aftab>
 <m1k4r0c0y7.fsf@fess.ebiederm.org>
 <20100518222832.GJ22675@basil.fritz.box>
 <m1wrv0zo9q.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrv0zo9q.fsf@fess.ebiederm.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, May 18, 2010 at 09:14:09PM -0400

> - Errors that occur frequently. That is broken hardware of one time or
>   another.  I want to know about that so I can schedule down time to replace
>   my memory before I get an uncorrected ECC error.  Errors of this kind
>   are likely happening frequently enough as to impact performance.

This is exactly the reason why we need a better error logging and
reporting than a log. How do you want to discover trends and count CECCs
per DIMM if you scan the logs all the time and grep for the DRAM page
it happened, the CS row it is located in and whether this is located in
the same DIMM as the 115th error back in the log? This gets especially
tricky if you're using one of the gazillion memory interleaving schemes.

Ok, and what about other errors like L3 cache errors, for example? You
want to count those too and upon reaching a threshold disable a cache
index _before_ it turns a correctable ECC into an uncorrectable error
bringing the whole system down with a critical MCE.

How about error injection, you want to test the hardware/software with
injecting real hardware errors and not simulating it all in software.

And also you want to be able to schedule different maintenance actions
depending on the severity of the error and in certain cases get away
with a clean shutdown even in the face of an uncorrectable error.

So, the whole idea entails much more than reporting errors in the syslog
but rather making the system intelligent enough to prolong its own life
and be able to warn the user that something bad is about to happen.

And we don't have that right now - right now we say that some machine
checks have been logged and with uncorrectable MCEs we freeze cowardly
and hope to be able to make a warm reset so that the MCA MSRs still
contain some valid data which we can decode painstakingly by hand.

I hope this makes our intentions a bit clearer.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
