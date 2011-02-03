Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab1BCCgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:36:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54757 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab1BCCgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:36:14 -0500
X-User-Agent: K-9 Mail for Android
References: <4D41E86D.8060205@free.fr> <4D49DF35.5010608@zytor.com> <201102031149.36440.rusty@rustcorp.com.au> <201102031230.13759.rusty@rustcorp.com.au>
In-Reply-To: <201102031230.13759.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 02 Feb 2011 18:35:44 -0800
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Kees Cook <kees.cook@canonical.com>,
        matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <3ba4a711-ac8b-46aa-b585-51c8b9881c8c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we completely kill the "don't reload segments" flag, then?

"Rusty Russell" <rusty@rustcorp.com.au> wrote:

>On Thu, 3 Feb 2011 11:49:36 am Rusty Russell wrote:
>> On Thu, 3 Feb 2011 09:18:21 am H. Peter Anvin wrote:
>> > On 01/28/2011 08:58 AM, Jeremy Fitzhardinge wrote:
>> > > On 01/27/2011 07:38 PM, H. Peter Anvin wrote:
>> > >> [Adding Jeremy]
>> > >>
>> > >> Jeremy, would this break Xen?  As far as I know, Xen is the main
>user
>> > >> of skipping segment register initialization.
>> > > 
>> > > Xen doesn't go through head_*.S at all.
>> > > 
>> > 
>> > OK, I guess it's actually lguest which needs this feature?
>> 
>> Well, we already move __BOOT_DS into every other segment reg, so I
>don't think
>> %ss will break...
>> 
>> Checking...
>
>Fine here.
>
>Thanks,
>Rusty.
>PS.  In general, I don't want lguest to interfere with cleanups: I'd
>rather
>     fix up lguest as required until it gets too hard, then kill it.

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
