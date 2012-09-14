Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2INSA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:00:27 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61462 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2INSAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:00:23 -0400
Date: Fri, 14 Sep 2012 11:00:13 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 3/3 v2] perf tool: give user better message if precise is
 not supported
Message-ID: <20120914180013.GA27766@ghostprotocols.net>
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
 <1347569955-54626-4-git-send-email-dsahern@gmail.com>
 <20120914054344.GB9043@gmail.com>
 <50531151.9020202@gmail.com>
 <20120914113617.GA13299@gmail.com>
 <5053186E.6000302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5053186E.6000302@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 14, 2012 at 05:43:42AM -0600, David Ahern escreveu:
> On 9/14/12 5:36 AM, Ingo Molnar wrote:

> >Well, then that is useful information we *lost*, and that situation
> >needs to be improved on the ABI side: an expanded error code present
> >in the event structure, copied back to user-space on errors, or so.

> Understood and there have been suggestions on how to definitely state
> what the kernel side did not like. I like Peter's last suggestion --
> something along the lines of clearing attr on a failure except the
> offending setting.

I think ws need to use a new bit, attr.clear_opsup_on_error,
that we would set, older kernels would return an error cause they don't
support this new feature, the tool would then clear it and work as
today, giving a vague message, cause that is all it can do.

We can't just clean the unsupported bits because then older tools would
get completely confused when trying to use the current fallback
mechanism, where, for instance, for sample_id_all, we just reset it in
the tooling side, ask again the kernel and it works.

Older tools not setting the clear_supported_bits_on_error would get the
current behaviour.

- Arnaldo
