Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1DVB2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 21:28:44 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:60857 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1DVB2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 21:28:42 -0400
Date: Fri, 22 Apr 2011 03:28:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stratos Psomadakis <psomas@ece.ntua.gr>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH] kbuild: implement several W= levels
Message-ID: <20110422012840.GA10448@merkur.ravnborg.org>
References: <20110421213903.GB9660@merkur.ravnborg.org> <4DB0AA67.6030101@ece.ntua.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DB0AA67.6030101@ece.ntua.gr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just started looking at the patch.
> I tested it and -Wnested-externs is causing a *lot* of noise, because of
> the  nested extern ‘_NSIG_WORDS_is_unsupported_size’ in
> include/linux/signal.h, which gets included a lot.
> So, unless that changes, I think that it shouldn't be enabled for W=1.

It is just the same issue that pops up for each file.
It is easy to fix.

The ones that does not belong in W=1 is those that are triggered
by many different places in the kernel.

If they are triggered in a few .h files they look noisy, but
it is easy to fix.

	Sam
