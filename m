Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503Ab2J2Xtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:49:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab2J2Xti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:49:38 -0400
Date: Mon, 29 Oct 2012 16:49:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH 5/5] fat: add mutex lock to fat_build_inode
Message-Id: <20121029164936.2022db6c.akpm@linux-foundation.org>
In-Reply-To: <1351389223-2628-1-git-send-email-linkinjeon@gmail.com>
References: <1351389223-2628-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2012 10:53:43 +0900
Namjae Jeon <linkinjeon@gmail.com> wrote:

> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> fat_nfs_get_inode does not hold i_mutex of parent directory.So add
> lock to fat_build_inode.

Well..  why?  Presumably this patch fixes some race.  A good
description of that race would be useful - partly because others may
then be able to suggest alternative ways of fixing that bug.

I'll merge these patches for some testing.

I did merge these patches three weekes ago:

fat-modify-nfs-mount-option.patch
fat-exportfs-rebuild-inode-if-ilookup-fails.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch

But I have no record of Bruce or Ogawa having reviewed/acked them?
