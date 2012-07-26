Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2GZRGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:06:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55806 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2GZRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:06:44 -0400
MIME-Version: 1.0
In-Reply-To: <1343193053.3139.6.camel@dabdike>
References: <20120722163058.GB13376@localhost>
	<20120723111619.GT9222@suse.de>
	<1343042420.3027.11.camel@dabdike.int.hansenpartnership.com>
	<20120723114258.GV9222@suse.de>
	<20120723122905.GA22476@localhost>
	<BLU0-SMTP2254F8872DDE5FA6035CDE97DD0@phx.gbl>
	<20120724074844.GA9519@localhost>
	<BLU0-SMTP6C7CFCFF734FE10A39B6E97DC0@phx.gbl>
	<1343193053.3139.6.camel@dabdike>
Date: Thu, 26 Jul 2012 10:06:41 -0700
Message-ID: <CA+8MBbJkGN+zGBdD5Hg26wW_6E9L_ufoutn7wj+Y+nhtW7WKWg@mail.gmail.com>
Subject: Re: [next:akpm 129/309] net/core/sock.c:274:36: error: initializer
 element is not constant
From: Tony Luck <tony.luck@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: John David Anglin <dave.anglin@bell.net>,
        Fengguang Wu <fengguang.wu@intel.com>, Mel Gorman <mgorman@suse.de>,
        kernel-janitors@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 10:10 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>> Here is the line in sock.i:
>>
>> struct static_key memalloc_socks = ((struct static_key) { .enabled =
>> ((atomic_t) { (0) }) });
>
> The above line contains two compound literals.  It also uses a designated
> initializer to initialize the field enabled.  A compound literal is not a
> constant expression.

Seeing the same thing on ia64 building next-20120726.  Same fix works
for me ... so I'll steal this whole changelog and attributes.

-Tony
