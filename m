Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2DSRiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:38:08 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:53048 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab2DSRiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:38:05 -0400
Date: Thu, 19 Apr 2012 19:38:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
Message-ID: <20120419173802.GI3221@aftab.osrc.amd.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab>
 <20120419092630.GD29542@aftab>
 <4F904541.2030200@zytor.com>
 <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:27:09AM -0700, Linus Torvalds wrote:
> On Thu, Apr 19, 2012 at 10:02 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > ... and I would be *even happier* with an O(1) hash (which pretty much
> > *have* to be constructed at compile time.)
> 
> Taking relocations into account might be interesting for hashing. I
> guess you could hash the relative offsets, though.
> 
> But yeah, a hash might be the way to go, and once you generate the
> tables at compile-time, why not go all the way? It doesn't need to be
> some complex perfect hash, it should be fairly straightforward to just
> size the hash right and use some simple linear probing model for
> collissions or whatever.

Yeah, simplicity is the key here. I don't think we're getting that many
early boot exceptions due to rdmsr or whatever to warrant adding a bunch
of code.

OTOH, if we can share early and normal exception handling lookup code, then a
perfect hash would make sense as those exceptions would pile up.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
