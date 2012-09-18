Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2IRKbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:31:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51462 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2IRKbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:31:38 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-6f-5058495b03b2
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Peter Senna Tschudin'" <peter.senna@gmail.com>, cjb@laptop.org
Cc: will.newton@imgtec.com, jh80.chung@samsung.com, kyungmin.park@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
 <1347884417-26754-1-git-send-email-peter.senna@gmail.com>
In-reply-to: <1347884417-26754-1-git-send-email-peter.senna@gmail.com>
Subject: RE: [PATCH v2 1/4] drivers/mmc/host/dw_mmc.c: fix error return code
Date: Tue, 18 Sep 2012 19:13:47 +0900
Message-id: <018101cd9586$4ac78b40$e056a1c0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2UztRTiG4Y9nlwQae9jPIgvBXoJQAta1ZA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jAd1oz4gAgyn/9Cy23pK2uLxrDpvF
	kf/9jA7MHp83yQUwRnHZpKTmZJalFunbJXBl/Lz5nLngL2vFh2/32RsYj7B0MXJySAiYSEy9
	P5MJwhaTuHBvPRuILSSwiFFi5mGhLkYuIPsPo8S32XfAitgEtCT+vnnDDGKLCDhJfJ35lQWk
	iFlgNaPErJ7XUN0NjBKtzS4gNqeAm8Tq1zvAtgkL+Eg8/XEJzGYRUJVo7z3FCmLzCthKnGib
	BWULSvyYfA+shlnAQOL9rD5WCFteYvOat0CLOYAuVZd49FcX4gYjiVdvrrBBlIhI7HvxjnEC
	o9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDu1nUjsYVzZY
	HGIU4GBU4uENdAkPEGJNLCuuzD3EKMHBrCTC6ysdESDEm5JYWZValB9fVJqTWnyIUZqDRUmc
	V/hTYICQQHpiSWp2ampBahFMlomDU6qBUXDfGaWD2ufMWB9men1y5Iq7sm1ad+LzB4lKRU2c
	JvuLNtWyhbVzuLJ+Wvm+dvKmmFz2VQmNjtcE9F/WRt353X/v7Eu5zkX79i2KFi+StXB65zqn
	MU3lfWSqhD97euLOXV+jJEp3zH5jm1UqM399Rfx2uytV/HEcvaX3Of/az8hW0eKb1caixFKc
	kWioxVxUnAgAkl4t9WkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 17, 2012, Peter Senna Tschudin <peter.senna@gmail.com> wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Looks good.
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

> --
> 1.7.11.4

