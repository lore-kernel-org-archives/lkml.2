Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1LTDZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:25:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38185 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1LTDZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:25:01 -0500
MIME-Version: 1.0
In-Reply-To: <20111220135704.8c87c166d9ac18d4ea308107@canb.auug.org.au>
References: <20111220131802.e3782dfbf8172281a7df5a5c@canb.auug.org.au>
 <CAB=NE6V12m2_u6YGxhmqjNGs9OjdOKFpCAYu5cs_Hezwwk9LLA@mail.gmail.com> <20111220135704.8c87c166d9ac18d4ea308107@canb.auug.org.au>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 19 Dec 2011 19:24:38 -0800
X-Google-Sender-Auth: tU1qqW_ochfINf-bgd_W4q3iagU
Message-ID: <CAB=NE6Wm8Np2_BSEZ1V5Cn0p3EL2qQ56aBV5JEGRSZXfwSp78w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zefir Kurtisi <zefir.kurtisi@neratec.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        mcgrof@bombadil.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 6:57 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Luis,
>
> On Mon, 19 Dec 2011 18:42:02 -0800 "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com> wrote:
>>
>> On Mon, Dec 19, 2011 at 6:18 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Hi John,
>> >
>> > After merging the wireless-next tree, today's linux-next build (x86_64
>> > allmodconfig) failed like this:
>> >
>> > drivers/net/wireless/ath/ath9k/dfs.c: In function 'ath9k_postprocess_radar_event':
>> > drivers/net/wireless/ath/ath9k/dfs.c:73:1: error: 'ATH_DBG_ATH_DBG_DFS' undeclared (first use in this function)
>> > drivers/net/wireless/ath/ath9k/dfs.c: In function 'ath9k_dfs_process_phyerr':
>> > drivers/net/wireless/ath/ath9k/dfs.c:166:1: error: 'ATH_DBG_ATH_DBG_DFS' undeclared (first use in this function)
>> >
>> > Caused by commit 29942bc12537 ("ath9k: add DFS radar pulse processing").
>> > ath_dbg prepends ATH_DBG_ to its second argument.
>> >
>> > I have used the wireless-next tree from next-20111219 for today.
>>
>> Odd, gitweb for wireless-next.git shows only one commit to dfs.c, the
>> change that introduced it:
>>
>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=history;f=drivers/net/wireless/ath/ath9k/dfs.c;h=e4e84a9e62730f3780a7eda6b4b00d535dd1d428;hb=HEAD
>>
>> In that version of the file I see nothing with ATH_DBG_ATH_DBG_DFS. I
>> also do not see it on wireless-testing.
>>
>> mcgrof@tux ~/wireless-testing (git::master)$ git show 29942bc12537 |
>> grep ATH_DBG_ATH_DBG_DFS
>
> Yeah, see my comment above .. search for ATH_DBG_DFS.

Ah fuck, Joe's patch got in *later* and it did not address changing
dfs.c. I had raised this as a comment to Joe's patch while we had
pending patches. It seems this is collateral damage or roadkill.

commit d2182b69dcb6a68b1ef6070b2efd094e13dea3f1
Author: Joe Perches <joe@perches.com>
Date:   Thu Dec 15 14:55:53 2011 -0800

    ath: Convert ath_dbg(bar, ATH_DBG_<FOO>, to ath_dbg(bar, FOO

    Add ATH_DBG_ to macros to shorten the uses and
    reduce the line count.

    Coalesce ath_dbg formats.
    Add missing spaces to coalesced formats.
    Add missing newline terminations to ath_dbg formats.
    Align ath_dbg arguments where appropriate.
    Standardize ath_dbg formats without periods.

    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Sorry for the trouble but the fix is trivial, I'll sumbit shortly.

  Luis
