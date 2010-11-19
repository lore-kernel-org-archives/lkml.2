Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0KSPuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:50:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0KSPuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:50:07 -0500
Date: Fri, 19 Nov 2010 10:50:03 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Mark Lord <kernel@teksavvy.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, Josef Bacik <josef@redhat.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Message-ID: <20101119155003.GA7145@infradead.org>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen>
 <4CE68155.50705@teksavvy.com>
 <20101119140203.GC10039@thunk.org>
 <20101119141007.GB25488@infradead.org>
 <20101119153748.GE10039@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119153748.GE10039@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 10:37:48AM -0500, Ted Ts'o wrote:
> I think the author of that slide deck was being a little hysterical.
> In nearly all of these cases, if the file system is comptently
> implemented (i.e., you don't do a trim on anything but a deleted file
> block, and _only_ when you know the deleted is committed, and only the
> filesystem --- not non-privileged users --- are allowed to use the
> TRIM command), there's no issue.

It's a huge issue for virtualization, where naive TRIM implementations
can expose data deleted in one VM to others.  It's also a huge issues
for RAIDs as mentioned by you.

