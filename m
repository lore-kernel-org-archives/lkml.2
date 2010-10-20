Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0JTKgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:36:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:41814 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0JTKgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:36:35 -0400
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: pacman@kosh.dhis.org
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101020032345.5240.qmail@kosh.dhis.org>
References: <20101020032345.5240.qmail@kosh.dhis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 21:32:16 +1100
Message-ID: <1287570736.2198.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 22:23 -0500, pacman@kosh.dhis.org wrote:
> The diff fragment above applied inside prom_close_stdin, but there are
> some
> prom_printf calls after prom_close_stdin. Calling prom_printf after
> closing
> stdout sounds like it could be bad. If I moved it down below all the
> prom_printf's, it would be after the "quiesce" call. Would that be
> acceptable
> (or even interesting as an experiment)? Does a close need a quiesce
> after it?

Just try :-) "quiesce" is something that afaik only apple ever
implemented anyways. It uses hooks inside their OF to shut down all
drivers that do bus master (among other HW sanitization tasks).

Cheers,
Ben.


