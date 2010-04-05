Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab0DEXfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:35:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756845Ab0DEXfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:35:45 -0400
Date: Mon, 5 Apr 2010 16:34:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org,
       pv-drivers@vmware.com, Avi Kivity <avi@redhat.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] VMware Balloon driver
Message-Id: <20100405163458.135fa319.akpm@linux-foundation.org>
In-Reply-To: <4BBA7226.9080508@goop.org>
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
	<20100405142419.2c9bea3d.akpm@linux-foundation.org>
	<4BBA5E1C.10706@goop.org>
	<20100405151720.8a6ac5e3.akpm@linux-foundation.org>
	<4BBA7226.9080508@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Apr 2010 16:28:38 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> And is there some way to get the vm subsystem to provide backpressure: 
> "I'm getting desperately short of memory!"?

Not really.  One could presumably pull dopey tricks by hooking into
slab shrinker registration or even ->writepage().  But cooking up
something explicit doesn't sound too hard - the trickiest bit would be
actually defining what it should do.

