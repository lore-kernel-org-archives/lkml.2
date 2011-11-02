Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309Ab1KBPzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:55:49 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:9673 "EHLO CERNMX31.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383Ab1KBPzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:55:48 -0400
Date: Wed, 2 Nov 2011 16:51:36 +0100
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] staging: vme: fix address cast warnings for 64 bit
 architectures
Message-ID: <20111102155136.GA21603@becoht-mvanga>
Mail-Followup-To: gregkh@suse.de, martyn.welch@ge.com, cota@braap.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1320248826-18593-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320248826-18593-1-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please ignore this patch and look at the newer one.

Thanks

On Wed, Nov 02, 2011 at 04:47:06PM +0100, Manohar Vanga wrote:
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
> ---
>  drivers/staging/vme/bridges/vme_ca91cx42.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index 0e4feac..b768563 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -876,13 +876,13 @@ static ssize_t ca91cx42_master_read(struct vme_master_resource *image,
>  	 * maximal configured data cycle is used and splits it
>  	 * automatically for non-aligned addresses.
>  	 */
> -	if ((int)addr & 0x1) {
> +	if ((uintptr_t)addr & 0x1) {
>  		*(u8 *)buf = ioread8(addr);
>  		done += 1;
>  		if (done == count)
>  			goto out;
>  	}
> -	if ((int)addr & 0x2) {
> +	if ((uintptr_t)addr & 0x2) {
>  		if ((count - done) < 2) {
>  			*(u8 *)(buf + done) = ioread8(addr + done);
>  			done += 1;
> @@ -930,13 +930,13 @@ static ssize_t ca91cx42_master_write(struct vme_master_resource *image,
>  	/* Here we apply for the same strategy we do in master_read
>  	 * function in order to assure D16 cycle when required.
>  	 */
> -	if ((int)addr & 0x1) {
> +	if ((uintptr_t)addr & 0x1) {
>  		iowrite8(*(u8 *)buf, addr);
>  		done += 1;
>  		if (done == count)
>  			goto out;
>  	}
> -	if ((int)addr & 0x2) {
> +	if ((uintptr_t)addr & 0x2) {
>  		if ((count - done) < 2) {
>  			iowrite8(*(u8 *)(buf + done), addr + done);
>  			done += 1;
> @@ -990,7 +990,7 @@ static unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
>  	/* Lock image */
>  	spin_lock(&image->lock);
>  
> -	pci_addr = (u32)image->kern_base + offset;
> +	pci_addr = (uintptr_t)image->kern_base + offset;
>  
>  	/* Address must be 4-byte aligned */
>  	if (pci_addr & 0x3) {
> -- 
> 1.7.4.1
> 

-- 
/manohar
