Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab0L0VBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:01:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65512 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0L0VBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:01:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=vY4y9F0XAs2mLPePrOe0HzK6jSydW/C7JP0UZDKfNqmJ+ILpkmQ/1s3buBQoVyj76r
         b8zgoGqZftuXToz2uHjTwYNH3utrEoYvnIFoijeyrr4bK++wC8VY23LO7m1XLlBCCAxy
         1EFEvpgOkVYOyRMW/QwVMT7r4JN7AvZVjTp7s=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: no need to initialize the entire temporary buffers in synthesize_perf_probe_point()
References: <m3wrn07blu.fsf@gmail.com> <4D142591.2030101@hitachi.com>
Date: Mon, 27 Dec 2010 22:01:44 +0100
In-Reply-To: <4D142591.2030101@hitachi.com> (Masami Hiramatsu's message of
	"Fri, 24 Dec 2010 13:46:09 +0900")
Message-ID: <m3tyhzvsjr.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:

> (2010/12/24 0:27), Franck Bui-Huu wrote:
>> From: Franck Bui-Huu <fbuihuu@gmail.com>
>> 
>> This patches only put a single null byte at the beginning of each
>> temporary buffers line[], offs[], file[] instead of filling their full
>> contents with null bytes.
>
> Hmm, sorry but NAK it.
>

No problem :)

>
> IMHO, with modern chips, the original code has no problem from the
> viewpoint of memory access (all are cached and no need to access just
> one byte) nor a bottleneck.

I'm not sure to understand this.

But my point is that you're clearing the whole buffers with 0 although
you just need to initialize them with the null string (a single null
byte at the beginning).

So you're doing useless memory accesses (cached or not).

I agree with you that it won't make any speed improvements though, but
it was just clearer for me, since what you want are null strings and not
a char arrays fill with 0.

Thanks.
-- 
		Franck
