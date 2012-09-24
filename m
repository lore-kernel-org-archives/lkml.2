Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2IYSdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:33:31 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52109 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab2IYSd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:33:28 -0400
Date: Sun, 23 Sep 2012 22:59:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove static from struct match_token used in
 token2str
Message-ID: <20120924025935.GA27627@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1348276860-21705-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348276860-21705-1-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 10:21:00PM -0300, Herton Ronaldo Krzesinski wrote:
> There is no reason to use static there, and it will cause issues when
> reading /proc/fs/ext4/<partition>/options concurrently.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> Cc: stable@vger.kernel.org # 3.4+

Herton,

Thanks for finding the bug fix!  I changed the commit descipription
slightly and have applied your patch to the ext4 tree.

	     	  	       	     	    - Ted

ext4: fix crash when accessing /proc/mounts concurrently

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

The crash was caused by a variable being erronously declared static in
token2str().

In addition to /proc/mounts, the problem can also be easily replicated
by accessing /proc/fs/ext4/<partition>/options in parallel:

$ cat /proc/fs/ext4/<partition>/options > options.txt

... and then running the following command in two different terminals:

$ while diff /proc/fs/ext4/<partition>/options options.txt; do true; done

This is also the cause of the following a crash while running xfstests
#234, as reported in the following bug reports:

	https://bugs.launchpad.net/bugs/1053019
	https://bugzilla.kernel.org/show_bug.cgi?id=47731

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Brad Figg <brad.figg@canonical.com>
Cc: stable@vger.kernel.org
