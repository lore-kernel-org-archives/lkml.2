Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2LLPFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:05:09 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50738 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2LLPFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:05:08 -0500
MIME-Version: 1.0
In-Reply-To: <1355323077-5803-1-git-send-email-linkinjeon@gmail.com>
References: <1355323077-5803-1-git-send-email-linkinjeon@gmail.com>
Date: Wed, 12 Dec 2012 16:05:05 +0100
Message-ID: <CAJAFBLDE1k+sj4_FpjhSnaVF43twY2RRg=JsbdVVQOT0L4BPEw@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
From: Fubo Chen <fubo.chen@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 3:37 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> +       /* dot and dotdot dentries should have zero-value hash code */
> +       if (!memcmp(name, ".", 1) || !memcmp(name, "..", 2))
> +               return 0;

That looks suspicious. If memcmp(name, "..", 2) == 0 then always
memcmp(name, ".", 1) == 0. Why two tests ?

Fubo.
