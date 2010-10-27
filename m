Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0J0Jus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:50:48 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:57921 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0J0Jur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:50:47 -0400
Message-ID: <4CC7F5A7.4070505@ge.com>
Date: Wed, 27 Oct 2010 10:49:27 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 05/30] staging/vme: fix bogus clearing of the bus number
 in vme_free_bus_num
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-6-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-6-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 09:50:45.0357 (UTC) FILETIME=[6D0581D0:01CB75BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:10, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/vme.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 9fa0609..afd2dbd 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1348,7 +1348,7 @@ static int vme_alloc_bus_num(int *bus)
>  static void vme_free_bus_num(int bus)
>  {
>  	mutex_lock(&vme_bus_num_mtx);
> -	vme_bus_numbers |= ~(0x1 << bus);
> +	vme_bus_numbers &= ~(0x1 << bus);
>  	mutex_unlock(&vme_bus_num_mtx);
>  }
>  


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
