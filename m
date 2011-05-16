Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1EPIxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:53:51 -0400
Received: from service87.mimecast.com ([94.185.240.25]:55399 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751121Ab1EPIxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:53:50 -0400
Subject: Re: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=3A?= problem with kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: ttlxzz ccc <boyzccc@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTinv6aSQMgh9ce1xaQ14_aHDPvFTxw@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	 <BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	 <BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	 <009c01cc108b$4635c7d0$d2a15770$@com>
	 <BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
	 <BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
	 <BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
	 <BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
	 <BANLkTik6c8-g8FrXZy8-V35W6-Th++5p_A@mail.gmail.com>
	 <BANLkTi=bYzYrHx+P=yTH_0VTiQaGZHeB9A@mail.gmail.com>
	 <BANLkTinv6aSQMgh9ce1xaQ14_aHDPvFTxw@mail.gmail.com>
Organization: ARM Limited
Date: Mon, 16 May 2011 09:53:36 +0100
Message-ID: <1305536016.19230.3.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 16 May 2011 08:53:45.0031 (UTC) FILETIME=[C360ED70:01CC13A6]
X-MC-Unique: 111051609534606801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 08:18 +0100, ttlxzz ccc wrote:
> I'm very glad to find the reason of this problem. It's just because
> the CONFIG_FRAME_POINTER is not set :).
> 
> And in dump_stack() which is defined in arch/x86/kernel/dumpstack.c,
> CONFIG_FRAME_POINTER control whether to get the bp.
> 
> Now I enable CONFIG_FRAME_POINTER and I can see the full backtrace. :)

It's good you found it. I thought STACKTRACE on x86_64 would set the
necessary options like FRAME_POINTER so that it works properly. Kmemleak
only sets STACKTRACE.

-- 
Catalin


