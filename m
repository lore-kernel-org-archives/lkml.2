Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1DOOvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:51:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab1DOOvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:51:40 -0400
Date: Fri, 15 Apr 2011 16:51:33 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: akpm@linux-foundation.org, cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] mm: make read-only accessors take const pointer
 parameters
Message-ID: <20110415145133.GO15707@random.random>
References: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Phil,

On Fri, Apr 15, 2011 at 12:56:16PM +0300, Phil Carmody wrote:
> 
> Sending this one its own as it either becomes an enabler for further
> related patches, or if nacked, shuts the door on them. Better to test
> the water before investing too much time on such things.
> 
> Whilst following a few static code analysis warnings, it became clear
> that either the tool (which I believe is considered practically state of
> the art) was very dumb when sniffing into called functions, or that a
> simple const flag would either help it not make the incorrect paranoid
> assumptions that it did, or help me dismiss the report as a false
> positive more quickly.
> 
> Of course, this is core core code, and shouldn't be diddled with lightly,
> but it's because it's core code that it's an enabler.
> 
> Awaiting the judgement of the Solomons,

What's the benefit of having it const other than shutdown the warnings
from the static code analysis? I doubt gcc can generate any better
output from this change because it's all inline anyway.

I guess the only chance this could help is if we call an extern
function and we read the pointer before and after the external call,
in that case gcc could assume the memory didn't change across the
extern function and just cache the value in callee-saved register
without having to re-read memory after the extern function
returns. But there isn't any extern function there...

I guess the static code analysis shouldn't suggest a const if it's all
inline and gcc has full visibility on everything that is done inside
those functions at build time.

But maybe I'm missing something gcc could do better with const that it
can't now.
