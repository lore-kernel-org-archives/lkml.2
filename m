Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502Ab1D1OSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:18:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab1D1OSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:18:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
Date: Thu, 28 Apr 2011 16:16:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Rabin Vincent <rabin@rab.in>, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        Peter Maydell <peter.maydell@linaro.org>
References: <Pine.LNX.4.44L0.1104280934080.2108-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104280934080.2108-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281616.40253.arnd@arndb.de>
X-Provags-ID: V02:K0:0TBBRrl7FaXQy4sXB1W5DOUqenXxx+u47ErlkefLcQG
 VbyuZKnDzcxO9H86zIfoBTIiESQQgbgkZBwMo78pagwZd3iGKZ
 4xVtbvYHzrEogA2cT5kU40pJ5fNhH0TdS7mbuppLIKrmoCze++
 COxvtA9+DkK8toGTeiPvQwBKRlk8K9s12Npeag6dxPsJBgh/sH
 nWk3GMu/cFxjQ1+xyWkRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011, Alan Stern wrote:
> > The compiler does not complain, it just silently assumes that it needs
> > to do byte accesses. There is no way to tell the compiler to ignore
> > what it knows about the alignment, other than using inline assembly
> > for the actual pointer dereference. Most architectures today do that,
> > but on ARM it comes down to "*(u32 *)status_reg = temp".
> 
> Ah -- so the compiler associates the alignment attribute with the data 
> value and not with the variable's type?  I didn't know that.

The behavior here is unspecified because the underlying typecase
is not valid. Gcc apparently uses some heuristics trying to do
the right thing, and in recent versions that heuristic seems to
have changed.

	Arnd
