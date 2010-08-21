Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab0HUHPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 03:15:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33881 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0HUHP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 03:15:26 -0400
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100820083057.GA10039@infradead.org> <20100820195303.20b17210@notabene> <20100820115135.GQ31363@ZenIV.linux.org.uk> <20100821100900.4b15fe08@notabene>
In-Reply-To: <20100821100900.4b15fe08@notabene>
Mime-Version: 1.0 (iPhone Mail 8A400)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <17761610-AFA9-4BB5-AF62-CD54D67F5C79@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "adilger@sun.com" <adilger@sun.com>, "corbet@lwn.net" <corbet@lwn.net>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>,
        "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
        "philippe.deniel@CEA.FR" <philippe.deniel@CEA.FR>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8A400)
From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Date: Sat, 21 Aug 2010 01:13:52 -0600
To: Neil Brown <neilb@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-20, at 18:09, Neil Brown <neilb@suse.de> wrote:
> How about a new AT flag:  AT_FILE_HANDLE
> 
> Meaning is that the 'dirfd' is used only to identify a filesystem (vfsmnt) and
> the 'name' pointer actually points to a filehandle fragment interpreted in
> that filesystem.
> 
> One problem is that there is no way to pass the length...
> Options:
>   fragment is at most 64 bytes nul padded at the end
>   fragment is hex encoded and nul terminated
>   ??
> 
> I think I prefer the hex encoding, but I'm hoping someone else has a better
> idea.

That makes it ugly for the kernel to stringify and parse the file handles. 

How about for AT_FILE_HANDLE THE FIRST __u32 (maybe with an extra __u32 for alignment) is the length and the rest of the binary file handle follows this?  In fact, doesn't the handle itself already encode the length in the header?

Cheers, Andreas