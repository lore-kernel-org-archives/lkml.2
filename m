Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2JRFhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 01:37:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54678 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2JRFhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 01:37:51 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-0b-507f95ae6fd0
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
 <201210161138.35388.arnd@arndb.de> <1350419915.1958.39.camel@kjgkr>
 <201210171225.01511.arnd@arndb.de>
In-reply-to: <201210171225.01511.arnd@arndb.de>
Subject: RE: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Thu, 18 Oct 2012 14:37:49 +0900
Message-id: <000501cdacf2$b604bf80$220e3e80$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2sYnhgMs3NzrlxQH+2YrlXclOZ7QAjfkcA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jQd11U+sDDHbt4rK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZDU+mMBdc56yY9ngOUwPjGvYuRk4OCQETiYZpT6FsMYkL99az
	gdhCAtMZJa7ecOli5AKy5zNJbP55kqWLkYODTUBbYvN+A5AaEQEviWer5zOD2MwC05kkppwT
	hqhfwSjxsPcb2FBOAX2JJY3fwYYKC3hIXPu6ASzOIqAqcWndLTCbV8BWYvGOc1C2oMSPyffA
	djELqEtMmZILMV9eYvOat8wgYQmg8KO/uhAnGEkcWN7OBFEiIrHvxTvGCYxCs5AMmoUwaBaS
	QbOQdCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzCz6R2MK5ssDjEKMDBqMTDe6mn
	PkCINbGsuDL3EKMEB7OSCG+NM1CINyWxsiq1KD++qDQntfgQozQHi5I4b7NHSoCQQHpiSWp2
	ampBahFMlomDU6qBMeva9p0/hbu3zLq/Mv38D7P8zUY3z6iYGTcUnj+nc5Nxr2WD6vx9shf1
	7hW7zTH2PfjJKipo0TJZab2AGYrVpZIZVQfvPlcuCzkopCGZ5liYb33DYF/ytz+iPuovmW8/
	vTmp4veP2ZGuLTseaRU6TfJb7rvfteBievWX6AXXFENumL5aLtf9U4mlOCPRUIu5qDgRAFky
	qgNdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> > >
> > > > > An xattr on the root inode that holds a list like this is something
> > > > > that could be set at mkfs time, but then also updated easily by new
> > > > > software packages that are installed...
> > >
> > > Yes, good idea.
> >
> > Likewise many file systems, f2fs also supports xattr as a configurable
> > Kconfig option.
> > If user disables the xattr feature, how can we do this?
> 
> I can see three options here:
> 
> * make the extension list feature dependent on xattr, and treat all files
>   the same if it's disabled.
> 
> * put the list into the superblock instead.
> 
> * fall back on a hardcoded list of extensions when the extended attribute
>   is not present or the feature is disabled.
> 

IMHO, we don't need to disable the extension list among the cases.
So, as I described before, I propose the following options.

* By default, mkfs stores an extension list in superblock, and f2fs simply
   uses it.
* If users try to handle cold files by themselves, they can give a hint
  via the xattr interface.
* Whenever they want not to use the default extension list, they can
  easily disable it by a mount option.

> 	Arnd

