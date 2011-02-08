Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1BHOYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:24:41 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36706 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab1BHOYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:24:40 -0500
Date: Tue, 8 Feb 2011 15:24:42 +0100
From: Borislav Petkov <bp@amd64.org>
To: martin f krafft <madduck@madduck.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Opteron ECC/ChipKill error
Message-ID: <20110208142442.GA30263@aftab>
References: <20110208133010.GA26487@albatross.oerlikon.madduck.net>
 <20110208134910.GA3849@kryptos.osrc.amd.com>
 <20110208135956.GA7055@albatross.oerlikon.madduck.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208135956.GA7055@albatross.oerlikon.madduck.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 08:59:56AM -0500, martin f krafft wrote:
> also sprach Borislav Petkov <bp@amd64.org> [2011.02.08.1449 +0100]:
> > It is a DRAM ECC error on one of the DIMMs on your node 1. If it is a
> > single occurrence I wouldn't start to worry yet - I'd monitor to see
> > whether the same row above (row 6) starts increasing its error rate.
> > Also, sometimes reseating the DIMMs helps.
> 
> Thanks. I really hope this won't happen again as I really don't want
> to go to the hosting place and open the server. ;)

Yeah, well, keep your fingers crossed. Just to reiterate, getting ECCs
is not a problem per se - they may appear even during normal operation
and in this case get corrected just fine by the memory controller. Only
an increase in the error rate may hint at a failing DRAM device so if
the error starts repeating you might start thinking when the downtime to
replace the failing DIMM is less hurtful/more suitable for you.

Cough.. IMHO. :)

> > Can you send your dmesg please?
> 
> Don't want to spam the list, so:
> http://scratch.madduck.net/__tmp__dmesg.gz

Ah ok, this is a .32 kernel and it doesn't have the information I was
looking for. I've changed that in later kernels so that EDAC dumps the
DRAM chip selects placement on the memory controller. Here's an example:


[   15.256809] EDAC MC: DCT0 chip selects:
[   15.261007] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   15.266073] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   15.271140] EDAC amd64: MC: 4:     0MB 5:     0MB
[   15.276207] EDAC amd64: MC: 6:     0MB 7:     0MB
[   15.291246] EDAC MC: DCT1 chip selects:
[   15.295443] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   15.300511] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   15.305579] EDAC amd64: MC: 4:     0MB 5:     0MB
[   15.310647] EDAC amd64: MC: 6:     0MB 7:     0MB
[   15.315711] EDAC amd64: using x8 syndromes.

and from this I can see that I have 4 DIMMs on the node, 2 per channel
and each DIMM is 4G (dual-ranked). The last one I know from the DIMMs
type.

In your case, the ECC comes from chip select 6 which should mean the
last DIMM on the node on the second channel. You have to look at the
silkscreen labels on the board to pinpoint which DIMM it is or search
through board layout manuals. (I know, this should be easier, I know...
).

Btw, you should be able to get the above output if you enable
CONFIG_EDAC_DEBUG or upgrade your kernel.

HTH.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
