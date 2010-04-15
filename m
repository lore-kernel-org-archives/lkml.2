Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab0DOVtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:49:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55069 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab0DOVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:49:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SKW9TIYZu0PfAQk9Tw9vgUXjHcQJXZAmD8bwsYZbo+uKyig4HyCtrY43HYHHl2efEq
         RoWuPlaFEAd6DSAZvi8RdyuMfQcvM7ZgiNF9G2uGETNIiCrN6xo3OFOr/9zX/GGM6SUk
         N4j8ngem1RgQ0z0zTm2vvShB6bcQwIKCZi9lU=
MIME-Version: 1.0
In-Reply-To: <20100415205739.GF5069@nowhere>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
	 <1271262016-18650-2-git-send-email-chase.douglas@canonical.com>
	 <20100415205739.GF5069@nowhere>
Date: Thu, 15 Apr 2010 14:49:05 -0700
X-Google-Sender-Auth: 2d0dad9dc5ae102f
Message-ID: <v2t40ec3ea41004151449x70e7077flb8d1fea5e8d46167@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add tracing_off_event() calls to BUG() and WARN() 
	paths
From: Chase Douglas <chase.douglas@canonical.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 1:57 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Apr 14, 2010 at 12:20:15PM -0400, Chase Douglas wrote:
>> This change adds tracing_off_event() calls, which stop debug tracing,
>> when a BUG() or WARN() function is called. The stoppage depends on
>> commandline paramenter tracing_off={bug,warn,none}. The default is
>> "bug", so only the BUG() paths will stop tracing.
>>
>> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>
>
> ACK
>
> But I can't find where we call oops_enter() from panic()
> I see it called in x86 from oops_begin() that is called
> in various places like die(), but couldn't find how it
> ends up beeing called from panic().

I did not test the panic() path, but when that happens the system goes
down anyways. You won't be able to get the ftrace unless you enable
the ftrace on oops option, in which case the end of the trace will
likely be close enough to what you are looking for anyways.

-- Chase
