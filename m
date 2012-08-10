Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2HJM45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:56:57 -0400
Received: from seven.medozas.de ([5.9.24.206]:42204 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab2HJM4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:56:55 -0400
Date: Fri, 10 Aug 2012 14:56:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Kay Sievers <kay@vrfy.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Jukka Ollila <jiiksteri@gmail.com>, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Regression - /proc/kmsg does not (always) block for 1-byte
 reads
In-Reply-To: <CAPXgP12vGkh1q4-L3+wYY5XWZURBXOWQCmovARr0cbf+dHinVQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1208101455420.23731@frira.zrqbmnf.qr>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com> <20120706203825.20ce3e47@pyramind.ukuu.org.uk> <CA+55aFy7RncR_z9M+DRzSXJY7cWxY9zG0ioLdiefhxkH__Z7Yw@mail.gmail.com>
 <CAPXgP12vGkh1q4-L3+wYY5XWZURBXOWQCmovARr0cbf+dHinVQ@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2012-07-07 23:19, Kay Sievers wrote:
>On Fri, Jul 6, 2012 at 10:30 PM, Linus Torvalds
><torvalds@linux-foundation.org> wrote:
>> Kay, this needs to be fixed.
>>
>> Suggested fix: just use the 'seq_printf()' interfaces, which do the
>> proper buffering, and allow any size reads of various packetized data.
>
>I'll have a look.
>
>> Of course, I'd also suggest that whoever was the genius who thought it
>> was a good idea to read things ONE F*CKING BYTE AT A TIME with system
>> calls for each byte should be retroactively aborted. Who the f*ck does
>> idiotic things like that? How did they noty die as babies, considering
>> that they were likely too stupid to find a tit to suck on?
>
>Maybe the bs=1 in the dd call stands for bullshit. :)

It seems people need to be taught to use ddrescue, stringently.
Having to calculate appropriate values for bs= and count= when
you just want to transfer bytes is already a crime, not to mention
the problem when you have a prime number of bytes to transfer.
