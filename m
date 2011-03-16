Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1CPMkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 08:40:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48160 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1CPMj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 08:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jw6U10Sy6LoBzR2gN/PSvBI9YW7W1XvcOEu3WBN7AlgstyXyPdrv2YFDqRTn5DXCC3
         nh4gOzmvH3AoStbg6Y5xWUQwKpqGGi5h7dHmz7xR1+HF/08OxIk8wqQ3hHfWWX1gXo0T
         csOctfpxVsk373klj2ZA2/T/LB36uELBDfX+w=
MIME-Version: 1.0
In-Reply-To: <201103160124.42939.vapier@gentoo.org>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
	<201103160030.27594.vapier@gentoo.org>
	<AANLkTimk3dfOBoPhGQ8NeOYY5rKdsefPm8gTJ-75vg3-@mail.gmail.com>
	<201103160124.42939.vapier@gentoo.org>
Date: Wed, 16 Mar 2011 05:39:57 -0700
Message-ID: <AANLkTim4w7zBBnsu+A1TMtb-wv60urDiSk5T0qbg7Oze@mail.gmail.com>
Subject: Re: X32 psABI status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: libc-alpha@sourceware.org, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 10:24 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Wednesday, March 16, 2011 00:51:37 H.J. Lu wrote:
>> On Tue, Mar 15, 2011 at 9:30 PM, Mike Frysinger <vapier@gentoo.org> wrote:
>> > On Wednesday, March 16, 2011 00:17:04 H.J. Lu wrote:
>> >> On Mon, Mar 7, 2011 at 1:33 PM, Mike Frysinger wrote:
>> >> > On Saturday, March 05, 2011 14:08:04 H.J. Lu wrote:
>> >> >> Many x32 bugs are fixed in kernel, glibc, binutils and GCC:
>> >> >>
>> >> >> https://sites.google.com/site/x32abi/
>> >> >>
>> >> >> The major remaining issues are glibc/gcc testsuite failures,
>> >> >> kernel core dump and signal handler unwind.
>> >> >
>> >> > are you getting a unique host tuple for this ?  or are you extending
>> >> > x86_64- linux-gnu ?  so the only way of knowing which ABI is to check
>> >> > for the output of the compiler+compiler flags ?
>> >>
>> >> x32 requires x32 enabled x86-64 kernel.
>> >
>> > ok, but that doesnt answer my question.  what are you passing to --target
>> > ?
>>
>> See:
>>
>> https://sites.google.com/site/x32abi/
>>
>> You configure it as
>>
>> CC="gcc -mx32" ...../configure x86_64- linux-gnu
>
> that isnt what the page says.  it does say for glibc to do:
>        CC="x32-gcc -mx32 " CXX="x32-g++ -mx32 " CFLAGS="-O2 -g"  ../configure
>
> but it doesnt say what to do for binutils or gcc itself.  obviously you cant
> use the -mx32 flag when building the cross gcc for the first time since the
> current native gcc wont support it.
>
> the invocation given for glibc implies that the proposed tuple is x32-linux-
> gnu, but the GNU config project doesnt support that tuple and i didnt see
> mention of it in the binutils or gcc sources.
>
> so we get back to my original e-mail:
>        are you getting a unique host tuple for this ?  or are you extending
>        x86_64-linux-gnu ?  so the only way of knowing which ABI is to check for
>        the output of the compiler+compiler flags ?

As I said, the target is x86_64- linux-gnu and you just add -mx32 to CFLAGS.
The x86_64- linux-gnu binutils and GCC support  x32.


-- 
H.J.
