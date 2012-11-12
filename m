Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2KLLbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:31:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55463 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2KLLbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:31:15 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: <linux-fsdevel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] userns: Support fuse interacting with multiple user namespaces
References: <87objjcfp4.fsf@xmission.com>
Date: Mon, 12 Nov 2012 12:33:33 +0100
In-Reply-To: <87objjcfp4.fsf@xmission.com> (Eric W. Biederman's message of
	"Tue, 30 Oct 2012 23:34:47 -0700")
Message-ID: <87625brr76.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Use kuid_t and kgid_t in struct fuse_conn and struct fuse_mount_data.
>
> The connection between between a fuse filesystem and a fuse daemon is
> established when a fuse filesystem is mounted and provided with a file
> descriptor the fuse daemon created by opening /dev/fuse.
>
> For now restrict the communication of uids and gids between the fuse
> filesystem and the fuse daemon to the initial user namespace.

Why?

I think far more logical would be to limit a single instance of the
filesystem and the daemon to an arbitrary but *single* namespace.
I.e. one fuse_conn <-> one user namespace.

Is there a reason to treat the initial namespace specially?

Thanks,
Miklos
