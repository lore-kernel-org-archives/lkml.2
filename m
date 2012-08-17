Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2HQNj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:39:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57438 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2HQNjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <1345139199.29668.46.camel@twins>
References: <1345124749.31092.2.camel@localhost.localdomain>
	<1345125384.29668.30.camel@twins>
	<CADZ9YHjPjExzuJWjziiezBch03Am0imQzDG4EDfG-NTWfz4V8A@mail.gmail.com>
	<1345128138.29668.42.camel@twins>
	<CADZ9YHjzNVz6nSqbnTgVYfwi2hz0KYuXC89GHw6UjL2GyGZ64A@mail.gmail.com>
	<1345139199.29668.46.camel@twins>
Date: Fri, 17 Aug 2012 19:39:16 +0600
Message-ID: <CADZ9YHgNhTGWicX0kFfrNoL17JkxfZcXryqqa-wHLVLh05SvAg@mail.gmail.com>
Subject: Re: Add rq->nr_uninterruptible count to dest cpu's rq while CPU goes down.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/12, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-08-16 at 21:32 +0600, Rakib Mullick wrote:
>> And also I think migrate_nr_uninterruptible() is meaning less too.
>
> Hmm, I think I see a problem.. we forget to migrate the effective delta
> created by rq->calc_load_active.
>
And rq->calc_load_active needs to be migrated to the proper dest_rq
not like currently picking any random rq.
