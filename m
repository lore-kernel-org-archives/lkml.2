Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab2GCRWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:22:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50221 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GCRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:22:22 -0400
Message-ID: <4FF329F5.6000801@mvista.com>
Date: Tue, 03 Jul 2012 21:20:53 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Du, Changbin" <changbin.du@gmail.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, ben@simtec.co.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: gadget: s3c-hsotg: fix core reset timeout failure
References: <4ff252e7.08d4440a.38ee.ffffd7b9@mx.google.com>
In-Reply-To: <4ff252e7.08d4440a.38ee.ffffd7b9@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/03/2012 06:03 AM, Du, Changbin wrote:

> The timeout values were 1000 and timeout issue occured many times on my
> s3c6410 Soc based board (mostly when booting whith USB cable not
> connected). This patch increase the values to 10000 to guarantee the
> success of reset.

> Having set timeout to 10000, I printed the remained timeout values
> which can cause timeout issue before this change (tested several times):
> the first timeout value remained:
> 	timeout = 8079
> 	timeout = 8079
> 	timeout = 8078
> 	timeout = 8081
> the second timeout value remained:
> 	timeout = 7940
> 	timeout = 7945
> 	timeout = 7940
> 	timeout = 7938
> Seeing from above values, I think 10000 is big enough.

> Signed-off-by: Du, Changbin <changbin.du@gmail.com>
> ---
>  drivers/usb/gadget/s3c-hsotg.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index f4abb0e..f3e2234 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -2215,7 +2215,7 @@ static int s3c_hsotg_corereset(struct s3c_hsotg
> *hsotg)

  Your patch is line wrapped; seems easy to fix manually while applying though...

WBR, Sergei
