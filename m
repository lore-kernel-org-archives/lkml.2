Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1BMXuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:50:46 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53570 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1BMXul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:50:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jv153waSuC2EPv6Chl80hqyQeQTmfMF1lkUFTdWMBoeTGe+r2aNj/JDcc+DXSmbwUH
         quyyVPnHe3Viq7xyMOBBXD5mmippJGJ3LIoFzu0EH9MlflH2TtXQPvRP1SCPaiU8B7+8
         KI0P4DoeXklJ8TeAM+ecxROxxTGOrPXquAUIo=
MIME-Version: 1.0
In-Reply-To: <20110213233926.1b3ca15a@lxorguk.ukuu.org.uk>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>
	<4D584A49.80306@zytor.com>
	<201102132328.15360.arnd@arndb.de>
	<4D585F5F.6030708@zytor.com>
	<20110213233926.1b3ca15a@lxorguk.ukuu.org.uk>
Date: Sun, 13 Feb 2011 15:50:40 -0800
Message-ID: <AANLkTinkCEoX1b71-G94NMpARyvaJ37etE93iTm3EMf7@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        x32-abi@googlegroups.com, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 3:39 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> a. the int $0x80 instruction is much slower than syscall.  An actual
>>    i386 process can use the syscall instruction which is disambiguated
>>    by the CPU based on mode, but an x32 process is in the same CPU mode
>>    as a normal 64-bit process.
>
> So set a flag, whoopee
>
>> b. 64-bit arguments have to be split between two registers for the
>>    i386 entry points, requiring user-space stubs.
>
> Diddums. Given you've yet to explain why everyone desperately needs this
> extra interface why do we care ?
>
>> All in all, the cost of an extra system call table is quite modest.
>
> And the cost of not doing it is a gloriously wonderful zero. Yo've still
> not explained the justification or what large number of apps are going to
> use it.
>
> It's a simple question - why do we care, why do we want the overhead and
> the hassle, what do users get in return ?
>

The real question is if we need to use ia32.  If the answer is yes, then
x32 provides the benefit of ia32 with register extended to 64bit plus 8
more registers as well as IP relative address.

-- 
H.J.
