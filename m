Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030Ab0J0MVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:21:25 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:34686 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab0J0MVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:21:23 -0400
Message-ID: <4CC818F3.7000107@ge.com>
Date: Wed, 27 Oct 2010 13:20:03 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 15/30] staging/vme_user: remove __iomem marking from kern_buf
 and derivates
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-16-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-16-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 12:21:21.0637 (UTC) FILETIME=[77106950:01CB75D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:11, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> kern_buf is not iomem; it comes from kmalloc and is directly
> dereferenced.
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/devices/vme_user.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index e7669a4..ead30d2 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -92,7 +92,7 @@ static unsigned int bus_num;
>   * Structure to handle image related parameters.
>   */
>  typedef struct {
> -	void __iomem *kern_buf;	/* Buffer address in kernel space */
> +	void *kern_buf;	/* Buffer address in kernel space */
>  	dma_addr_t pci_buf;	/* Buffer address in PCI address space */
>  	unsigned long long size_buf;	/* Buffer size */
>  	struct semaphore sem;	/* Semaphore for locking image */
> @@ -277,7 +277,7 @@ static ssize_t resource_from_user(unsigned int minor, const char *buf,
>  static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
>  	size_t count, loff_t *ppos)
>  {
> -	void __iomem *image_ptr;
> +	void *image_ptr;
>  	ssize_t retval;
>  
>  	image_ptr = image[minor].kern_buf + *ppos;
> @@ -296,7 +296,7 @@ static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
>  static ssize_t buffer_from_user(unsigned int minor, const char *buf,
>  	size_t count, loff_t *ppos)
>  {
> -	void __iomem *image_ptr;
> +	void *image_ptr;
>  	size_t retval;
>  
>  	image_ptr = image[minor].kern_buf + *ppos;


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
