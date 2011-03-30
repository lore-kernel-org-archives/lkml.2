Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1C3O2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:28:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54999 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab1C3O2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:28:16 -0400
Date: Wed, 30 Mar 2011 09:28:11 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: Re: [GIT PULL] eCryptfs updates for 2.6.39-rc1
Message-ID: <20110330142810.GA31091@boyd.l.tihix.com>
References: <20110328150205.GA9054@boyd.l.tihix.com>
 <4D930AF0.2050708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D930AF0.2050708@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Mar 30, 2011 at 12:50:24PM +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 03/28/2011 05:02 PM, Tyler Hicks wrote:
> >Hi Linus,
> >
> >The eCryptfs patches for 2.6.39-rc1 are mainly fixes. Roberto's patches
> >add key locking so keys aren't modified underneath us. Thieu's patch
> >moves encryption to writepage so userspace isn't waiting on page
> >encryption during each write(). My patches remove a wasteful
> >encrypt/write operation during file creation and fix a missing page
> >unlock in an error path.
> >
> >The following changes since commit 40471856f2e38e9bfa8d605295e8234421110dd6:
> >
> >   Merge branch 'nfs-for-2.6.39' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-03-25 10:03:28 -0700)
> >
> >are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus
> >
> >Roberto Sassu (6):
> >       eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix
> >       eCryptfs: removed num_global_auth_toks from ecryptfs_mount_crypt_stat
> >       eCryptfs: modified size of keysig in the ecryptfs_key_sig structure
> >       eCryptfs: verify authentication tokens before their use
> >       eCryptfs: move ecryptfs_find_auth_tok_for_sig() call before mutex_lock
> >       eCryptfs: write lock requested keys
> >
> >Thieu Le (1):
> >       ecryptfs: modify write path to encrypt page in writepage
> >
> >Tyler Hicks (3):
> >       eCryptfs: Remove unnecessary grow_file() function
> >       eCryptfs: Remove ECRYPTFS_NEW_FILE crypt stat flag
> >       eCryptfs: Unlock page in write_begin error path
> 
> Is "eCryptfs: Handle failed metadata read in lookup" going into 2.6.39?

Yes - while testing the above changes, I found some other issues with
the upper i_size and decided to hold off on pushing that patch until I
have a complete fix. It will definitely go into one of the 2.6.39-rcX
releases.

Tyler

> 
> Paolo
