Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab2DSWRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:17:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2DSWRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:17:53 -0400
Date: Thu, 19 Apr 2012 15:17:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: fix bug where environment vars can't be passed
 via boot args
Message-Id: <20120419151746.8c765ea7.akpm@linux-foundation.org>
In-Reply-To: <201204061711.q36HBpAh015060@lab-41.internal.tilera.com>
References: <201204061711.q36HBpAh015060@lab-41.internal.tilera.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012 12:53:50 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> Commit 026cee0086f had the side-effect of dropping the '=' from
> the unknown boot arguments that are passed to init as environment
> variables.  This is because parse_args() puts a NUL in the string
> where the '=' was when it passes the "param" and "val" pointers
> to the parsing subfunctions.  Previously, unknown_bootoption() was
> the last parse_args() subfunction to run, and it carefully put back
> the '=' character.  Now ignore_unknown_bootoption() is the last
> one to run, and it wasn't doing the necessary repair, so the
> envp params ended up with the embedded NUL and were no longer
> seen as valid environment variables by init.

This patch has been stuck in your tree for a week or two.  The copy
there is missing Woody's Tested-by and (I suspect) his Reported-by and
Pawel's Acked-by.

And because that patch is already in linux-next, I can't (or rather
don't want to) merge it myself.

It needs to be merged into 3.4.  Please fix up the changelog data and
send it in?

