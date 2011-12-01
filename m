Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1LAIPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:15:55 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33488 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1LAIPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:15:54 -0500
MIME-Version: 1.0
In-Reply-To: <8739d5t4ne.fsf@rustcorp.com.au>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
 <1322683014-13285-19-git-send-email-jim.cromie@gmail.com> <8739d5t4ne.fsf@rustcorp.com.au>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Thu, 1 Dec 2011 01:15:22 -0700
Message-ID: <CAJfuBxzg-Bn8TD-h_kjo=hu4oCpkOLWvuC2NybpqQH5msokk4A@mail.gmail.com>
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param module.ddebug
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jbaron@redhat.com, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I think you're missing a neat trick here: we should be able to handle
> ddebug in the handle_unknown parameter to parse_args().
>
> Or am I missing something?
>

Jason suggested that too, offlist.
I pretty much agreed, but wanted to get the 1st 17 sent.

What gave me pause was this:
		pr_debug("Unknown argument: calling %p\n", handle_unknown);

it made me think about a common handler to deal with it 1st,
before the /* Find parameter */ loop, so that modules couldnt hijack
the dyndbg param, defeating the common handler.
OTOH, the BUILD_BUG_DECL prevents that hijack.

Maybe the best answer is silence the print when param is properly handled.

	if (handle_unknown) {
                int rc = handle_unknown(param, val);
		if (rc)
                      pr_debug("Unknown argument: calling %p\n",
handle_unknown);
		return rc;
       }

I'll do this shortly, see how it works out..
thanks

> Thanks,
> Rusty.
