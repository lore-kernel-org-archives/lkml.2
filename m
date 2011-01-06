Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1AFGrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 01:47:16 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58968 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1AFGrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 01:47:14 -0500
Date: Thu, 6 Jan 2011 15:45:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/video/carminefb.c: improve error handling
Message-ID: <20110106064517.GD15340@linux-sh.org>
References: <Pine.LNX.4.64.1101021527220.10933@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1101021527220.10933@ask.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 02, 2011 at 03:27:42PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> This code had an error handling goto to the wrong place, a misplaced
> release_mem_region, and a duplicated release_mem_region.
> 
> The semantic match that finds the double release_mem_region is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> expression e1,e2,e3;
> position p1,p2,p3;
> @@
> release_mem_region@p1(e1, e2)@p3;
> ... when != request_mem_region(e1,e2,e3)
> release_mem_region(e1, e2)@p2;
> 
> @@
> expression e <= r.e1,e3;
> expression r.e1,e2;
> position r.p1,r.p2,r.p3,p!=r.p1;
> @@
> *release_mem_region(e1, e2)@p3;
> ... when != e = e3
> *release_mem_region@p(e1, e2)@p2;// </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
Applied, thanks.
