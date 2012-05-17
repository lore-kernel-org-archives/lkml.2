Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620Ab2EQVfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:35:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:45873 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2EQVfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:35:18 -0400
Message-ID: <1337290512.4281.91.camel@twins>
Subject: Re: [PATCH 1/2] lib: Proportions with flexible period
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Date: Thu, 17 May 2012 23:35:12 +0200
In-Reply-To: <1337096583-6049-2-git-send-email-jack@suse.cz>
References: <1337096583-6049-1-git-send-email-jack@suse.cz>
	 <1337096583-6049-2-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 17:43 +0200, Jan Kara wrote:
> +               if (numerator > ((long long)denominator) * max_frac / 100)

Does that even compile on 32bit archs?

Operator precedence is *,/ left-to-right, so that's:

  long long t1 = (long long)denom * max_frac
  long long t2 = t1 / 100;

Which is a 64bit signed division.

There's a reason I used that max_prop_frac thing you removed, it avoids
having to do the division at all and allows a mult and shift instead.


