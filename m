Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab2CUVV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:21:59 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:51064 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab2CUVV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:21:58 -0400
Date: Wed, 21 Mar 2012 17:21:52 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Risanecek <risanecek@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext2 large block size support - the shocking truth...
Message-ID: <20120321212152.GA32041@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Risanecek <risanecek@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAE7SGk7rJXwjs4pD01e_ZgkoH4UNLAh8JLfX1_gv=q7RXtY5Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE7SGk7rJXwjs4pD01e_ZgkoH4UNLAh8JLfX1_gv=q7RXtY5Gw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 09:38:33PM +0100, Risanecek wrote:
> 
> EXT2-fs (sdd2): error: bad blocksize 32768
> 
> Seems many DVRs use that kind of "enhanced ext2"...

It's not an enhanced ext2 as much as it is enhancements primarily in
the mm layer to allow file systems to use a "larger page" which is
larger than the native page size of the CPU's MMU.  This is the first
that I've heard of a DVR, or any product in general, actually trying
to use Christoph Lameter's patches in a shipping Linux system.

If you just need to read and write files from this file system from a
userspace CLI shell utility, you could just use the programs from the
e2tools package; they should work just fine.  It works much like the
mtools package do to be able to copy, rename, list directories, of an
MSDOS file system, but for ext2/3/4 file systems.

Alternatively, you could try to forward port Christoph's patches to a
modern kernel, or commission someone to port it to a modern for you...

Hope this helps,

						- Ted
