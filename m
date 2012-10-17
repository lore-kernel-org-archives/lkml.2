Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2JQMZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:25:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54667 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2JQMZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:25:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Wed, 17 Oct 2012 12:25:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Dave Chinner'" <david@fromorbit.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <201210161138.35388.arnd@arndb.de> <1350419915.1958.39.camel@kjgkr>
In-Reply-To: <1350419915.1958.39.camel@kjgkr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210171225.01511.arnd@arndb.de>
X-Provags-ID: V02:K0:KkbTPRRC0MSBgIthX2RqUDW2sybDXkDAOsDgRZdHE2c
 aNn3gnesUd9gNRwFzo2AxGMqwOqrdYCcjlc6PHVxkV9GY8xYsf
 usdMpHHtpgHA+FmyYhpUXpXzPoDW3LgGn5s2JMbHTdogvlBi96
 3kQtrVx878KvSw8LA+bPx6re9DB1Nr9vUQV+i8jTY1K9Onlw3z
 I98y9t/Cm0RsbrtpeaGbfCcpulUuum1vmax/wLApFAVRxjr2gQ
 SbgXnwB7Luoqxm3S70PLoustgLPP6dn88TozTMoiDnriGMSC6e
 EhVNit/z1IeDQZ69FIi6k19SD+6Ra7kwIP+Cc65n2F/DWRH6gg
 tTQa+tJq7j3ok6ccP9To=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> > 
> > > > An xattr on the root inode that holds a list like this is something
> > > > that could be set at mkfs time, but then also updated easily by new
> > > > software packages that are installed...
> > 
> > Yes, good idea.
> 
> Likewise many file systems, f2fs also supports xattr as a configurable
> Kconfig option.
> If user disables the xattr feature, how can we do this?

I can see three options here:

* make the extension list feature dependent on xattr, and treat all files
  the same if it's disabled.

* put the list into the superblock instead. 

* fall back on a hardcoded list of extensions when the extended attribute
  is not present or the feature is disabled.

	Arnd
