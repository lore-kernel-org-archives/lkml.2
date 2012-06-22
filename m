Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583Ab2FVRr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:47:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56155 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2FVRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:47:56 -0400
MIME-Version: 1.0
In-Reply-To: <1339545940-11736-2-git-send-email-tyhicks@canonical.com>
References: <1338061161.4284.16.camel@lappy> <1339545940-11736-1-git-send-email-tyhicks@canonical.com>
 <1339545940-11736-2-git-send-email-tyhicks@canonical.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 22 Jun 2012 19:47:35 +0200
Message-ID: <CA+1xoqeJ8j5Dp1C6QtEvHhQVcVUKsCVCGhXVcceH9b669nEYAw@mail.gmail.com>
Subject: Re: [PATCH 1/3] eCryptfs: Gracefully refuse miscdev file ops on
 inherited/passed files
To: Tyler Hicks <tyhicks@canonical.com>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 2:05 AM, Tyler Hicks <tyhicks@canonical.com> wrote:
> File operations on /dev/ecryptfs would BUG() when the operations were
> performed by processes other than the process that originally opened the
> file. This could happen with open files inherited after fork() or file
> descriptors passed through IPC mechanisms. Rather than calling BUG(), an
> error code can be safely returned in most situations.
>
> In ecryptfs_miscdev_release(), eCryptfs still needs to handle the
> release even if the last file reference is being held by a process that
> didn't originally open the file. ecryptfs_find_daemon_by_euid() will not
> be successful, so a pointer to the daemon is stored in the file's
> private_data. The private_data pointer is initialized when the miscdev
> file is opened and only used when the file is released.
>
> https://launchpad.net/bugs/994247
>
> Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Cc: Sasha Levin <levinsasha928@gmail.com>
> ---

I've been running it a while now and haven't seen the problem I've
reported reproducing.

Is it possible to merge this fix into 3.5?
