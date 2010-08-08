Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0HHTN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:13:29 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4198 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab0HHTN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:13:28 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH 32/42] drivers/net/bnx2x: Adjust confusing if
 indentation
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Julia Lawall" <julia@diku.dk>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        yanivr@broadcom.com
In-Reply-To: <Pine.LNX.4.64.1008052226210.31692@ask.diku.dk>
References: <Pine.LNX.4.64.1008052226210.31692@ask.diku.dk>
Organization: Broadcom
Date: Sun, 8 Aug 2010 22:13:05 +0300
Message-ID: <1281294785.21680.3.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3
X-WSS-ID: 6041DE4637O54009310-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 13:26 -0700, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Outdent the code following the if.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r disable braces4@
> position p1,p2;
> statement S1,S2;
> @@
> 
> (
> if (...) { ... }
> |
> if (...) S1@p1 S2@p2
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> if (p1[0].column == p2[0].column):
>   cocci.print_main("branch",p1)
>   cocci.print_secs("after",p2)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Eilon Greenstein <eilong@broadcom.com>
> ---
> This patch doesn't change the semantics of the code.  But it might not be
> what is intended.

This is indeed just bad alignment, thanks for the fix



