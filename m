Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab1D0CBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:01:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab1D0CBX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110427013541.18526.qmail@science.horizon.com>
References: <20110427013541.18526.qmail@science.horizon.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Apr 2011 19:00:33 -0700
Message-ID: <BANLkTikwddt4xJoq+pAirKkKg3zNQ26iNA@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] signal: sys_sigprocmask() needs retarget_shared_pending()
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 6:35 PM, George Spelvin <linux@horizon.com> wrote:
>>
>> which handles all cases correctly (just "andn clear" + "or set") with
>> no if's or switch'es.
>
> Gripe: Arrgh, apostrophe disease!  Linus, youre picking up nasty habits.

I didn't want to make C keywords into English words. So if it's about
English words it's "no ifs or buts", but when talking about C keywords
it's "if's or switch'es".

That's my stand, and I'll stick to it. At least until next time, when
I might decide on yet another arbitrary rule ;)

> Suggestion: Actually, the usual, more flexible implementation, is
> "andn mask" + "xor set".  That gives all 4 bit operations (nop, set,
> clear, and toggle) unique bit combinations.

Yeah, we can do that too. I agree it is more flexible, although I
don't think we'd ever need it.

And I'm not sure it's more "usual" - most drivers I've seen (where
this kind of "clear/set mask" issue comes up pretty often) tend to use
the simpler clear/set model, because it tends to make the usage more
sensible. Most users simply don't tend to need the toggle operation.

But my grep-fu to actually show examples is weak. One example I found would be

 - drivers/media/video/tw9910.c: tw9910_mask_set()

which uses that "andnot + or" model I suggested.

But I'm sure there are "andnot + xor" uses out there too.

And I don't actually mind either way. I'd certainly be perfectly ok
with the andn/xor model. It's just the "how" model I detest.

                            Linus
