Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2A3RWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:22:19 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:49042 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751749Ab2A3RWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:22:18 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yLKaNj8VM1mw1kmJB9AoPgk2UvHEjf0trP25wqogMcn154c
 Lr7qMaT8Pg8JvVIdH7uvj.s3FPofI.6K5CBbwEGe2S8HNeFfT9t5oFEe2CG5
 a951A.vqj9Ro41PaPTIGnlqdqY6.QQzUKbaXzDKXMnR6MqXxfb4GKfZKAL0W
 JTmYvTPizpBJWaPZ6EChDArTVfxMFH9gQKoyvF8ys2jDOHkj0TrFj0W.cY_b
 KcpYuoAuurxa_obzYoBf7.W9Sykm1Da6kAvZ72SvF4HxLtzfoLNwJdxA1SuA
 m1oB7UaRNn7Jd26A8N57rZuWQL5QFuvUhEn_tv9etme6ih7t6Tyf9uiRobtt
 j41SB4BDB5ogcx06sp4w7Z4Mw_OSNbAzT95oyHsTZCscZZ18ntp0.Ex.9Woh
 LUfJvutR8z3MLuEaejX.qysYqwaZFcyQOvVtZ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jan 2012 11:22:14 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
In-Reply-To: <20120130171558.GB3355@google.com>
Message-ID: <alpine.DEB.2.00.1201301121330.28693@router.home>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org> <20120130171558.GB3355@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Tejun Heo wrote:

> Percpu pointers are in a different address space and using
> ZERO_SIZE_PTR directly will trigger sparse address space warning.
> Also, I'm not entirely sure whether 16 is guaranteed to be unused in
> percpu address space (maybe it is but I don't think we have anything
> enforcing that).

We are already checking for NULL on free. So there is a presumption that
these numbers are unused.

