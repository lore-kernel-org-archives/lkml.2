Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab1KVLtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:49:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4636 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab1KVLtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:49:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 Nov 2011 03:48:10 -0800
From: Oleg Strikov <OSTRIKOV@nvidia.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Will Deacon <will.deacon@arm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, William Cohen <wcohen@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Anton Blanchard <anton@samba.org>, Eric B Munson <emunson@mgebm.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>
Date: Tue, 22 Nov 2011 12:48:07 +0100
Subject: RE: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Thread-Topic: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Thread-Index: AcypCZ1dEi8XkObAQYuCsn3cPLtfJwAApKRw
Message-ID: <68B2676CBD57C643A577008EC1419ED1504663E236@DEMAIL01.nvidia.com>
References: <20111121145114.049265181@chello.nl>
	 <20111121145337.533322271@chello.nl>
	 <20111121172323.GH20611@mudshark.cambridge.arm.com>
	 <1321903090.28118.21.camel@twins>
	 <20111121203145.GA7301@mudshark.cambridge.arm.com>
	 <1321907755.28118.30.camel@twins>
	 <20111121224343.GA7862@mudshark.cambridge.arm.com>
 <1321961180.5148.31.camel@twins>
In-Reply-To: <1321961180.5148.31.camel@twins>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAMBnCs9031538

I was hoping that with the userspace access to the counters disabled I get zeroes/trash from the counters.
But unfortunately I got SIGILL which is bad. But at least I've made a test.

-----Original Message-----
From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] 
Sent: Tuesday, November 22, 2011 3:26 PM
To: Will Deacon
Cc: mingo@elte.hu; William Cohen; linux-kernel@vger.kernel.org; Michael Cree; Deng-Cheng Zhu; Anton Blanchard; Eric B Munson; Heiko Carstens; Paul Mundt; David S. Miller; Richard Kuo; Stephane Eranian; Arun Sharma; Vince Weaver; Oleg Strikov
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()

On Mon, 2011-11-21 at 22:43 +0000, Will Deacon wrote:
> On Mon, Nov 21, 2011 at 08:35:55PM +0000, Peter Zijlstra wrote:
> > On Mon, 2011-11-21 at 20:31 +0000, Will Deacon wrote:
> > > On Mon, Nov 21, 2011 at 07:18:10PM +0000, Peter Zijlstra wrote:
> > > > But does ARM have a read PMU counter from userspace 
> > > > instruction/capability?
> > > 
> > > In ARMv7, you can enable user access to the performance counters 
> > > but the access is R/W so I don't think it's something we want to 
> > > do (could interfere with another task doing system-wide profiling).
> > 
> > Yeah, write access is pushing it a bit.. 
> 
> Perhaps we could disable it while per-cpu events are running, although 
> I think this will probably just lead to SIGILL central for anybody 
> trying to use the counters in userspace.

One possibility would be to do as I did in patch 4, except ARM has it disabled by default and the folks who think they know WTF they're doing can enable it or so.

Ostrikov mentioned on #kernelnewbies he wanted to have this enabled because apparently games use it. He mentioned toggling the user access on/off depending on if the kernel was using perf or not, but that would create very unreliable service.

Best would be to use perf to program the thing and use the userspace read and simply agree not to write to these registers (and pray people don't)..

Also, for those ARMs that do have a user readable clock, you could support the new time_{mult,shift,offset} from patch 5.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
