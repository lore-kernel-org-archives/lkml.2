Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0JTU5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:57:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:50590 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab0JTU5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:57:09 -0400
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: pacman@kosh.dhis.org
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101020183336.1714.qmail@kosh.dhis.org>
References: <20101020183336.1714.qmail@kosh.dhis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 07:56:55 +1100
Message-ID: <1287608215.2198.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 13:33 -0500, pacman@kosh.dhis.org wrote:
> > Just try :-) "quiesce" is something that afaik only apple ever
> > implemented anyways. It uses hooks inside their OF to shut down all
> > drivers that do bus master (among other HW sanitization tasks).
> 
> I booted a version with a prom_close_stdout after the last prom_debug. It
> didn't have any effect. That 1000Hz clock was still ticking. 

Ok so you'll have to make up a "workaround" in prom_init that looks for
OHCI's in the device-tree and disable them.

Check if the OHCI node has some existing f-code words you can use for
that with "dev /path-to-ohci words" in OF for example. If not, you may
need to use the low level register accessors. Use OF client interface
"interpret" to run forth code from C.

Cheers,
Ben.


