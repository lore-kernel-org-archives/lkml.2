Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab0E0Q17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:27:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21206 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab0E0Q15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:27:57 -0400
MIME-Version: 1.0
Message-ID: <04f8be9a-78ea-45fc-9a6f-c788ca10ea69@default>
Date: Thu, 27 May 2010 09:26:13 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: dan.magenheimer@oracle.com, Venkatesh Pallipadi <venki@google.com>,
       Len Brown <lenb@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: RE: tsc reliability for Intel Core 2 Duo "Conroe"
References: <d1278473-1065-4607-98e0-67f2b985ec15@default
 AANLkTim1_8Rf0fPfycE92z5CAXpLXYga93A5qTxgXjqz@mail.gmail.com
 a20d4b76-5ba0-44cf-a26b-f58129377354@default>
In-Reply-To: <a20d4b76-5ba0-44cf-a26b-f58129377354@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4BFE9D80.016F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After digging deeper, it appears that this processor is entering
> C2 (as can be seen /sys/devices/system/cpu/cpu*/cpuidle/ output below)
> despite the documentation I have, as well as this posting from Len:
> http://forum.soft32.com/linux/ACPI-states-Conroe-ftopict339089.html
> I wonder if C1E state is somehow incorrectly getting recorded as
> C2 state?  Or maybe TSC doesn't stop in C2 (TSC is most certainly
> not stopping), in which case the test in tsc_check_state() should
> be againt ACPI_STATE_C2?
> 
> In any case, this appears to now be an ACPI C-state question
> so thanks, Venki, for cc'ing Len... and tglx is off the hook :-)
> 
> Len, note that this box is an Intel SDP so if it is an odd
> duck, please just let me know... though I think I may have
> some Xen code to fix depending on the answer to the above.

Never mind... it appears this box has a BIOS setting to enable/disable
C2 that I didn't find in the documentation.  With C2 disabled,
TSC is properly selected as the clocksource.

Sorry for the noise.
