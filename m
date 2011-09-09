Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab1IIVNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:13:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505Ab1IIVNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:13:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3 24/36] Hexagon: Provide basic implementation and/or stubs for I/O routines.
Date: Fri, 09 Sep 2011 23:13:12 +0200
Message-ID: <1883807.RYWKjfNqKd@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909191412.GB2034@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.993872033@codeaurora.org> <20110909191412.GB2034@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZZ1KdIVHMmHQR/OovnbboDWTGuwZtTI4Ge9D/Dny75y
 mxMDiAIRIUzZ5W5K7FboN4Q/Pi9TpU4XqZTSecwO84w6sYsJOQ
 TnmjNqzgTZospaVtkuis26SMiyN8wDFDfzmWMfzvCxHEC2kZa/
 lFjzlvGGAaO7Up5xehn2tZ3X4aIC95NE0/JvmQ0dKAjkzKmEta
 EQlMuKv3a/2TkjOe5QeOEiwi6t+9GKIdaXDdcA004aYtTg0Qyn
 eN1Mb2MH3GBnhe97zjiDaxljBuLSzSVD99HqbREbAzNx9ZusZJ
 HqE0OfwIuoNp84DaYg3mD7/jUxT07QUceY7230n40dGrgLJn1M
 9IXq8SBYa5qWg/6AHqQs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011 14:14:13 Linas Vepstas wrote:
> On Thu, Sep 08, 2011 at 08:09:11PM -0500, Richard Kuo wrote:
> > +     asm volatile(
> > +             "memb(%0) = %1;"
> > +             :
> > +             : "r" (addr), "r" (data)
> > +     );
> 
> I'm kind-of vague on this, but I think that this also needs a
> : "memory" at the end (to indicate that the asm snippet clobbers
> memory), as otherwise the compiler may be tempted to reorder
> these around other memory accesses. That is, the "volatile"
> keyword is not enough (well, I'm not sure...), but I think
> "volatile" only prevents the compiler from optimizing these
> away completely, but is not enough to prevent unwanted
> re-ordering.

Yes, absolutely correct. Specifically, this is required for the
case where you first store values into regular memory and then
use the writel() to trigger a DMA operation. Without the memory
clobber, the dma may read from memory before the CPU has accessed
it in case the store gets scheduled after the writel by the compiler.

	Arnd
