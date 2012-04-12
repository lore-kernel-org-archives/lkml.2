Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762309Ab2DLJ1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:27:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab2DLJ1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:27:05 -0400
Message-ID: <4F869FE6.6060400@suse.cz>
Date: Thu, 12 Apr 2012 11:27:02 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, lacombar@gmail.com
Subject: Re: [PATCH 0/5] RFC: strip 15,000 lines from a typical autoconf.h
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com> <CA+55aFy-CeLXstbceP7+co3AXrEWtifKF+8NWzhC7B-A8xBd-w@mail.gmail.com> <CA+55aFx6V_TpbghsG7xqoBree8ALAKWMA+qLeGg-8DNAno+peg@mail.gmail.com>
In-Reply-To: <CA+55aFx6V_TpbghsG7xqoBree8ALAKWMA+qLeGg-8DNAno+peg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.4.2012 03:19, Linus Torvalds wrote:
> On Wed, Apr 11, 2012 at 4:58 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I think we can easily drop IS_ENABLED() if it has been causing
>> problems. And it clearly is.

What is really causing problems is that kconfig has no view of the
entire kernel configuration.


>> And I had never even looked at that generated file. It's disgusting.
>> We need to stop doing that. It must be driving compile-times up too -
>> just parsing that monster is RealWork(tm).

You forgot that it also contributes to global warming.


> Oh, but I have a sick and twisted mind. And I'm incredibly smart and
> photogenic too.
> 
> Here's an implementation of IS_ENABLED() that works in C. Well,
> "gcc-C". It depends on the optimizer DTRT, but gcc really does seem to
> do it.
> 
> Ready? You *will* go blind - blinded by the pure beauty and intellect
> in this thing:
> 
>     #define IS_DEFINED(x) (__stringify(CONFIG_##x)[0]=='1')

Nice. Maybe we could make it simply

#define IS_DEFINED(x) (__stringify(x)[0]=='1')

so that the users are easily grepable and it is obvious that a config
option is being tested, like in the current implementation. The only
thing we lose is the check if 'x' is really a boolean or tristate
option. But it turns out that even now this does not work in all cases.

Michal
