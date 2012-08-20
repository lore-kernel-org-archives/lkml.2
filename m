Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2HTHZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:25:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46052 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HTHY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:24:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6809"; a="227096438"
X-IronPort-AV: E=Sophos;i="4.77,796,1336374000"; 
   d="scan'208";a="160606705"
Message-ID: <5031E643.1070105@qca.qualcomm.com>
Date: Mon, 20 Aug 2012 10:24:51 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: <kernel-janitors@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] drivers/net/wireless/ath/ath6kl/main.c: introduce
 missing initialization
References: <1345325159-7365-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1345325159-7365-4-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2012 12:25 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The result of one call to a function is tested, and then at the second call
> to the same function, the previous result, and not the current result, is
> tested again.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression ret;
> identifier f;
> statement S1,S2;
> @@
> 
> *ret = f(...);
> if (\(ret != 0\|ret < 0\|ret == NULL\)) S1
> ... when any
> *f(...);
> if (\(ret != 0\|ret < 0\|ret == NULL\)) S2
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks, but this was already fixed in ath6kl.git by this commit:

commit 3206209f231062170f060fdbae38faacff86ddbf
Author: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
Date:   Wed Jul 11 12:51:43 2012 +0530

    ath6kl: Make use of return value from ath6kl_diag_read()

    In ath6kl_read_fwlogs(), return value from ath6kl_diag_read()is not
    used to bail out in case of any errors in reading fw log. No real issue
    is observed because of this, reported by source code analyzer.

    kvalo: fix a long line warning

    Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle
