Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388Ab1KWBea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:34:30 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54746 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1KWBe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:34:29 -0500
Date: Tue, 22 Nov 2011 17:34:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, DM <dm.n9107@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 1/2] kernel.h: Add BUILD_BUG() macro.
In-Reply-To: <1321985686-798-2-git-send-email-ddaney.cavm@gmail.com>
Message-ID: <alpine.DEB.2.00.1111221734120.18644@chino.kir.corp.google.com>
References: <1321985686-798-1-git-send-email-ddaney.cavm@gmail.com> <1321985686-798-2-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> We can place this in definitions that we expect the compiler to remove
> by dead code elimination.  If this assertion fails, we get a nice
> error message at build time.
> 
> The GCC function attribute error("message") was added in version 4.3,
> so we define a new macro __linktime_error(message) to expand to this
> for GCC-4.3 and later.  This will give us an error diagnostic from the
> compiler on the line that fails.  For other compilers
> __linktime_error(message) expands to nothing, and we have to be
> content with a link time error, but at least we will still get a build
> error.
> 
> BUILD_BUG() expands to the undefined function __build_bug_failed() and
> will fail at link time if the compiler ever emits code for it.  On
> GCC-4.3 and later, attribute((error())) is used so that the failure
> will be noted at compile time instead.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: David Rientjes <rientjes@google.com>
