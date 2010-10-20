Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0JTSdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:33:38 -0400
Received: from c-67-162-90-113.hsd1.in.comcast.net ([67.162.90.113]:34008 "HELO
	kosh.dhis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753249Ab0JTSdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:33:37 -0400
Message-ID: <20101020183336.1714.qmail@kosh.dhis.org>
From: pacman@kosh.dhis.org
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
To: benh@kernel.crashing.org (Benjamin Herrenschmidt)
Date: Wed, 20 Oct 2010 13:33:36 -0500 (GMT+5)
Cc: segher@kernel.crashing.org (Segher Boessenkool),
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1287570736.2198.19.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:
> 
> On Tue, 2010-10-19 at 22:23 -0500, pacman@kosh.dhis.org wrote:
> > The diff fragment above applied inside prom_close_stdin, but there are
> > some
> > prom_printf calls after prom_close_stdin. Calling prom_printf after
> > closing
> > stdout sounds like it could be bad. If I moved it down below all the
> > prom_printf's, it would be after the "quiesce" call. Would that be
> > acceptable
> > (or even interesting as an experiment)? Does a close need a quiesce
> > after it?
> 
> Just try :-) "quiesce" is something that afaik only apple ever
> implemented anyways. It uses hooks inside their OF to shut down all
> drivers that do bus master (among other HW sanitization tasks).

I booted a version with a prom_close_stdout after the last prom_debug. It
didn't have any effect. That 1000Hz clock was still ticking.

-- 
Alan Curry
