Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1FTHpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 03:45:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54823 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1FTHpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 03:45:14 -0400
Date: Mon, 20 Jun 2011 09:44:52 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 2/8] x86, mce: remove redundant mce_available() checks
Message-ID: <20110620074451.GD9070@aftab>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB1359.9000204@jp.fujitsu.com>
 <20110617143947.GH18054@aftab>
 <4DFED0FD.6060701@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFED0FD.6060701@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 12:47:57AM -0400, Hidetoshi Seto wrote:
> > I don't think this will ever happen so why complicate the code
> > needlessly? This can only be executed if at least one of the cores on
> > the system has CPUID(1)_EDX, bits 7 and 14 cleared and that's just
> > silly.
> 
> This is a guard against such silly situation, isn't it?
> I don't think it looks so complicated and needless.
> 
> I think this code will not run on systems with single socket as
> long as the processor vendors are in the right mind.
> But in cases when it is numa with strange nodes or when it is
> migrated to/from misconfigured virtual machine I can't say that
> with certainty.

Let me put it this way: are you talking about a concrete example where
there's machine with the BSP's MCA features enabled and the rest of the
cores are not or is this some theoretical thing you're conjecturing?

If it is the first I'd really like to know about it, if it's the second,
then my initial point stands - no need to handle purely theoretical
cases.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
