Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0F3PpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:45:13 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60849 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab0F3PpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:45:11 -0400
Date: Wed, 30 Jun 2010 08:45:01 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Yama: add PTRACE exception tracking
Message-ID: <20100630154501.GM4837@outflux.net>
References: <20100630003844.GE4837@outflux.net>
 <20100630073158.GA4453@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630073158.GA4453@infradead.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Wed, Jun 30, 2010 at 03:31:58AM -0400, Christoph Hellwig wrote:
> Err, no.  This is just a very clear sign that your ptrace restrictions
> were completely wrong to start with and break applications left, right
> and center.  Just get rid of it instead of letting workarounds for your
> bad design creep into the core kernel and applications.

It's not my bad design; PTRACE is a terrible interface.  In an effort
to eliminate PTRACE, there are a few legitimate uses: direct debugging,
and crash handlers.  The crash handlers are an odd case because all
they want is a backtrace and register details, but there's no way to do
that on the fly without PTRACE, so that's how they've implemented it.
In those cases, the crashing program knows who will attach to it, so
there needs to be a safe way to declare that relationship instead of just
giving up and saying "oh well, everything can PTRACE everything else".

What is so objectionable about using a single PR_* value out of the
2147483614 available?

-Kees

-- 
Kees Cook
Ubuntu Security Team
