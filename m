Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1LTCmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:42:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35923 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1LTCmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:42:23 -0500
MIME-Version: 1.0
In-Reply-To: <20111220131802.e3782dfbf8172281a7df5a5c@canb.auug.org.au>
References: <20111220131802.e3782dfbf8172281a7df5a5c@canb.auug.org.au>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 19 Dec 2011 18:42:02 -0800
X-Google-Sender-Auth: 4jj65UL2Ey_3xpFsw-YVmm0RrT0
Message-ID: <CAB=NE6V12m2_u6YGxhmqjNGs9OjdOKFpCAYu5cs_Hezwwk9LLA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zefir Kurtisi <zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 6:18 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi John,
>
> After merging the wireless-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/net/wireless/ath/ath9k/dfs.c: In function 'ath9k_postprocess_radar_event':
> drivers/net/wireless/ath/ath9k/dfs.c:73:1: error: 'ATH_DBG_ATH_DBG_DFS' undeclared (first use in this function)
> drivers/net/wireless/ath/ath9k/dfs.c: In function 'ath9k_dfs_process_phyerr':
> drivers/net/wireless/ath/ath9k/dfs.c:166:1: error: 'ATH_DBG_ATH_DBG_DFS' undeclared (first use in this function)
>
> Caused by commit 29942bc12537 ("ath9k: add DFS radar pulse processing").
> ath_dbg prepends ATH_DBG_ to its second argument.
>
> I have used the wireless-next tree from next-20111219 for today.

Odd, gitweb for wireless-next.git shows only one commit to dfs.c, the
change that introduced it:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=history;f=drivers/net/wireless/ath/ath9k/dfs.c;h=e4e84a9e62730f3780a7eda6b4b00d535dd1d428;hb=HEAD

In that version of the file I see nothing with ATH_DBG_ATH_DBG_DFS. I
also do not see it on wireless-testing.

mcgrof@tux ~/wireless-testing (git::master)$ git show 29942bc12537 |
grep ATH_DBG_ATH_DBG_DFS

  Luis
