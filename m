Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab0HEJFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:05:25 -0400
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:58032 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758861Ab0HEJFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:05:22 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 05:05:22 EDT
Date: Thu, 5 Aug 2010 11:05:17 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Message-ID: <20100805090517.GF26615@gundam.enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	john stultz <johnstul@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joonwoo Park <joonwpark81@gmail.com>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su> <499466fe6558d89bff6092768c57e5c928d99b13.1280952801.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499466fe6558d89bff6092768c57e5c928d99b13.1280952801.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv3 02/16] pps: declare variables where they are used in
	switch
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 01:06:39AM +0400, Alexander Gordeev wrote:
> Move variable declarations where they are used in pps_cdev_ioctl.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  drivers/pps/pps.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
> index ca5183b..c76afb9 100644
> --- a/drivers/pps/pps.c
> +++ b/drivers/pps/pps.c
> @@ -61,8 +61,6 @@ static long pps_cdev_ioctl(struct file *file,
>  {
>  	struct pps_device *pps = file->private_data;
>  	struct pps_kparams params;
> -	struct pps_fdata fdata;
> -	unsigned long ticks;
>  	void __user *uarg = (void __user *) arg;
>  	int __user *iuarg = (int __user *) arg;
>  	int err;
> @@ -136,7 +134,9 @@ static long pps_cdev_ioctl(struct file *file,
>  
>  		break;
>  
> -	case PPS_FETCH:
> +	case PPS_FETCH: {
> +		struct pps_fdata fdata;
> +
>  		pr_debug("PPS_FETCH: source %d\n", pps->id);
>  
>  		err = copy_from_user(&fdata, uarg, sizeof(struct pps_fdata));
> @@ -149,6 +149,8 @@ static long pps_cdev_ioctl(struct file *file,
>  		if (fdata.timeout.flags & PPS_TIME_INVALID)
>  			err = wait_event_interruptible(pps->queue, pps->go);
>  		else {
> +			unsigned long ticks;
> +
>  			pr_debug("timeout %lld.%09d\n",
>  					(long long) fdata.timeout.sec,
>  					fdata.timeout.nsec);
> @@ -185,7 +187,7 @@ static long pps_cdev_ioctl(struct file *file,
>  			return -EFAULT;
>  
>  		break;
> -
> +	}
>  	default:
>  		return -ENOTTY;
>  		break;
> -- 
> 1.7.1

I don't like such definitions but I know it is just a stylistic
problem, so it's ok for me. :)

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
