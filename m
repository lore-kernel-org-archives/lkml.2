Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab1JQLZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:25:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60009 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab1JQLZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:25:17 -0400
MIME-Version: 1.0
In-Reply-To: <20111013165431.b84ffab4.akpm@linux-foundation.org>
References: <1318408317.2891.3.camel@br98xy6r> <20111013165431.b84ffab4.akpm@linux-foundation.org>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 17 Oct 2011 09:24:57 -0200
Message-ID: <CAGje9yQOmBe45DC_k67AL4V24Pkr_+6MRFK4Gfj9uYNEGVOpkg@mail.gmail.com>
Subject: Re: [PATCH] Fix strim() semantics for strings that have only blanks
To: Andrew Morton <akpm@linux-foundation.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

On Thu, Oct 13, 2011 at 8:54 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 12 Oct 2011 10:31:57 +0200
> Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
>
>> Hello Andre,
>>
>> With git commit 84c95c9acf088c99d8793d78036b67faa5d0b851 a patch from
>> you went upstream where you wanted to improve the performance of the
>> strim() function.
>>
>> Unfortunately this changed the semantics of strim() and broke my code. Before
>> the patch it was possible to use strim() without using the return value for
>> removing trailing spaces from strings that had either only blanks or only
>> trailing blanks.
>>
>> Now this does not work any longer for strings that *only* have blanks.
>>
>> Before patch: "   " -> ""    (empty string)
>> After patch:  "   " -> "   " (no change)
>>
>> I think we should remove your patch to restore the old behavior.
>>
>> >From the description (lib/string.c):
>>
>>  * Note that the first trailing whitespace is replaced with a %NUL-terminator
>>
>> => The first trailing whitespace of a string that only has whitespace
>>    characters is the first whitespace
>
> Yes, that change makes sense.

breaking your code was not good at all. Is it maintained off tree?
I believe It happened because you use strim() without using its return.
In any case, I'm OK on reverting it to fix your problem.

Thanks,
André
