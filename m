Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1AVUBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:01:30 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54169 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1AVUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:01:28 -0500
Date: Sat, 22 Jan 2011 21:01:27 +0100
From: Andreas Mohr <andi@lisas.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: tiwai@suse.de, jirislaby@gmail.com, perex@perex.cz,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH 1/1] SOUND: azt3328, fix broken AZF_FMT_XLATE macro
Message-ID: <20110122200127.GA1824@rhlx01.hs-esslingen.de>
References: <1295704570-27015-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295704570-27015-1-git-send-email-jslaby@suse.cz>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 02:56:10PM +0100, Jiri Slaby wrote:
> Despite the AZF_FMT_XLATE macro looks totally weird and useless, it's
> heavily broken (apart it also broke my parser).
> The 'break' in the macro belongs to the do-while loop and not to the
> switch. So it always falls through the all cases till the end.
> 
> Remove the do-while from the macro.

Hmm, there doesn't remain much to say other than "Double ouch. Mea culpa.".

However I'd like to add one bit, that the usual macro-side
do ... while(0) loop has been added by me due to a checkpatch.pl warning
which called for attention. IOW, it could be argued that checkpatch.pl
led people into ""improving"" formely "working" (whatever one may think of it)
code.
Something to be investigated, methinks.

> Also people should terminate statements with semicolons. So force
> people to do so by removing the last one in the macro.

Oh dammit of course, I'm normally implementing it this way as well.
Unfortunately I failed to submit it that way in this particular case.

> I vote for removing that crap completely because it makes the code
> weird anyway -- you have to specify manually both of freq and bits
> which is I would expect to be avoided exactly by such a macro.

The reason that it broke your parser is certainly a very valid one.
Macro syntax is known to be arcane and quite variable between compilers
(e.g. I read that the gcc people said that they were the only one who
_really_ grokked macro evaluation order and token pasting the way
it was meant to be implemented - go figure...).

As such I support a change here.
I'll try to come up with a translation table instead, 
or else probably best just revert this wetware fart.

Thanks,

Andreas Mohr
