Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab2FDPhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:37:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:59072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2FDPht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:37:49 -0400
Message-ID: <1338824262.28282.87.camel@twins>
Subject: Re: relax_domain_level boot parameter has no effect
From: Peter Zijlstra <peterz@infradead.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 17:37:42 +0200
In-Reply-To: <20120601210348.GA22471@sgi.com>
References: <20120601210348.GA22471@sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 16:03 -0500, Dimitri Sivanich wrote:
> I noticed (and verified) that the relax_domain_level boot parameter does not
> get processed because sched_domain_level_max is 0 at the time that
> setup_relax_domain_level() is run.
> 
> int sched_domain_level_max;
> 
> static int __init setup_relax_domain_level(char *str)
> {
>         unsigned long val;
> 
>         val = simple_strtoul(str, NULL, 0);
>         if (val < sched_domain_level_max)
>                 default_relax_domain_level = val;
> 
>         return 1;
> }
> __setup("relax_domain_level=", setup_relax_domain_level);

Ah indeed.. this has been so for a while I guess.

What are you using this knob for?
