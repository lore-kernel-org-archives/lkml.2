Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1ASKf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 05:35:58 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:58486 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593Ab1ASKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 05:35:56 -0500
X-Greylist: delayed 1874 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2011 05:35:56 EST
Message-ID: <4D36B729.4040609@stericsson.com>
Date: Wed, 19 Jan 2011 11:04:25 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the rr tree
References: <20110119154210.435453e4.sfr@canb.auug.org.au>
In-Reply-To: <20110119154210.435453e4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 05:42 AM, Stephen Rothwell wrote:
> Presumably caused by commit b64781e8e2b0f480affb170460cbfb3b11fa9e5d
> ("param: add null statement to compiled-in module params").  I wonder how
> many more build errors this change may provoke.  Please try to find them
> and fix them before adding this change, thanks.
>    

It can provoke if I'm not mistaken, one more error. So two in total.

grep -r -E '^MODULE_.*\(.*\) *[^;]* *$' .
Yields a lot of false positives (enhancements welcome) that sifts down
to these two:

./net/dsa/dsa.c:MODULE_AUTHOR("Lennert Buytenhek <buytenh@wantstofly.org>")
./drivers/net/arm/ks8695net.c:MODULE_AUTHOR("Simtec Electronics")

I'll send patches for these two, so Rusty can apply them on
top of his next branch and be done with it.

> I used the version of the rr tree from next-20110118 for today.
>    

Couldn't find any more violators in the next tree.

There shouldn't be many: any file that is built as modules with
allmod will result in compile error even without this patch, the two above
must already be broken with allmodconfig, presumably they are
used in archs that do not enable loadable modules, so they don't
see the problem.

Yours,
Linus Walleij
