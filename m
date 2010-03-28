Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0C1UPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 16:15:19 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:46962 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0C1UPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 16:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T9hEtO5eH3AFYEXM4KhchP+Oh804jBOhEqoAuLKloB/A/uzv2aE9pfQkLq/b+CPkj4
         QaNrUSemcsTsljE1ljEfe00WsBcKiKom0xYYgz7/BSYK6wAMmmD0UMeXpUJ3IlnbdlZP
         QOmFjdGD7HKe/6ZyOR8RWJFVWNHfwmgjedj3I=
Date: Sun, 28 Mar 2010 22:15:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100328201516.GE5116@nowhere>
References: <201003242240.54907.arnd@arndb.de> <201003271537.40488.arnd@arndb.de> <4BAF4B49.9070308@s5r6.in-berlin.de> <201003282205.50886.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003282205.50886.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 09:05:50PM +0100, Arnd Bergmann wrote:
> > General thoughts:
> > 
> > ".llseek = NULL," so far meant "do the Right Thing on lseek() and
> > friends, as far as the fs core can tell".  Shouldn't we keep it that
> > way?  It's as close to other ".method = NULL," as it can get, which
> > either mean "silently skip this method if it doesn't matter" (e.g.
> > .flush) or "fail attempts to use this method with a fitting errno" (e.g.
> > .write).
> 
> My series changes the default from 'default_llseek' to 'generic_file_llseek',
> which is almost identical, except for taking the inode mutex instead of the
> BKL. 


What if another file operation changes the file pointer while holding the bkl?
You're not protected anymore in this case.

