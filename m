Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2BVM0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:26:09 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:37744 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2BVM0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:26:07 -0500
Date: Wed, 22 Feb 2012 13:25:55 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
Message-ID: <20120222122555.GD26845@aftab>
References: <20120220145920.GB5728@aftab>
 <4F438CE9.7080807@redhat.com>
 <20120221141231.GA15515@aftab>
 <1329835698.25686.60.camel@gandalf.stny.rr.com>
 <20120221145943.GB15515@aftab>
 <3908561D78D1C84285E8C5FCA982C28F03DA60@ORSMSX104.amr.corp.intel.com>
 <20120222104324.GA26845@aftab>
 <4F44D948.3000205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F44D948.3000205@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:02:16AM -0200, Mauro Carvalho Chehab wrote:
> Using the same concept I've adopted for my EDAC patches, I would map the 
> above into 3 fields:
> 
> 	CPU instance = 64
> 	error message = Instruction Cache Error: L1 TLB multimatch.
> 	detail = cache level: L1, tx: INSN
> 	(or, maybe, detail = [-|CE|MiscV|PCC|-|CECC] cache level: L1, tx: INSN)

No, this is not going to fly the moment you decide to dump MCi_ADDR
because it is relevant for a certain types of errors:

[ 1121.970020] [Hardware Error]: CPU:64   MC2_STATUS[Over|CE|-|-|AddrV|CECC]: 0xd400400000000813
[ 1121.979039] [Hardware Error]:  MC2_ADDR: 0xbabedeaddeadbeef
[ 1121.979042] [Hardware Error]: Bus Unit Error: RD/ECC error in data read from NB.
[ 1121.979047] [Hardware Error]: cache level: L3/GEN, mem/io: MEM, mem-tx: RD, part-proc: SRC (no timeout)

The whole decoded thing above is a string and the MCA registers are
passed on into the trace, _in_ _addition_.

IOW, for each tracepoint, the format should be a string which is
possibly empty and describes the error message additionally, and the
remaining register attributes, one per field. Mapping the hw error
scheme to some memory error format you've come up with is a bad idea and
a no-no.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
