Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0LLCef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 21:34:35 -0500
Received: from thunk.org ([69.25.196.29]:56796 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab0LLCeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 21:34:31 -0500
Date: Sat, 11 Dec 2010 21:34:15 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Jon Nelson <jnelson@jamponi.net>
Cc: Matt <jackdachef@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Message-ID: <20101212023415.GG3059@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Jon Nelson <jnelson@jamponi.net>, Matt <jackdachef@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
References: <20101209201359.GG2921@thunk.org>
 <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
 <20101209231616.GA12515@basil.fritz.box>
 <1291945065-sup-1838@think>
 <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
 <20101210023852.GB3059@thunk.org>
 <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One experiment --- can you try this with the file system mounted with
data=writeback, and see if the problem reproduces in that journalling
mode?

I want to rule out (if possible) journal_submit_inode_data_buffers()
racing with mpage_da_submit_io().  I don't think that's the issue, but
I'd prefer to do the experiment to make sure.  So if you can use a
kernel and system configuration which triggers the problem, and then
try changing the mount options to include data=writeback, and then
rerun the test, and let me know if the problem still reproduces, I'd
be really grateful.

Thanks,

					- Ted
