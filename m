Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab2JLK0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:26:09 -0400
Received: from mail.x86-64.org ([217.9.48.20]:56370 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933826Ab2JLK0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:26:06 -0400
Date: Fri, 12 Oct 2012 12:26:03 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steffen Persvold <sp@numascale.com>,
        Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH v2] Fix AMD Northbridge-ID contiguity assumptions
Message-ID: <20121012102603.GD19420@aftab.osrc.amd.com>
References: <1349270474-28808-1-git-send-email-daniel@numascale-asia.com>
 <20121004131801.GD21028@aftab.osrc.amd.com>
 <20121012093310.GC19420@aftab.osrc.amd.com>
 <5077E96C.4030609@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5077E96C.4030609@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 11:57:00AM +0200, Steffen Persvold wrote:
> This patch looks very clean and should serve our purpose as well (I'll
> double check with Daniel).

Thanks.

I'll run it today or next week to check whether it works as expected -
will let you know if there are issues.

> Regarding the size of the "node" variable, you asked before. The
> theoretical maximum number of AMD NBs we can have in a confederated
> NumaConnect system _today_ is 8*4096 (8 NBs per system, 4096
> systems) so technically this could fit into a u16 instead of a u32
> (you'll have to shift left by 3 instead of 8).
> 
> However, to allow some flexibility I think a u32 is better and I
> think we can live with those two extra bytes per struct member, or ?

Yeah, we can leave it u32 (I did it so in my patch) because of two
reasons:

* node_to_amd_nb gets an int as an argument
* compiler padding

On the largest of your systems that's 2*8*4096 = 64K but I'll go ahead
and assume you have enough memory on those so that nobody cares about
64K there. :-)

On Fri, Oct 12, 2012 at 05:46:28PM +0800, Daniel J Blueman wrote:
> Nice. Sorry for the delays in getting back to you, since I'm just
> chasing down the last issue we see with kobjects, amongst other work.
>
> I'll check this out next week, and thanks for keeping an eye on it!

Sure. It is probably convenient that you're busy currently - I can test
it here first and fixup any issues before you do. I'll send an official
version with changelog etc after having tested it here.

Thank you both.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
