Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1G0Ab1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:31:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55184 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab1G0AbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:31:23 -0400
Date: Tue, 26 Jul 2011 20:31:08 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Josef Bacik <josef@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PULL REQUEST] ext3, jbd, ext2, and quota fixes for 3.1-rc1
Message-ID: <20110727003108.GA19851@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Josef Bacik <josef@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
References: <20110726181418.GA27993@quack.suse.cz>
 <CA+55aFwYsdyE4KxFW70c_FfTb41m+EwchYvNJU-eUEw4usRkUw@mail.gmail.com>
 <20110726185220.GJ22133@ZenIV.linux.org.uk>
 <20110726185920.GA2970@infradead.org>
 <CA+55aFyCs3T_BhwjhW=zC9+5G7tnUNmQAa+77YndJ9BuV4Kbig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyCs3T_BhwjhW=zC9+5G7tnUNmQAa+77YndJ9BuV4Kbig@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 12:14:28PM -0700, Linus Torvalds wrote:
> On Tue, Jul 26, 2011 at 11:59 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >
> > In addition to beeing bogus the code also is useless.  fsync on a file
> > explicitly does not guarantee anything at all about the parent, and
> > never really has on Linux either.
> 
> Well, it may never have done that, but it might still be a case of
> quality-of-implementation.
> 
> The data blocks and inode indirect blocks being stable on disk doesn't
> help hugely if you cannnot actually reach the inode itself.

Yeah, that's why it was done.  Frank found that with power-fail
testing, a large number of files that were freshly created and then
fsync()'ed would disappear.  If the data is supposed to be available
after a power failure, then you have to be able to get to it somehow.

I agree what's there isn't safe, and needs to be fixed.  I'll deal
with it.

						- Ted
