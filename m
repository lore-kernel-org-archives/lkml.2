Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946041Ab2LFQul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:50:41 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:37146 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424218Ab2LFQuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:50:39 -0500
Date: Thu, 6 Dec 2012 11:50:24 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121206165024.GA30273@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <201212051718.44017.Martin@lichtvoll.de>
 <CA+55aFxsPBo4TZEPq+14NBE8Snmd9qiTjAiEP0fFXBzaJ9y+gw@mail.gmail.com>
 <20121206011402.GB27172@dastard>
 <20121206120645.GB14100@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206120645.GB14100@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 07:06:45AM -0500, Christoph Hellwig wrote:
> 
> Also the only conference outcome I remember is that everyone at LSF
> except for Ted basically said "no fucking way".
> 

At LSF, that's correct.  And as a result, the people who need this --
Google and Tao Bao -- have decided to keep the patch as an out-of-tree
patch, much like the Android wakelock patch was out of tree, and for
similar reasons --- because the community has rejected the
functionality.

At this point, I've only asked that the bit be reserved, so we don't
have to worry about codepoint collisions.  (We'd have the same issue
with an ioctl, BTW --- we would need to reserve an ioctl number to
avoid collisions, although granted there are ways to cleverly choose
an ioctl number that would reduce the chance of collisions even if it
isn't formally reserved.)

Note that this is not a kernel fork the same way the android wakelock
is not a kernel fork.  It's an out of tree patch which has been
rejected by upstream.

						- Ted
