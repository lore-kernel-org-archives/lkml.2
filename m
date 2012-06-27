Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2F0LGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:06:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46412 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2F0LGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:06:15 -0400
Message-ID: <1340795162.10063.28.camel@twins>
Subject: Re: cosmetic printk() issue with lockdep warning in
 arch/x86/kernel/alternative.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kay Sievers <kay@vrfy.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>
Date: Wed, 27 Jun 2012 13:06:02 +0200
In-Reply-To: <CAPXgP10OLwd2v57qJqoJMTkXrM+7C8uhFoydy6HUEbfPfFVN8Q@mail.gmail.com>
References: <CAPXgP124qFG=QdO4H7qsp1bhY4BOp-PJEz7-4v-Dhi13LW+GDQ@mail.gmail.com>
	 <20120627060939.GD14913@gmail.com>
	 <CAPXgP10OLwd2v57qJqoJMTkXrM+7C8uhFoydy6HUEbfPfFVN8Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 12:49 +0200, Kay Sievers wrote:
> All we want is a reliable printk

We too, but we define reliable differently. I want printk() to dump data
ASAP so that it has better chance to get out of the system and onto my
console in case of a crash. I don't give a rats arse about interleaved
text, any text is better than no text.

So if you go add separate buffers in there that will delay writing text,
you're actively destroying printk().

Any change that makes it harder to get text out is bad. 
