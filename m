Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1CUFfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 01:35:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34577 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1CUFfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 01:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f2+Fl/58c5DJP/jDk4nw6QlfJnY6GnVlpc2aGNootgnXLgAXsM5yrMjhvsLOObUDDV
         ByzzG1sJbXsdxjWVQasBmDOo83HcdzfWcvUGOUGy8tPXkElaTtW9CYa7XZmJo3LTy9p/
         Hl+1JvgR4seDKRiD0w8yHCKmtvdhKw/OAAq50=
MIME-Version: 1.0
In-Reply-To: <201103210108.49780.vapier@gentoo.org>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
	<201103162257.10440.vapier@gentoo.org>
	<AANLkTikfiVvxrxakH-_pch6v0jkT1yZstw4kXShyx+Sd@mail.gmail.com>
	<201103210108.49780.vapier@gentoo.org>
Date: Sun, 20 Mar 2011 22:35:35 -0700
Message-ID: <AANLkTikSJDGEWCqazvAKHUC8_MoOP-+vyFOjyCmrA9dL@mail.gmail.com>
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

On Sun, Mar 20, 2011 at 10:08 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Thursday, March 17, 2011 01:21:16 H.J. Lu wrote:
>> On Wed, Mar 16, 2011 at 7:57 PM, Mike Frysinger <vapier@gentoo.org> wrote:
>> > in looking at the gcc files, it doesnt seem like there's any defines
>> > setup to declare x32 directly.  instead, you'd have to do something
>> > like: #ifdef __x86_64__
>> > # if __SIZEOF_LONG__ == 8
>> > /* x86_64 */
>> > # else
>> > /* x32 */
>> > # endif
>> > #endif
>> >
>> > any plans on adding an __x32__ (or whatever) cpp symbol to keep people
>> > from coming up with their own special/broken crap ?  or are there some
>> > already that i'm not seeing ?
>>
>> The idea is in most cases, you only need to check __x86_64__ since x32 and
>> x86-64 are very close.  In some cases, x32 is very different from x86_64,
>> like assembly codes on long and pointer, you can check __x86_64__ and
>> __LP64__. In glibc, I used a different approach by using macros REG_RAX,
>> .., MOV_LP, ADD_LP, SUB_LP and CMP_LP in assembly codes.
>
> while i agree with you in general that this is how people should be doing
> things, in practice i often see people fishing around.  education only goes so
> far, so if there was an __x32__ define, i feel like people are more likely to
> get it right than wrong.
>
> i dont have any use cases off the top of my head, but i wouldnt be surprised
> if the heavy inline assembly people (like the multimedia peeps e.g. libav)
> approached it this way.  rather than google for documentation, look at the cpp
> output between -m64 and -mx32 and see what sticks out.  "__x32__" would
> certainly do that.

My point is __x86_64__ version should work for both 64bit and x32. There should
no need for a separate x32 version.


-- 
H.J.
