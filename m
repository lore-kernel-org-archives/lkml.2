Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2H3BgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 21:36:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28682 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab2H3Bfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 21:35:44 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-30-503ec36e2782
From: IAN CHEN <ian.cy.chen@samsung.com>
To: "'Chris Ball'" <cjb@laptop.org>
Cc: linkinjeon@gmail.com, adrian.hunter@intel.com, subhashj@codeaurora.org,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, d.j.shin@samsung.com,
        jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com
References: <503DB130.8090807@samsung.com> <873936vvrg.fsf@octavius.laptop.org>
In-reply-to: <873936vvrg.fsf@octavius.laptop.org>
Subject: RE: [PATCH v6] mmc: card: Skip secure option for MoviNAND.
Date: Thu, 30 Aug 2012 10:36:42 +0900
Message-id: <000401cd864f$e881a000$b984e000$%cy.chen@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2F0Nzv/m0p0X1hQW67tiQ6mWfOJwAfCLMQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jAd28w3YBBkc7RSwu75rDZnHkfz+j
	A5PH501yAYxRXDYpqTmZZalF+nYJXBmPL15lL5grUHF2+wXGBsajvF2MnBwSAiYSi/e9ZoGw
	xSQu3FvP1sXIxSEksIhRYs2RfywQzl9GiWeHzrGBVLEJaEh8P/iEEcQWEVCU2PL9ODtIEbNA
	O5PEl94TYEVCAv4Si670gRVxChhKrLl6m6mLkYNDWMBZ4u33IJAwi4CqxIRTf8E28wo4Stzb
	2sAOYQtK/Jh8DyzOLKAlsX7ncSYIW15i85q3zCBjJATUJR791QUxRQSMJJ49V4WoEJeY9OAh
	+wRGoVlIBs1CMmgWkkGzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc0M+kdjCu
	bLA4xCjAwajEw8uRaRcgxJpYVlyZe4hRgoNZSYT300qgEG9KYmVValF+fFFpTmrxIUZpDhYl
	cV7+PsMAIYH0xJLU7NTUgtQimCwTB6dUA6NO/PQ5atyHrn96e3rOcW7fK/wNj+7dXXQn4KSl
	4TxNw1368hln3CYlTPjpk7pClXOC/ZvXJ3b2KqulGnEXc8T7h679IWkdNNWua0K5pESzxKZP
	cXPstZJT5nBZl788uPLpYq9PaZLNYaWCM/cwXPv+gc9CUtXDwiX1iOY9G749u/14S7ceeazE
	UpyRaKjFXFScCAA/uWZMZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your help.
The effected kernel will be all the version with MMC_CAP_ERASE & SECURE
option enabled.
As commit content mentioned, the problem is unrecoverable corruption after
SECURE ERASE or SECURE TRIM.
For devices using defective eMMC with kernel supporting MMC_CAP_ERASE &
SECURE option, this issue might cause damage.
Therefore, we skip secure for these known devices.

Regards,
Ian

-----Original Message-----
From: Chris Ball [mailto:cjb@laptop.org] 
Sent: Wednesday, August 29, 2012 7:27 PM

Hi,

On Wed, Aug 29 2012, IAN CHEN wrote:
> For several MoviNAND, there are some known issue with secure option.
> For these specific MoviNAND device, we skip secure option.
>
> You could refer this discussion in XDA developers.
> http://forum.xda-developers.com/showthread.php?t=1644364
>
https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485184
813224730/posts/21pTYfTsCkB
>
> Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks.  We should explain the nature of the bug in the commit message,
so that users and the stable@ maintainers know how bad the problem is
by reading the patch.  (This should go to stable@, right?  Do you know
which kernel versions are affected?)

I'll add something like this, unless you have a better proposal:

==
For several MoviNAND, there are some known issues with secure option.
For these specific MoviNAND device, we skip secure option.

Specifically, there is a bug in the eMMC firmware that causes 
unrecoverable corruption when the MMC is erased with MMC_CAP_ERASE
enabled.

You could refer this discussion in XDA developers.
http://forum.xda-developers.com/showthread.php?t=1644364
https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485184
813224730/posts/21pTYfTsCkB
==

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

