Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1BQWAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:00:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39686
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab1BQWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:00:43 -0500
Date: Thu, 17 Feb 2011 14:01:19 -0800 (PST)
Message-Id: <20110217.140119.39175251.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: dtor@vmware.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        rusty@rustcorp.com.au, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
References: <AANLkTinA-OP69fqf5jLfedk=dL2vmwdUyzn5E6FHR=Zw@mail.gmail.com>
	<20110217.131702.112601300.davem@davemloft.net>
	<AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 13:54:57 -0800

> Is there a -fdata-align or something? Or would __attribute__((packed))
> help? Something that explicitly tells gcc "don't do this", instead of
> "let's add indirection and hope gcc doesn't add alignment for _that_".
> Especially as the extra pointer makes the code even uglier.

The tracing folks went down the path of trying to use packed in
various ways, to no avail, because no matter what they tried it broke
other things.

> And if we do have to use the pointer thing, let's at least then do the
> pointer with asms, so that gcc _really_ can't screw it up. Rather than
> just move the potential bug around.

That's fine with me.
