Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2CERCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:02:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53464 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963Ab2CERCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:02:22 -0500
Message-ID: <1330966942.3140.8.camel@joe2Laptop>
Subject: Re: [PATCH] vsprintf: make %pV handling compatible with kasprintf()
From: Joe Perches <joe@perches.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Mar 2012 09:02:22 -0800
In-Reply-To: <4F54FCA402000078000766F1@nat28.tlf.novell.com>
References: <4F54FCA402000078000766F1@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 16:49 +0000, Jan Beulich wrote:
> kasprintf() (and potentially other functions that I didn't run across
> so far) want to evaluate argument lists twice. Caring to do so for the
> primary list is obviously their job, but they can't reasonably be
> expected to check the format string for instances of %pV, which however
> need special handling too: On architectures like x86-64 (as opposed to
> e.g. ix86), using the same argument list twice doesn't produce the
> expected results, as an internally managed cursor gets updated during
> the first run.
> 
> Fix the problem by always acting on a copy of the original list when
> handling %pV.

Wouldn't stable need this too?


