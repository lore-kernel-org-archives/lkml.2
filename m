Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1I0Rv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:51:29 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:44870 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab1I0Rv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:51:28 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] mtd: Add DiskOnChip G3 support
References: <1316633266-21312-1-git-send-email-robert.jarzmik@free.fr>
	<1316702729.4849.114.camel@sauron> <87mxdwiicc.fsf@free.fr>
	<201109271539.21533.arnd@arndb.de>
X-URL: http://belgarath.falguerolles.org/
Date: Tue, 27 Sep 2011 19:51:18 +0200
In-Reply-To: <201109271539.21533.arnd@arndb.de> (Arnd Bergmann's message of
	"Tue, 27 Sep 2011 15:39:21 +0200")
Message-ID: <878vp96fhl.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Thursday 22 September 2011, Robert Jarzmik wrote:
>> >> +#define doc_flashSequence(seq)                                              \
>> >> +do {                                                                        \
>> >> +    doc_dbg("doc_flashSequence: %02x " #seq "\n", DoC_Seq_##seq);   \
>> >> +    doc_writeb(DoC_Seq_##seq, DoC_FlashSequence);                   \
>> >> +} while (0)
>> >> +
>> ...zip...
>> >
>> > Could you please turn these macros into 'static inline' function - this
>> > is one of the modern patterns of kernel programming - we try to use
>> > functions for better type checking.
>>
>> No sorry, that I cannot. If you look closely, the ##seq is not something you can
>> convert with an inline function, neither the #seq.
>
> Better not obfuscate the code like that then ;-)
>
> Really, passing the entire register name into an inline function is much
> preferred over string concatenation, because it lets you grep for where
> certain definitions are used.
Right. But how do handle the "#seq" then ?

The whole point here is to write humanly readable debug messages. A message of
the like "doc_flashsequence: 48 SET_PLANE1" is much better than
"doc_flashsequence: 48", don't you think ?

If we consider to loose that debugging messages, it's way easier to drop the "do
.. while(0)" sequences, and just keep the register write.

Now if you're convinced removing the "SET_PLANE1" debugging message is less
important that ability to grep the full register name, why not, but from a
maintenance point of view I would prefer letting the "macroness" in.

> You can also convert them to ALL_CAPS
> identifiers instead of cAmeLCAsE.
Point taken for V6.

>
> Finally, don't use the __raw_readb() style functions but instead use
> the regular readb() style, which is the correct one to use in device
> drivers.
Point taken for V6.

Cheers.

-- 
Robert
