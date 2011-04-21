Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1DUV6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:58:32 -0400
Received: from mail.perches.com ([173.55.12.10]:4896 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab1DUV6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:58:31 -0400
Subject: Re: [RFC PATCH] kbuild: implement several W= levels
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <20110421213903.GB9660@merkur.ravnborg.org>
References: <20110421213903.GB9660@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 14:58:29 -0700
Message-ID: <1303423109.24766.97.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 23:39 +0200, Sam Ravnborg wrote:
> Building a kernel with "make W=1" produce far too much noise
> to be usefull.
> Divide the warning options in three groups:
> W=1 - usefull warning options
> W=2 - noisy but semi usefull warnign options
> W=3 - almost pure noise options
> +warning-1 := -Wextra
[]
> +warning-2 += -Waggregate-return

This is a different form for this first warning-2 declaration
than the first warning-1 declaration.

Maybe this should be := instead?

Maybe there's a way to do something akin to

warning_type(level, option)

So these become

warning_type(1, extra)
warning_type(2, aggregate-return)

etc.


