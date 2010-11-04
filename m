Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0KDVfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:35:53 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:51550 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0KDVfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:35:51 -0400
To: jesse.brandeburg@intel.com
Cc: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured by reboot)
References: <87ocaaszx1.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A136602815A3C7@rrsmsx501.amr.corp.intel.com>
	<87zktsskua.fsf@spindle.srvr.nix>
	<1288837586.2835.3.camel@jbrandeb-mobl2>
From: Nix <nix@esperi.org.uk>
Emacs: ed  ::  20-megaton hydrogen bomb : firecracker
Date: Thu, 04 Nov 2010 21:35:29 +0000
In-Reply-To: <1288837586.2835.3.camel@jbrandeb-mobl2> (Jesse Brandeburg's message of "Wed, 03 Nov 2010 22:26:26 -0400")
Message-ID: <87hbfwojq6.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: spindle 1245; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Nov 2010, Jesse Brandeburg outgrape:

> On Mon, 2010-11-01 at 16:08 -0700, Nix wrote:
>> 03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
>> Connection
>
>> LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>
> This is a problem, L0s and L1 don't work on these adapters, make sure

Ah. That sounds like my problem then :) I must say spontaneous link loss
is a rather nasty failure mode (I suspect the hardware simply forgets to
save its state properly when powering down, am I right? So it comes up
effectively turned off and uninitialized...)

> The above could be responsible for your issue.  If you don't want to
> disable ASPM system wide, then you could just make sure to run a recent
> kernel with the ASPM patches, or get our e1000.sf.net e1000e driver and
> try it, as it will work around the issue whether or not aspm is enabled.

I was planning to simply split up CONFIG_PCIEASPM to allow me to turn
it off for e1000e only, but this sounds a lot less kludgy. :)

(For now, it's probably simplest to just turn ASPM off, as a quick grep
of the kernel tree shows that that machine has no other hardware for
which ASPM would do a blessed thing: in fact, there *is* no other
hardware in 2.6.36 for which ASPM would do a blessed thing: so if the
only workaround is to turn ASPM off for those adapters, for now I might
as well just turn it off completely.)

Thanks for the advice!
