Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab0HYCHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 22:07:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:46080 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab0HYCHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 22:07:07 -0400
Date: Wed, 25 Aug 2010 12:06:52 +1000
From: Neil Brown <neilb@suse.de>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andreas Dilger <andreas.dilger@oracle.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "adilger@sun.com" <adilger@sun.com>, "corbet@lwn.net" <corbet@lwn.net>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>,
        "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
        "philippe.deniel@CEA.FR" <philippe.deniel@CEA.FR>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Message-ID: <20100825120652.1a183152@notabene>
In-Reply-To: <m3r5hqjb5f.fsf@linux.vnet.ibm.com>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100820083057.GA10039@infradead.org>
	<20100820195303.20b17210@notabene>
	<20100820115135.GQ31363@ZenIV.linux.org.uk>
	<20100821100900.4b15fe08@notabene>
	<17761610-AFA9-4BB5-AF62-CD54D67F5C79@oracle.com>
	<20100823090604.6c735c80@notabene>
	<m3r5hqjb5f.fsf@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 08:19:48 +0530
"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> On Mon, 23 Aug 2010 09:06:04 +1000, Neil Brown <neilb@suse.de> wrote:
> > [[ Following this approach I would like to avoid any filehandle-specific
> > syscalls altogether.
> > Just use a *at syscall with AT_FILE_HANDLE for filehandle lookup, and use
> > getxattr('system:linux.file_handle') to get the filehandle for a given path.
> > 
> > Ofcourse we would need to at *at versions of the *xattr syscalls, but that is
> > probably a good idea anyway.
> > ]]
> 
> sys_setxattrat would take 7 arguments.
>

I count 6 - assuming we share the 'flags' argument.  There are only 2 xattr
flags currently so there should be room to share.

  dirfd  path name value size flags == 6

NeilBrown
