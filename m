Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab2DFUdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:33:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46016 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab2DFUdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:33:35 -0400
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com> <4F7F1659.5090305@zytor.com> <20120406201601.GA3310@p183.telecom.by>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120406201601.GA3310@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nextfd(2)
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 06 Apr 2012 13:33:19 -0700
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-ID: <180e9441-edd7-4a47-a307-eb3a8da45457@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is unreliable about it?  This is starting to be ridiculous.  As far as automounting /proc is concerned, this does not seem to be a significant problem with current userspace.

Alexey Dobriyan <adobriyan@gmail.com> wrote:

>On Fri, Apr 06, 2012 at 09:14:17AM -0700, H. Peter Anvin wrote:
>> On 04/06/2012 02:54 AM, Alexey Dobriyan wrote:
>> > 
>> > I agree, this particular changelog may be somewhat out of line.
>> > 
>> > But I find it little hypocritical that kernel developers add
>CONFIG_PROC_FS,
>> > fix compilation problems associated with it, do not mount proc by
>default,
>> > do not mark it unmountable somehow and
>> > then say procless setups aren't worth it.
>> > 
>> 
>> Aren't worth *optimizing for*.  But yes, CONFIG_PROC_FS is pretty
>much a
>> historic relic at this point, and probably should just be dropped.
>
>What to do with automounting /proc so it availablility would match
>syscall availability?
>
>> > Without proc knowledge about fdtable is gathered linearly and still
>unreliable.
>> > With nextfd(2), even procful environments could lose several
>failure branches.
>> 
>> What?  Please explain how on Earth this would "lose several failure
>> branches."
>
>closefrom(3) written via nextfd(2) loop is reliable and doesn't fail.
>closefrom(3) written via /proc/self/fd is reliable and can fail
>(including ENOMEM).
>closefrom(3) written via close(fd++) is unreliable.
>
>If programmer adds nextfd(2) loop before any closefrom(3) code
>he currently uses, there will be less failures.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
