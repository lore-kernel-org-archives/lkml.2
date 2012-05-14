Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2ENRRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:17:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45521 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2ENRRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:17:18 -0400
Date: Mon, 14 May 2012 19:17:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] x86/mce: Only restart instruction after machine
 check recovery if it is safe
Message-ID: <20120514171702.GC21960@aftab.osrc.amd.com>
References: <cover.1336674796.git.tony.luck@intel.com>
 <e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
 <20120513095913.GB28863@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192EED2B@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192EED2B@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 04:16:05PM +0000, Luck, Tony wrote:
> >> +	int			restartable;
> >
> > Is it me or does this look like a flag, or a bitfield? Instead of
> > wasting a whole integer for a single bit of information.
> 
> I could make it "int flags;" and "#define MCE_INFO_RESTARTABLE 1"
> to make it clear that we have lots more bits available for special
> cases?

I was wondering about that but don't have any other flags/use cases.
Well, we can always change it later if needed.

> > It will probably end up the same size though due to compiler padding
> > since this struct is currently 4 + 2*8 byte without the ->restartable
> > thing.
> 
> Yup - we can't save any memory (unless we introduce more complexity to
> the code ... low PAGE_SHIFT bits of the "paddr" field are simply thrown
> away ... so we could allocate a bit there ... but I don't think that
> the resulting ugliness is worth the memory savings).

Agreed, that would be too ugly for no reason :-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
