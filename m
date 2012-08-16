Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2HPRqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:46:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:60109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab2HPRqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:46:49 -0400
Message-ID: <1345139199.29668.46.camel@twins>
Subject: Re: Add rq->nr_uninterruptible count to dest cpu's rq while CPU
 goes down.
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Aug 2012 19:46:39 +0200
In-Reply-To: <CADZ9YHjzNVz6nSqbnTgVYfwi2hz0KYuXC89GHw6UjL2GyGZ64A@mail.gmail.com>
References: <1345124749.31092.2.camel@localhost.localdomain>
	 <1345125384.29668.30.camel@twins>
	 <CADZ9YHjPjExzuJWjziiezBch03Am0imQzDG4EDfG-NTWfz4V8A@mail.gmail.com>
	 <1345128138.29668.42.camel@twins>
	 <CADZ9YHjzNVz6nSqbnTgVYfwi2hz0KYuXC89GHw6UjL2GyGZ64A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 21:32 +0600, Rakib Mullick wrote:
> And also I think migrate_nr_uninterruptible() is meaning less too.

Hmm, I think I see a problem.. we forget to migrate the effective delta
created by rq->calc_load_active.
