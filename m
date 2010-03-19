Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab0CSVfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:35:23 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:44874 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0CSVfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:35:22 -0400
Message-ID: <4BA3EDA7.1080702@nortel.com>
Date: Fri, 19 Mar 2010 15:33:27 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: debug registers, write breakpoints, and x86
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2010 21:35:03.0833 (UTC) FILETIME=[0954B890:01CAC7AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running 2.6.27 on x86 (64-bit) and I have what appears to be a
memory trampler.  I'd like to use a write breakpoint on the address
being trampled to see who's doing it.

>From what I understand, I'll need to set one of DR0-3 (let's use DR3) to
my address of interest, then set the L3, G3, RW3, and LEN3 fields in
DR7.  Then when the exception fires we'll handle it in do_debug().  Is
this right?

Given that I want this to be global and permanent, I'm a bit confused by
the code in __switch_to_xtra().  If any other task has TIF_DEBUG set
will this end up overwriting my debug register settings?  Is there any
way (other than modifying the code) to ensure that my settings are
permanent?

I'd appreciate any comments you might have.

Thanks,

Chris Friesen
