Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2CSC60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:58:26 -0400
Received: from ozlabs.org ([203.10.76.45]:39830 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab2CSC6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:58:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: jim.cromie@gmail.com, jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [00/11] pr_debug during module initialization
In-Reply-To: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 19 Mar 2012 12:34:01 +1030
Message-ID: <87aa3dxs6m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012 17:01:55 -0600, jim.cromie@gmail.com wrote:
> 
> This is 3rd revision of the dyndbg modinit patches, previously sent
> Dec 11.  Patches 1-17/25 sent then were added to driver-core-next,
> this set reworks the remainder.
> 
> It implements the "fake" module param approach proposed by
> Thomas Renninger, back in https://lkml.org/lkml/2010/9/15/397
> 
> This set is on top of linux-next, since that includes Pawel Moll's
> initcall-level params patch.  Im not using this feature, but I didnt
> know that when I started.
> 
> Rusty Russell did a partial review of 2nd rev (sent off-list), here:
> http://thread.gmane.org/gmane.linux.kernel/1262934
> This revision incorporates my understanding of his feedback.

The module parts seem fine.  The re-parsing of the commandline seems
weird:  I'd really rather see something in unknown_bootoption(), like:

	/* Unused module parameter. */
	if (strchr(param, '.') && (!val || strchr(param, '.') < val)) {
+               /* Check for <module>.dyndebug fake param */
+               dyndebug_parse(param, val);
		return 0;
        }

(Note that param will be the whole line here, eg "foo.dyndebug=+p", with
 val pointing just past the "=" (if any)).

Of course, that means the parsing happens at that "parse_args("Booting
kernel"...)" point in init/main.c, which may not suit.

Otherwise, all looks good!

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
