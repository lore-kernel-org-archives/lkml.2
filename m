Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab0HEJKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:10:16 -0400
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:56487 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab0HEJKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:10:12 -0400
Date: Thu, 5 Aug 2010 10:57:58 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Message-ID: <20100805085758.GE26615@gundam.enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	john stultz <johnstul@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su> <94867e6226b5d6dd7231a829a2752232fe3a5ca2.1280952801.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94867e6226b5d6dd7231a829a2752232fe3a5ca2.1280952801.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv3 01/16] pps: trivial fixes
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 01:06:38AM +0400, Alexander Gordeev wrote:
> Here are some very trivial fixes combined:
>  * add macro definitions to protect header file from including several times
>  * remove declaration for an unexistent array
>  * fix typos
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  drivers/pps/kapi.c         |    2 +-
>  include/linux/pps_kernel.h |    7 ++++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> index 1aa02db..55f3961 100644
> --- a/drivers/pps/kapi.c
> +++ b/drivers/pps/kapi.c
> @@ -324,7 +324,7 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
>  		captured = ~0;
>  	}
>  
> -	/* Wake up iif captured somthing */
> +	/* Wake up if captured something */
>  	if (captured) {
>  		pps->go = ~0;
>  		wake_up_interruptible(&pps->queue);
> diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> index e0a193f..c930d11 100644
> --- a/include/linux/pps_kernel.h
> +++ b/include/linux/pps_kernel.h
> @@ -18,6 +18,9 @@
>   *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#ifndef LINUX_PPS_KERNEL_H
> +#define LINUX_PPS_KERNEL_H
> +
>  #include <linux/pps.h>
>  
>  #include <linux/cdev.h>
> @@ -71,7 +74,6 @@ struct pps_device {
>  
>  extern spinlock_t pps_idr_lock;
>  extern struct idr pps_idr;
> -extern struct timespec pps_irq_ts[];
>  
>  extern struct device_attribute pps_attrs[];
>  
> @@ -87,3 +89,6 @@ extern void pps_unregister_source(int source);
>  extern int pps_register_cdev(struct pps_device *pps);
>  extern void pps_unregister_cdev(struct pps_device *pps);
>  extern void pps_event(int source, struct pps_ktime *ts, int event, void *data);
> +
> +#endif /* LINUX_PPS_KERNEL_H */
> +
> -- 
> 1.7.1

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
