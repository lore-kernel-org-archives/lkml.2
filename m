Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2AQAwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:52:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54066 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2AQAw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:52:29 -0500
MIME-Version: 1.0
In-Reply-To: <1326760869.16150.16.camel@sbsiddha-desk.sc.intel.com>
References: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
 <CA+55aFys9zddHAoKURGAeu0QYD_MC11uEyOQGU_4Ybsf200NkQ@mail.gmail.com> <1326760869.16150.16.camel@sbsiddha-desk.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 16:52:07 -0800
X-Google-Sender-Auth: 5XG8uwQom3aGW9FXivPH5XetfZA
Message-ID: <CA+55aFzGN59W5zhmc-kicQrpomAKLiwX4yBUsNcagwmM=Z8jxw@mail.gmail.com>
Subject: Re: [patch] x86, tsc: fix SMI induced variation in quick_pit_calibrate()
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, asit.k.mallick@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 4:41 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> also may be we should change the correction
>
> from: delta += (long)(d2 - d1)/2;
> to:   delta += (long)(d2 - d1)/4;
>
> I will give this patch a try.

Hmm. I get the feeling that we should remove that line entirely.

I think it actually makes the 'delta' less precise - the "d2-d1" thing
is how much of a difference there was in the first and last PIT MSB
differences, but while that difference might give some kind of error
estimate for how close we can expect 'delta' to be from correct, I
don't think we can really *add* that error to 'delta'. We might as
well subtract it (and we do - the sign is random and depends on which
one happened to be longer).

So I think that line should go away entirely. It doesn't have any
meaning. Yes, 'delta' may not be exact, but we don't know which
direction to correct into, so..

I realize that I wrote it, and that it as such must be bug-free, but I
suspect that removing that line is even *more* bug-free.

                 Linus
