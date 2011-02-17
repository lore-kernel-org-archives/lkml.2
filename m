Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1BQWVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:21:13 -0500
Received: from [65.115.85.69] ([65.115.85.69]:9755 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753176Ab1BQWVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:21:11 -0500
Date: Thu, 17 Feb 2011 14:19:57 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: David Miller <davem@davemloft.net>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
Message-ID: <20110217221957.GA11244@dtor-ws.eng.vmware.com>
References: <AANLkTinA-OP69fqf5jLfedk=dL2vmwdUyzn5E6FHR=Zw@mail.gmail.com>
 <20110217.131702.112601300.davem@davemloft.net>
 <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
 <20110217.140119.39175251.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217.140119.39175251.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 02:01:19PM -0800, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Thu, 17 Feb 2011 13:54:57 -0800
> 
> > Is there a -fdata-align or something? Or would __attribute__((packed))
> > help? Something that explicitly tells gcc "don't do this", instead of
> > "let's add indirection and hope gcc doesn't add alignment for _that_".
> > Especially as the extra pointer makes the code even uglier.
> 
> The tracing folks went down the path of trying to use packed in
> various ways, to no avail, because no matter what they tried it broke
> other things.
> 
> > And if we do have to use the pointer thing, let's at least then do the
> > pointer with asms, so that gcc _really_ can't screw it up. Rather than
> > just move the potential bug around.
> 
> That's fine with me.

Any pointers as to how to emit these pointers with asm?

-- 
Dmitry
