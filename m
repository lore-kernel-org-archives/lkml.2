Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1GFLYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab1GFLYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:24:13 -0400
Date: Wed, 6 Jul 2011 12:23:59 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvm-devel@redhat.com
Subject: Re: `pvmove stuck' in RH bugzilla
Message-ID: <20110706112359.GF5448@agk-dp.fab.redhat.com>
Mail-Followup-To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	lvm-devel@redhat.com
References: <20110706095310.GA3225@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706095310.GA3225@swordfish>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 12:53:10PM +0300, Sergey Senozhatsky wrote:
> I think we just trapped into the same trouble with pvmove as described in 
> https://bugzilla.redhat.com/show_bug.cgi?id=602516
> https://bugzilla.redhat.com/show_bug.cgi?id=706036
> 
> Alasdair, could you please point are those patches in vanilla kernel 
> (3.0-rc*) or linux-next, or some RH internal tree? 
> This is not critical, though I'd like to try out patches.
 
This is a userspace bug not a kernel one.
There is a workaround, which is to perform the pvmove one LV at a time
using the --name option.  (For each LV, run pvmove -n <lvname>.)

The patched code is in the upstream lvm2 repository:
  git://sources.redhat.com/git/lvm2
  http://sourceware.org/cgi-bin/cvsweb.cgi/LVM2/doc/?cvsroot=lvm2
  http://sourceware.org/lvm2/

It was only last night that the code incorporating these changes passed
our public testsuite for the first time, so I think it is still
premature to be using this on production systems.  But this means I hope
to be in a position to make the first development release containing a
fix for the problems quite soon.  (I added assertions to catch other
instances of the related problems - it was more than just pvmove
affected.)

Alasdair

