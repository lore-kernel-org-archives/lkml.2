Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0KTQPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 11:15:17 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:34512 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0KTQPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 11:15:16 -0500
Date: Sat, 20 Nov 2010 17:15:12 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Tejun Heo <tj@kernel.org>
Message-ID: <20101120161511.GD13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <f78fed4c9fd5836636f2d307d1ffb808a3c10923.1290087480.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f78fed4c9fd5836636f2d307d1ffb808a3c10923.1290087480.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 11/17] pps: simplify conditions a bit
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 07:01:04PM +0300, Alexander Gordeev wrote:
> Bitwise conjunction is distributive so we can simplify some conditions.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  drivers/pps/kapi.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> index 54261c4..2bdfbed 100644
> --- a/drivers/pps/kapi.c
> +++ b/drivers/pps/kapi.c
> @@ -184,8 +184,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
>  
>  	/* Check the event */
>  	pps->current_mode = pps->params.mode;
> -	if ((event & PPS_CAPTUREASSERT) &
> -			(pps->params.mode & PPS_CAPTUREASSERT)) {
> +	if (event & pps->params.mode & PPS_CAPTUREASSERT) {
>  		/* We have to add an offset? */
>  		if (pps->params.mode & PPS_OFFSETASSERT)
>  			pps_add_offset(&ts_real,
> @@ -199,8 +198,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
>  
>  		captured = ~0;
>  	}
> -	if ((event & PPS_CAPTURECLEAR) &
> -			(pps->params.mode & PPS_CAPTURECLEAR)) {
> +	if (event & pps->params.mode & PPS_CAPTURECLEAR) {
>  		/* We have to add an offset? */
>  		if (pps->params.mode & PPS_OFFSETCLEAR)
>  			pps_add_offset(&ts_real,
> -- 
> 1.7.2.3
> 

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
