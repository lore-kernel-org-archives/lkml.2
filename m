Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab0HLQYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:24:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab0HLQYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OSd6dWruAN0OngiNV2J02VR1XFVCUUbAtxoi7v8lbp6lMZzo7mgP1dzrQgrUb0o/U9
         GG6Ez8BpJtM8YGiqM3qOPLxnrNtyytyuqhLAxi0aw5XQo27FttNaRp1LEzs3VX1Z0eLa
         LeHQEG+afNOeW7cjPGdBE/WPeE8Q1j703jEYs=
Message-ID: <4C642047.6030108@gmail.com>
Date: Thu, 12 Aug 2010 18:24:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Jiri Slaby <jslaby@suse.cz>, akpm@linux-foundation.org,
        linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] BLOCK: fix bio.bi_rw handling
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz> <1281616266-4709-3-git-send-email-jslaby@suse.cz> <20100812160809.GC28689@lst.de>
In-Reply-To: <20100812160809.GC28689@lst.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 06:08 PM, Christoph Hellwig wrote:
> On Thu, Aug 12, 2010 at 02:31:06PM +0200, Jiri Slaby wrote:
>> Return of the bi_rw tests is no longer bool after commit 74450be1. But
>> results of such tests are stored in bools. This doesn't fit in there
>> for some compilers (gcc 4.5 here), so either use !! magic to get real
>> bools or use ulong where the result is assigned somewhere.
> 
> I'd have to look at my copy of the C standard if it's guaranteed,

§6.5.3.3 of ANSI C99, par 5:
The result of the logical negation operator ! is 0 if the value of its
operand compares unequal to 0, 1 if the value of its operand compares
equal to 0. The result has type int. The expression !E is equivalent to
(0==E).

On == (§6.5.9 par 3):
The == (equal to) and != (not equal to) operators are analogous to the
relational operators except for their lower precedence. Each of the
operators yields 1 if the specified relation is true and 0 if it is
false. The result has type int. For any pair of operands, exactly one of
the relations is true.

On bool => _Bool (§6.2.5 par 2)
An object declared as type _Bool is large enough to store the values 0
and 1.

So it should be safe :).

BTW just of curiosity, sizeof(bool) is 1 here (8 bits).

regards,
-- 
js
