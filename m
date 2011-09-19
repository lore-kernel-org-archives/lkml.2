Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab1ISWi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:38:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14512 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab1ISWiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:38:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=WAiDIQ2I52TUlO8NvU81OyWJR+X8n4YmgT2vLSpeMcznQ3NKevehy6c5I6EAFTUcX
	WWHhpHer0RcnApeP/umoA==
Date: Mon, 19 Sep 2011 15:38:10 -0700
From: Andrew Morton <akpm@google.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/5] lib: add unpack_hex_byte()
Message-Id: <20110919153810.ba0be83a.akpm@google.com>
In-Reply-To: <1316471708.3191.130.camel@localhost.localdomain>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
	<20110919141911.e13569ab.akpm@google.com>
	<1316471708.3191.130.camel@localhost.localdomain>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011 18:35:08 -0400
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > Wouldn't it be better to fix hex2bin() so that it returns -1 on error?
> 
> Yes, that was the original idea, but in order to return a result, it
> needs to validate the input.  The above code, or something similar,
> needs to exist somewhere, either in the new function or in hex2bin().
> Would something like this be any better?
> 
> int hex2bin(u8 *dst, const char *src, size_t count)
> {
> 	while (count--) {
>                 int hi = hex_to_bin(*src++);
>                 int lo = hex_to_bin(*src++);
> 
>                 if ((hi < 0) || (lo < 0))
>                         return -1;
> 
>                 *dst++ = (hi << 4) | lo;
>         }
> 	return 0;
> }
> 
> 
> > Then the above function becomes a one-liner:
> > 
> > 	return hex2bin(dst, src, 2);
> 
> Why bother?  With something like this, there isn't a need for the new
> function.  :-)

OK.

> > Finally, the name is poor.  It starts with "unpack_", so it belongs to
> > the "unpack" subsystem.  There's no such thing.  Something like
> > hex_byte_to_bin() would be better.
> 
> agreed.  It was suppose to parallel the existing pack_hex_byte().

hex_byte_pack() :)
