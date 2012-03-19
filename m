Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab2CSRbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:31:33 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:56282 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2CSRbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:31:31 -0400
From: Nix <nix@esperi.org.uk>
To: "Wyborny\, Carolyn" <carolyn.wyborny@intel.com>
Cc: Chris Boot <bootc@bootc.net>,
        "e1000-devel\@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] e1000e interface hang on 82574L
References: <4EFA4024.5000909@bootc.net>
	<FCF3184D-CE4F-471C-B66C-0F671795FD3C@bootc.net>
	<9BBC4E0CF881AA4299206E2E1412B626017762@ORSMSX102.amr.corp.intel.com>
	<4F048861.8070501@bootc.net> <4F12B42C.9030803@bootc.net>
	<9BBC4E0CF881AA4299206E2E1412B62621F0B1@ORSMSX102.amr.corp.intel.com>
	<4F144A76.3050703@bootc.net> <4F64B4E2.20208@bootc.net>
	<4F64CFCB.7060702@bootc.net>
	<9BBC4E0CF881AA4299206E2E1412B6260E512E0C@ORSMSX102.amr.corp.intel.com>
	<87r4wova0b.fsf@spindle.srvr.nix>
	<9BBC4E0CF881AA4299206E2E1412B6260E512FB9@ORSMSX102.amr.corp.intel.com>
Emacs: it's not slow --- it's stately.
Date: Mon, 19 Mar 2012 17:31:14 +0000
In-Reply-To: <9BBC4E0CF881AA4299206E2E1412B6260E512FB9@ORSMSX102.amr.corp.intel.com>
	(Carolyn Wyborny's message of "Mon, 19 Mar 2012 16:29:03 +0000")
Message-ID: <87ehsov6ot.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-dcc1.aftenposten.no-Metrics: spindle 1215; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Mar 2012, Carolyn Wyborny said:

>>you'll see that I tested that, and it doesn't work :( even if it did
>>work, it shouldn't be needed: the driver attempts to turn off PCIe ASPM
>>on affected NICs, and fails, apparently because *something* turns it
>>back on again.
>>
> The driver attempts to disable L0s state, not the entire feature. It

It tries to disable L1 state as well (or it did when I tested this last,
although I suspect you're right and it may leave L1 turned on these
days: judging by the contents of e1000_82574_info, anyway.)

> is also required that the device upstream on the bus from the 82574L
> have this disabled. Yes, I agree there appears to be something in the
> os that either ren-enables or fails to disable the feature on the
> upstream device, as desired. Platforms/systems also appear to vary in
> this regard, so the solutions may vary a bit as well.
>
> Its worth trying your solution as well if what I suggested doesn't
> work, but there is not one solution that fits all, unfortunately.

I don't *have* a solution. :( 'setpci by hand some unknown amount of
time after booting once the interface has stabilized' hardly counts as a
solution of any sort. It's, at best, a workaround that lets me use my
systems without hourly lockups until a real solution is found.

(To clarify: manual setpci to force off the ASPM bits is the only thing
that works for me. The driver's automatic disabling of L0s and L1
doesn't work: nor does booting with pcie_aspm=off. In both cases, I end
up with both L0s and L1 turned on, and a lockup some time later, unless
I setpci the bits off by hand.)

-- 
NULL && (void)
