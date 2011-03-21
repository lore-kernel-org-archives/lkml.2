Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1CUGy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 02:54:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55722 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1CUGyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 02:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uGkBiU08tlN+01Gi4342082fFUmK/g/EDcybr+oCoalOCmKMlIOEYGyUY9zh1K2Fd/
         hJIUSuLVgjKAxQKe9g89BFnJ9GtMW/hhioM2TAQ9t4azpN44wICmoAx9LJr/SFAoPIk5
         +Sz9C/Bj0f/JHNwKsYHATKb+It+m4N4w6CVpo=
MIME-Version: 1.0
In-Reply-To: <201103210153.10145.vapier@gentoo.org>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
	<201103210108.49780.vapier@gentoo.org>
	<AANLkTikSJDGEWCqazvAKHUC8_MoOP-+vyFOjyCmrA9dL@mail.gmail.com>
	<201103210153.10145.vapier@gentoo.org>
Date: Sun, 20 Mar 2011 23:54:55 -0700
Message-ID: <AANLkTimxWQZvtpe374Yju0O9BDMxDfBHsc1y3+c=M7D+@mail.gmail.com>
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

On Sun, Mar 20, 2011 at 10:53 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Monday, March 21, 2011 01:35:35 H.J. Lu wrote:
>> On Sun, Mar 20, 2011 at 10:08 PM, Mike Frysinger wrote:
>> > On Thursday, March 17, 2011 01:21:16 H.J. Lu wrote:
>> >> On Wed, Mar 16, 2011 at 7:57 PM, Mike Frysinger wrote:
>> >> > in looking at the gcc files, it doesnt seem like there's any defines
>> >> > setup to declare x32 directly.  instead, you'd have to do something
>> >> > like: #ifdef __x86_64__
>> >> > # if __SIZEOF_LONG__ == 8
>> >> > /* x86_64 */
>> >> > # else
>> >> > /* x32 */
>> >> > # endif
>> >> > #endif
>> >> >
>> >> > any plans on adding an __x32__ (or whatever) cpp symbol to keep people
>> >> > from coming up with their own special/broken crap ?  or are there some
>> >> > already that i'm not seeing ?
>> >>
>> >> The idea is in most cases, you only need to check __x86_64__ since x32
>> >> and x86-64 are very close.  In some cases, x32 is very different from
>> >> x86_64, like assembly codes on long and pointer, you can check
>> >> __x86_64__ and __LP64__. In glibc, I used a different approach by using
>> >> macros REG_RAX, .., MOV_LP, ADD_LP, SUB_LP and CMP_LP in assembly
>> >> codes.
>> >
>> > while i agree with you in general that this is how people should be doing
>> > things, in practice i often see people fishing around.  education only
>> > goes so far, so if there was an __x32__ define, i feel like people are
>> > more likely to get it right than wrong.
>> >
>> > i dont have any use cases off the top of my head, but i wouldnt be
>> > surprised if the heavy inline assembly people (like the multimedia peeps
>> > e.g. libav) approached it this way.  rather than google for
>> > documentation, look at the cpp output between -m64 and -mx32 and see
>> > what sticks out.  "__x32__" would certainly do that.
>>
>> My point is __x86_64__ version should work for both 64bit and x32. There
>> should no need for a separate x32 version.
>
> yes, and my point is that people often reach for cpp defines rather than
> figure out how to do it right.
>
> i'm not saying that __x32__ should be defined in place of __x86_64__, just
> that when -mx32 is used, __x32__ is additionally defined.  simply as an
> example, what i'm referring to could be accomplished by adding this to the
> *cpp specs:
>        %{mx32:-D__x32__=1}

I don't think it will help x32 and I think it will make it harder to
add x32 support.
I still want to see a real usage before I add it.


-- 
H.J.
