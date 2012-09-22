Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2IVL2P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 07:28:15 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41613 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2IVL2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 07:28:14 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 1/5] fat: modify nfs mount option
References: <1347798130-2626-1-git-send-email-linkinjeon@gmail.com>
Date: Sat, 22 Sep 2012 20:28:04 +0900
In-Reply-To: <1347798130-2626-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 16 Sep 2012 08:22:10 -0400")
Message-ID: <87pq5e8fgb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +		case Opt_nfs_full:
> +			opts->nfs = FAT_NFS_FULL;
> +			break;
> +		case Opt_nfs_limited:
> +			opts->nfs = FAT_NFS_LIMITED;
> +			sb->s_flags |= MS_RDONLY;
> +			break;

Check opt->nfs at end of parse_option(). Otherwise, multiple nfs options
would confuse it.

E.g.

	mount -o nfs=limited_stable,nfs=full_unstable

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
