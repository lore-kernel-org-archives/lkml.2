Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab0HUJcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:32:36 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37937 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0HUJce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:32:34 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <andreas.dilger@oracle.com>, Neil Brown <neilb@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        "adilger\@sun.com" <adilger@sun.com>,
        "corbet\@lwn.net" <corbet@lwn.net>,
        "npiggin\@kernel.dk" <npiggin@kernel.dk>,
        "hooanon05\@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
        "bfields\@fieldses.org" <bfields@fieldses.org>,
        "miklos\@szeredi.hu" <miklos@szeredi.hu>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "sfrench\@us.ibm.com" <sfrench@us.ibm.com>,
        "philippe.deniel\@CEA.FR" <philippe.deniel@CEA.FR>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
In-Reply-To: <17761610-AFA9-4BB5-AF62-CD54D67F5C79@oracle.com>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100820083057.GA10039@infradead.org> <20100820195303.20b17210@notabene> <20100820115135.GQ31363@ZenIV.linux.org.uk> <20100821100900.4b15fe08@notabene> <17761610-AFA9-4BB5-AF62-CD54D67F5C79@oracle.com>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sat, 21 Aug 2010 15:02:14 +0530
Message-ID: <m339u8s44h.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Aug 2010 01:13:52 -0600, Andreas Dilger <andreas.dilger@oracle.com> wrote:
> On 2010-08-20, at 18:09, Neil Brown <neilb@suse.de> wrote:
> > How about a new AT flag:  AT_FILE_HANDLE
> > 
> > Meaning is that the 'dirfd' is used only to identify a filesystem (vfsmnt) and
> > the 'name' pointer actually points to a filehandle fragment interpreted in
> > that filesystem.
> > 
> > One problem is that there is no way to pass the length...
> > Options:
> >   fragment is at most 64 bytes nul padded at the end
> >   fragment is hex encoded and nul terminated
> >   ??
> > 
> > I think I prefer the hex encoding, but I'm hoping someone else has a better
> > idea.
> 
> That makes it ugly for the kernel to stringify and parse the file handles. 
> 
> How about for AT_FILE_HANDLE THE FIRST __u32 (maybe with an extra
> __u32 for alignment) is the length and the rest of the binary file
> handle follows this?  In fact, doesn't the handle itself already
> encode the length in the header?


struct file_handle already include length

-aneesh

