Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1DSAeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 20:34:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49008 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab1DSAeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 20:34:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH v2] mempolicy: reduce references to the current
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1302847688-8076-1-git-send-email-namhyung@gmail.com>
References: <BANLkTinDFrbUNPnUmed2aBTu1_QHFQie-w@mail.gmail.com> <1302847688-8076-1-git-send-email-namhyung@gmail.com>
Message-Id: <20110419093421.9371.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 19 Apr 2011 09:34:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove duplicated reference to the 'current' task using a local
> variable. Since refering the current can be a burden, it'd better
> cache the reference, IMHO. At least this saves some bytes on x86_64.
> 
>   $ size mempolicy-{old,new}.o
>      text    data    bss     dec     hex filename
>     25203    2448   9176   36827    8fdb mempolicy-old.o
>     25136    2448   9184   36768    8fa0 mempolicy-new.o
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

But, dense stack usage is also performance good thing. Therefore your
patch benefit is not obvious. I have two request.

1) Please don't increase mess into no hot path. It's no worth.
2) Please mesure performance your box instead size command.

thanks.


