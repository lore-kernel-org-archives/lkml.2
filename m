Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1LLLfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:35:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44055 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab1LLLfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:35:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAOY=C6HuVEYpkap3dVmgmC7d+SDhvO-zc79RvCvkZCham3MiXg@mail.gmail.com>
References: <CAOY=C6HuVEYpkap3dVmgmC7d+SDhvO-zc79RvCvkZCham3MiXg@mail.gmail.com>
Date: Mon, 12 Dec 2011 12:35:52 +0100
Message-ID: <CAOY=C6GeaqnAOyYgt18xwV3KafHjMA_8QZQBqXEoXox4eNXPwA@mail.gmail.com>
Subject: Re: Oops in d_instantiate (fs/cache.c)
From: Stijn Devriendt <highguy@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 3, 2011 at 1:19 PM, Stijn Devriendt <highguy@gmail.com> wrote:
> Hi all,
>
> I've had 2 occasions where udev crashed during bootup.
> The second time carried a kernel log where the following line
> "BUG_ON(!list_empty(&entry->d_alias))"
> in d_instantiate is triggered when udev is attempting to
> create a symlink in /dev (which is tmpfs/shmem).
>
> I've tried reproducing this by doing as udev does:
> - create temporary symlink
> - move temporary symlink into place
> in a tight loop (multiple processes) while multiple
> other processes were removing the symlink in a
> tight loop.
> A third script was flushing the dentry/inode cache
> every so often using drop_caches.
> All to no avail.
>
> I've been digging around in the kernel sources,
> but I'm not sure what the d_alias field means
> and what the actual case is the BUG_ON is
> meant to catch. I'd like to be able to find a way
> to reproduce this, because so far it's happened only
> twice in 2 weeks over multiple systems doing
> many reboots in a testing setup.
> Can someone explain this to me in short?
>
> Thanks,
> Stijn

Trying resend...

Stijn
