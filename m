Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0EFIRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:17:52 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:24688
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753342Ab0EFIRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:17:50 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz1432Pzz1202hzz6ff19h6d525hz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1ZODC-02-2KD-02
X-M-MSG: 
Date: Thu, 6 May 2010 10:17:21 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
       Jiri Benc <jbenc@suse.cz>,
       "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
       "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
Subject: Re: [113/197] x86, cacheinfo: Calculate L3 indices
Message-ID: <20100506081721.GA20616@aftab>
References: <20100422190917.467545308@kvm.kroah.org>
 <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz>
 <20100505180228.GC15804@aftab>
 <alpine.LNX.2.00.1005052328000.9849@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1005052328000.9849@pobox.suse.cz>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Wed, May 05, 2010 at 05:33:45PM -0400

> Yeah, you are right, returning -1 is bogus as well.
> 
> The point is though, that we really should be checking for return value of 
> node_to_k8_nb_misc() as it can legitimately return NULL, can't it? (and 
> other places, such as show_cache_disable() and store_cache_disable(), are 
> checking for this being NULL properly).

Well, I don't like sprinkling NULL ptr checks all over the place - this
makes the code unreadable and means that there's something wrong with
its design in the first place.

Therefore, it is better IMO to verify whether the K8_NB thing is
initialized properly and exit early if not. And this is what the two
patches I'm suggesting try to accomplish:

1. Call into K8_NB on AMD unconditionally so that we have those
initialized (we'll be needing them more in the future, I guess)

2. Check in the L3 cache code whether K8_NB has initted properly and
bail out if not.

With this, no need for NULL ptr checks anywhere and you got
better/smaller/more readable code with the proper assumptions in place.

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

