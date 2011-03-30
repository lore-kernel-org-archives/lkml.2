Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab1C3Kub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:50:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab1C3Kua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CG5+GPdWgFwbTKSIt4tP1VTDICDWWU9iAEG4Jvz1ZhGc+VTQRnI+bu0SBkLimbM/v8
         ICYQXx/PFtUIK+CP+uCHBBIWwrvPFcKGw4acvpp1xWzPydhUQ3mvayy4g6Ag03muZxEQ
         +7cKwR8j99TKeUU7bc+jJnWwWfi/sMPceQxQ8=
Message-ID: <4D930AF0.2050708@redhat.com>
Date: Wed, 30 Mar 2011 12:50:24 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: Re: [GIT PULL] eCryptfs updates for 2.6.39-rc1
References: <20110328150205.GA9054@boyd.l.tihix.com>
In-Reply-To: <20110328150205.GA9054@boyd.l.tihix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 05:02 PM, Tyler Hicks wrote:
> Hi Linus,
>
> The eCryptfs patches for 2.6.39-rc1 are mainly fixes. Roberto's patches
> add key locking so keys aren't modified underneath us. Thieu's patch
> moves encryption to writepage so userspace isn't waiting on page
> encryption during each write(). My patches remove a wasteful
> encrypt/write operation during file creation and fix a missing page
> unlock in an error path.
>
> The following changes since commit 40471856f2e38e9bfa8d605295e8234421110dd6:
>
>    Merge branch 'nfs-for-2.6.39' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-03-25 10:03:28 -0700)
>
> are available in the git repository at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus
>
> Roberto Sassu (6):
>        eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix
>        eCryptfs: removed num_global_auth_toks from ecryptfs_mount_crypt_stat
>        eCryptfs: modified size of keysig in the ecryptfs_key_sig structure
>        eCryptfs: verify authentication tokens before their use
>        eCryptfs: move ecryptfs_find_auth_tok_for_sig() call before mutex_lock
>        eCryptfs: write lock requested keys
>
> Thieu Le (1):
>        ecryptfs: modify write path to encrypt page in writepage
>
> Tyler Hicks (3):
>        eCryptfs: Remove unnecessary grow_file() function
>        eCryptfs: Remove ECRYPTFS_NEW_FILE crypt stat flag
>        eCryptfs: Unlock page in write_begin error path

Is "eCryptfs: Handle failed metadata read in lookup" going into 2.6.39?

Paolo
