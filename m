Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1JWVTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:19:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48139 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1JWVTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:19:43 -0400
MIME-Version: 1.0
In-Reply-To: <4EA449DD.1010801@redhat.com>
References: <1319229182-32226-1-git-send-email-jistone@redhat.com>
 <CA+55aFzXHLrcP1idskKJXcxdPfjSCfgmtYzd7r4uA4ni1E+k+A@mail.gmail.com> <4EA449DD.1010801@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Oct 2011 23:19:21 +0200
X-Google-Sender-Auth: TzM1_lSqHtTtxisEUKJNYBS0A6M
Message-ID: <CA+55aFzxf1XMvMBrHzbrUKunWrPZx0Q=2=DyWv9HDpQ3Zc40ZQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix compilation bug in kprobes' twobyte_is_boostable
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 7:07 PM, Josh Stone <jistone@redhat.com> wrote:
>
> Unfortunately, no.  Whatever const-propagation gcc is doing here
> (somewhat wrongly per PR50571) is not affected by volatile on that cast.
>  I also tried leaving it to the parameter type (no cast), no help.

Oh, ok.

> I just tried removing the const from twobyte_is_boostable[], and that
> also does the trick.  Not sure why I didn't try that first -- I guess
> because I saw all the volatiles in bitops.  Is that more palatable, or
> would you still rather try to fix it in bitops.h directly?

I guess there's no nice bitops.h fix, so maybe the minimal "remove
const" is the right thing to do.

>>  - Long long ago, we had that "big array" approach for ADDR too. So
>> we've wavered between the volatile and using a block memory op. But
>> we've used the "volatile" for a long time now for the bit change ones,
>> so I don't think we should mix concepts like your patch.
>
> Do you recall why it settled on volatile?  That seems like the less
> descriptive of the two approaches.  But "long long ago" appears to be
> beyond recorded (git) history...

Yeah, it's really long ago. Iirc the reason it got removed was that
there were gcc versions that were unhappy about it, we've had problems
in this area before..

             Linus
