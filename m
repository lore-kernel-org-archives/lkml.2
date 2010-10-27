Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050Ab0J0M0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:26:16 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:42937 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab0J0M0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:26:14 -0400
Message-ID: <4CC81A17.7090805@ge.com>
Date: Wed, 27 Oct 2010 13:24:55 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 24/30] staging/vme_user: remove unnecessary call to vme_slave_set
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-25-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-25-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 12:26:12.0692 (UTC) FILETIME=[248BE140:01CB75D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:11, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> The resource is about to be freed and therefore it is pointless to
> set any of its parameters.

Nope - this is disabling the window, which given that you are about to
unalloc the memory that it is using this is quite important.

Martyn

> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>
> ---
>  drivers/staging/vme/devices/vme_user.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index 95c22ff..a1cb85b 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -851,7 +851,6 @@ static int __devexit vme_user_remove(struct device *dev, int cur_bus, int cur_sl
>  		kfree(image[i].kern_buf);
>  
>  	for (i = SLAVE_MINOR; i < (SLAVE_MAX + 1); i++) {
> -		vme_slave_set(image[i].resource, 0, 0, 0, 0, VME_A32, 0);
>  		buf_unalloc(i);
>  		vme_slave_free(image[i].resource);
>  	}


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
