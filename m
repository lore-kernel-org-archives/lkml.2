Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab2F0SNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:13:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57631 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2F0SNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:13:35 -0400
Date: Wed, 27 Jun 2012 11:13:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early boot panic on machine with lots of memory
Message-ID: <20120627181330.GN15811@google.com>
References: <20120619041154.GA28651@shangw>
 <20120619212059.GJ32733@google.com>
 <20120619212618.GK32733@google.com>
 <CAE9FiQVECyRBie-kgBETmqxPaMx24kUt1W07qAqoGD4vNus5xQ@mail.gmail.com>
 <20120621201728.GB4642@google.com>
 <CAE9FiQXubmnKHjnqOxVeoJknJZFNuStCcW=1XC6jLE7eznkTmg@mail.gmail.com>
 <20120622185113.GK4642@google.com>
 <CAE9FiQVV+WOWywnanrP7nX-wai=aXmQS1Dcvt4PxJg5XWynC+Q@mail.gmail.com>
 <20120622192919.GL4642@google.com>
 <CAE9FiQVeJYwpgHjAFp5Q7PazOjeDvN_etrnej987Rc94TjXfAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQVeJYwpgHjAFp5Q7PazOjeDvN_etrnej987Rc94TjXfAg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

Sorry about the delay.  I'm in bug storm somehow. :(

On Fri, Jun 22, 2012 at 07:14:43PM -0700, Yinghai Lu wrote:
> On Fri, Jun 22, 2012 at 12:29 PM, Tejun Heo <tj@kernel.org> wrote:
> > I wish we had a single call - say, memblock_die(), or whatever - so
> > that there's a clear indication that memblock usage is done, but yeah
> > maybe another day.  Will review the patch itself.  BTW, can't you post
> > patches inline anymore?  Attaching is better than corrupt but is still
> > a bit annoying for review.
> 
> please check the three patches:

Heh, reviewing is cumbersome this way but here are my comments.

* "[PATCH] memblock: free allocated memblock_reserved_regions later"
  looks okay to me.

* "[PATCH] memblock: Free allocated memblock.memory.regions" makes me
  wonder whether it would be better to have something like the
  following instead.

  typedef void memblock_free_region_fn_t(unsigned long start, unsigned size);

  void memblock_free_regions(memblock_free_region_fn_t free_fn)
  {
	/* call free_fn() on reserved and memory regions arrays */
	/* clear both structures so that any further usage triggers warning */
  }

* "memblock: Add checking about illegal using memblock".
  Hmm... wouldn't it be better to be less explicit?  I think it's
  adding too much opencoded identical checks.  Maybe implement a
  common check & warning function?

Thanks.

-- 
tejun
