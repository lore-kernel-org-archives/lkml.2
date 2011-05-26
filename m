Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab1EZUcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:32:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757744Ab1EZUco convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:32:44 -0400
MIME-Version: 1.0
In-Reply-To: <20110526202505.GA6367@mail.hallyn.com>
References: <20110526202505.GA6367@mail.hallyn.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 13:31:50 -0700
Message-ID: <BANLkTi=dhwdPGj=yU=NRaSkK-BBTPQNKOA@mail.gmail.com>
Subject: Re: [PATCH] Set cred->user_ns in key_replace_session_keyring
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        David Howells <dhowells@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't this also be "Cc: stable" for 2.6.39?

Bug introduced by commit 47a150edc2a, no?

                Linus

On Thu, May 26, 2011 at 1:25 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Since this cred was not created with copy_creds(), it needs to get
> initialized.  Otherwise use of syscall(__NR_keyctl, KEYCTL_SESSION_TO_PARENT);
> can lead to a NULL deref.  Thanks to Robert for finding this.
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Reported-by: Robert Święcki <robert@swiecki.net>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  security/keys/process_keys.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index 6c0480d..92a3a5d 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -847,6 +847,7 @@ void key_replace_session_keyring(void)
>        new-> sgid      = old-> sgid;
>        new->fsgid      = old->fsgid;
>        new->user       = get_uid(old->user);
> +       new->user_ns    = new->user->user_ns;
>        new->group_info = get_group_info(old->group_info);
>
>        new->securebits = old->securebits;
> --
> 1.7.0.4
>
>
