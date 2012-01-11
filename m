Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab2AKDPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 22:15:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39480 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2AKDPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 22:15:18 -0500
MIME-Version: 1.0
In-Reply-To: <7vehv77xeq.fsf@alter.siamese.dyndns.org>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
 <20120110184530.GE7164@opensource.wolfsonmicro.com> <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
 <20120110222711.GK7164@opensource.wolfsonmicro.com> <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
 <7vmx9v7z1r.fsf@alter.siamese.dyndns.org> <CA+55aFx5NATrpLnkMiV2vAxSAJPK7wkY2vyHbyeZGgT9+jP06w@mail.gmail.com>
 <7vehv77xeq.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 19:14:55 -0800
X-Google-Sender-Auth: 3AFCAxNwWu_5bC4iTNF-jnRfmV4
Message-ID: <CA+55aFzuGtJkQFDooSGWQ2_NiJVHN2E7S5dmOnWTYn8_s8Gg3g@mail.gmail.com>
Subject: Re: Regulator updates for 3.3
To: Junio C Hamano <gitster@pobox.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 7:03 PM, Junio C Hamano <gitster@pobox.com> wrote:
>>
>> I really wonder. Because not being default will always lead to really
>> odd ways of saying "it should have been default, so we'll make up
>> these complex and arbitrary special rules" (like the ones you were
>> starting to outline).
>
> Hrm. Lack of any quoted line other than the first line from my message,
> together with (c) above, makes me suspect that you did not read beyond the
> first line before composing this message you are responding to.

No. See again. I did read your suggestion, and that's where the "we'll
make up these complex and arbitrary special rules" comment comes from.
Did I mis-understand it?

I think it's a *horrible* idea to go down the road or some
branch-specific configurations and then, and I quote:

  "depending on the combination of what is being merged into what,
toggle the --edit option by default"

THAT is the kind of design that sounds crazy.

Instead, just make editing the default. No ifs, buts, or maybe. No
configuration, no complexities - just make it act the same way our
pager logic acts (ie redirecting stdin/stdout obviously shuts down the
pager, and equally obviously needs to shut down the editor).

Then, the --edit/--no-edit flags are for future users that want to
make it explicit. But they aren't about rules, they are about just
making very explicit statements of "I don't want the editor".

The (b) thing I suggested was for "work around for people who have
legacy cases that they don't want to make explicit". I guess you could
count that as some rule, but I really think it's more of a "ok, we had
bad legacy behavior, and now we have scripts that depended on that bad
legacy".

But the notion of complex rules? That sounds really really bad. I'd
much rather get *rid* of the one complex rule we have (the "merging a
tag implies --edit"). That rule is already a hack.

                   Linus
