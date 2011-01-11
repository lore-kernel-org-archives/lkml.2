Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1AKDTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:19:07 -0500
Received: from relais.videotron.ca ([24.201.245.36]:10766 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1AKDTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:19:04 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 10 Jan 2011 22:19:02 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to setup.c
In-reply-to: <20110111015409.18291.87166.stgit@localhost6.localdomain6>
Message-id: <alpine.LFD.2.00.1101102211370.12076@xanadu.home>
References: <20110111015409.18291.87166.stgit@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Grant Likely wrote:

> Since the debug macros no longer depend on the machine type
> information, both the machine type lookup and the atags vetting can be
> deferred to setup_arch() in setup.c which simplifies the code
> somewhat.
> 
> This patch removes both __machine_type_lookup and __vet_atags() from
> head.S.  The atags vetting is moved to setup_arch().  machine_type
> lookup is already called from setup_machine() in addition to where it
> was called from head.S.

While at it, you could also remove the code for __lookup_machine_type, 
lookup_machine_type and __error_a, replacing that with a C 
implementation living in setup.c instead.  If this code is not called 
from head.S anymore, there is no reason to keep it there any longer.


Nicolas
