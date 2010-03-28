Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0C1UdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 16:33:24 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63027 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab0C1UdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 16:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qzX2FOHlu0Oyk2Ekx7p1ApsVnzPQIPoD5E4tOqb5MWYd6pPWtgHkpiyVNdyhC0vaSD
         RYPyHYKFcWvemcubEcsIgsGN5Q29TDUGiACs2+7lXA4b6l3aHO1iHWAtzzUFBQczzE58
         5171VZZskRULZL0OS+0h6nCTEjJ7uB4JNckjU=
Date: Sun, 28 Mar 2010 22:33:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100328203322.GF5116@nowhere>
References: <201003242240.54907.arnd@arndb.de> <20100324170704.7ef8b9c1.akpm@linux-foundation.org> <201003251126.56640.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003251126.56640.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 11:26:56AM +0100, Arnd Bergmann wrote:
> On Wednesday 24 March 2010, Andrew Morton wrote:
> > On Wed, 24 Mar 2010 22:40:54 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > > I've spent some time continuing the work of the people on Cc and many others
> > > to remove the big kernel lock from Linux
> > 
> > <looks inside ptrace.c>
> > 
> > Seems that there might be a few tricksy bits in here.  Please do push
> > at least the non-obvious parts out to the relevant people.
> 
> Sure, that is certainly the plan.
> 
> Regarding the ptrace bits, this is one of a handful of places where the BKL
> was put in by someone a really long time ago but with the rest of the
> series applied, it becomes evident that there is nothing whatsoever that
> it serializes with, so removing the BKL here does not make the situation
> worse. It could still be a bug that needs to be fixed by adding a new
> serialization method no matter if the BKL is there or not.


Yeah, the comment gives this:

	/*
	 * This lock_kernel fixes a subtle race with suid exec
	 */

But there is no lock_kernel() in the exec path, may be I missed it...
so this may be an old lock_kernel() that doesn't exist anymore, and
the bkl in the ptrace path is not going to help in any way.

What remain to check are the possible unintended racy places that
this bkl might protect.

I'm going to check a first pass and if it looks fine, I'll just submit
to Oleg and Roland.

