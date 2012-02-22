Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2BVQAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:00:04 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38624 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2BVQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:00:00 -0500
Date: Wed, 22 Feb 2012 16:59:48 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
Message-ID: <20120222155948.GF26845@aftab>
References: <20120220145920.GB5728@aftab>
 <4F438CE9.7080807@redhat.com>
 <20120221141231.GA15515@aftab>
 <1329835698.25686.60.camel@gandalf.stny.rr.com>
 <20120221145943.GB15515@aftab>
 <3908561D78D1C84285E8C5FCA982C28F03DA60@ORSMSX104.amr.corp.intel.com>
 <20120222104324.GA26845@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222104324.GA26845@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 11:43:24AM +0100, Borislav Petkov wrote:
> This will keep the bloat level to a minimum, keep the TPs apart and
> hopefully make all of us happy :).

Btw, here's how the rough MCE TP trace_mce_record() looks like:

       mcegen.py-2715  [001] .N..  1049.818840: mce_record: [Hardware Error]: CPU:0     MC4_STATUS[Over|UE|-|PCC|AddrV|UECC]: 0xf604a00006080a41
[Hardware Error]:       MC4_ADDR: 0xbabedeaddeadbeef
[Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected
(CPU: 0, MCGc/s: 0/0, MC4: f604a00006080a41, ADDR/MISC: babedeaddeadbeef/dead57ac1ba0babe, RIP: 00:<0000000000000000>, TSC: 0, PROCESSOR: 0:0, TIME: 0, SOCKET: 0, APIC: 0)

Basically, the userspace daemon will consume the error string (after
it's been massaged into looking prettier and smaller :-)) (1st arg)
and dump it to some logs, and use some of the MCE fields to do error
collection and thresholding/ratelimiting/whatever.

While at it, I'm also looking very critically at the fields SOCKET,
APIC, TSC (we have walltime) for I'd like to drop them. Also, MC4 should
be MC4_STATUS btw.

To be continued...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
