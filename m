Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0GMKaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:30:30 -0400
Received: from smtp.nokia.com ([192.100.122.230]:48262 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0GMKa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:30:27 -0400
Subject: Re: [PATCH] mtd: return -1 if verify failed
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C2D12C1.3000801@gmail.com>
References: <4C2D12C1.3000801@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 13:24:58 +0300
Message-ID: <1279016698.31639.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Jul 2010 10:29:52.0393 (UTC) FILETIME=[542D4790:01CB2276]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 00:12 +0200, Roel Kluin wrote:
> It should return -1 if the verify failed.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> I think this needed, correct?
> 
> diff --git a/drivers/mtd/tests/mtd_pagetest.c b/drivers/mtd/tests/mtd_pagetest.c
> index 6bc1b82..7414888 100644
> --- a/drivers/mtd/tests/mtd_pagetest.c
> +++ b/drivers/mtd/tests/mtd_pagetest.c
> @@ -358,7 +358,7 @@ static int erasecrosstest(void)
>  		printk(PRINT_PREF "verify failed!\n");
>  		errcnt += 1;
>  		ok = 0;
> -		return err;
> +		return -1;
>  	}

Yeah, I changed your patch a bit and removed the 'ok' variable
altogether. Pushed to l2-mtd-2.6.git, please, check:

http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/4e2ef8529d9bc2e2b96f18a1a2917bda5475f0e4

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

