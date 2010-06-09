Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0FISJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:09:57 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22740 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab0FISJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:09:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding;
	b=glFgVROqrgXpufTOH2WHNMTHV0tijNJTlCr5kg8eEr5UmCeEFLWMb4zpfFL6y/zvl
	BlSl8UIX80/37/hRGaMKg==
MIME-Version: 1.0
In-Reply-To: <20100609174744.GG6162@thunk.org>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
	<20100609094850.GA23292@elte.hu>
	<alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org>
	<20100609155041.GD6162@thunk.org>
	<alpine.LFD.2.00.1006090857530.4506@i5.linux-foundation.org>
	<20100609171015.GE6162@thunk.org>
	<alpine.LFD.2.00.1006091013340.4506@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006091023341.4506@i5.linux-foundation.org>
	<20100609173424.GF6162@thunk.org>
	<alpine.LFD.2.00.1006091041540.4506@i5.linux-foundation.org>
	<20100609174744.GG6162@thunk.org>
Date: Wed, 9 Jun 2010 11:09:49 -0700
Message-ID: <AANLkTikK6uiUsXrkFTextP4dmd0E6mddpYmvx7cT83-f@mail.gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be 
	reused immediately.
From: Salman Qazi <sqazi@google.com>
To: tytso@mit.edu, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       akpm@inux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 10:47 AM,  <tytso@mit.edu> wrote:
> On Wed, Jun 09, 2010 at 10:43:33AM -0700, Linus Torvalds wrote:
>>
>> We need that bitmap to handle the overflow max_pid case. We are _not_
>> returning just increasing pid numbers.
>
> Doh!  I knew I was forgetting something obvious.  I was hoping we
> could get rid of the bitmap entirely, but I guess not....
>
> (Unless users would stand for 64-bit pid numbers... no?  Dang. :-)
>
>                                      - Ted
>

(sorry about the previous message, to those who got it... my mail
client silently switched to HTML mode)

I am working on a new version of the change taking into account
comments (both about substance and style) by Michel, Ted and Linus.  I
agree with Michel in that I am not sure that the rare case of same
last_pid being set by two threads is worth fixing.
