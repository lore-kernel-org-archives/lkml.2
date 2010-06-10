Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0FJUiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:38:23 -0400
Received: from thunk.org ([69.25.196.29]:45318 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0FJUiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:38:21 -0400
Date: Thu, 10 Jun 2010 16:38:15 -0400
From: tytso@mit.edu
To: Salman <sqazi@google.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, tytso@google.com,
       akpm@linux-foundation.org, walken@google.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100610203815.GA15868@thunk.org>
Mail-Followup-To: tytso@mit.edu, Salman <sqazi@google.com>,
	peterz@infradead.org, linux-kernel@vger.kernel.org,
	tytso@google.com, akpm@linux-foundation.org, walken@google.com,
	torvalds@linux-foundation.org, mingo@elte.hu
References: <20100610200911.18287.29658.stgit@bumblebee1.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610200911.18287.29658.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 01:09:11PM -0700, Salman wrote:
> A program that repeatedly forks and waits is susceptible to having the
> same pid repeated, especially when it competes with another instance of the
> same program.  This is really bad for bash implementation.  Furthermore, many shell
> scripts assume that pid numbers will not be used for some length of time.

This should probably get wrapped at column 74 or so....

> +static int pid_before(int base, int a, int b)
> +{
> +	/*
> +	 * This is the same as saying
> +	 *
> +	 * (a - base + MAXUINT) % MAXUINT < (b - base + MAXUINT) % MAXUINT
> +	 * and that mapping orders 'a' and 'b' with respect to 'base'.
> +	 *
> +	 */
> +	return (unsigned)(a - base) < (unsigned)(b - base);
> +}

Does this work though if /proc/sys/kernel/pid_max is not set to
MAXUINT?

I like the optimization, but it looks like pid_max defaults to 4096 if
CONFIG_BASE_SMALL is set, and 32768 otherwise.

Am I missing something?

					- Ted
