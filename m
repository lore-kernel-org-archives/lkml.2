Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1H2RwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:52:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:18481 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1H2RwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:52:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="43075771"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@suse.de>
CC: Mike Thomas <rmthomas@sciolus.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@ispras.ru" <ldv-project@ispras.ru>
Date: Mon, 29 Aug 2011 20:51:51 +0300
Subject: RE: [PATCH] staging/easycap: fix mismatch in easycap_poll() mutex
 lock-unlock
Thread-Topic: [PATCH] staging/easycap: fix mismatch in easycap_poll() mutex
 lock-unlock
Thread-Index: Acxmc6yBOBkij8XWSPuwbMG+LHPEOgAAJSQg
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401C7A0567B@hasmsx504.ger.corp.intel.com>
References: <1314640017-27561-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1314640017-27561-1-git-send-email-khoroshilov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alexey Khoroshilov [mailto:khoroshilov@ispras.ru]
> Sent: Monday, August 29, 2011 8:47 PM
> To: Greg Kroah-Hartman
> Cc: Alexey Khoroshilov; Winkler, Tomas; Mike Thomas;
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; ldv-
> project@ispras.ru
> Subject: [PATCH] staging/easycap: fix mismatch in easycap_poll() mutex lock-
> unlock
> 
> In case if condition (kd != isdongle(peasycap)) becomes true,
> easycap_poll() returns without releasing
> easycapdc60_dongle[kd].mutex_video.
> The patch adds mutex_unlock() before that return.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>


Looks correct, thanks
Tomas

> ---
>  drivers/staging/easycap/easycap_main.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/easycap/easycap_main.c
> b/drivers/staging/easycap/easycap_main.c
> index bea2816..3ea51c3 100644
> --- a/drivers/staging/easycap/easycap_main.c
> +++ b/drivers/staging/easycap/easycap_main.c
> @@ -953,8 +953,10 @@ static unsigned int easycap_poll(struct file *file,
> poll_table *wait)
>  	 *  peasycap, IN WHICH CASE A REPEAT CALL TO isdongle() WILL FAIL.
>  	 *  IF NECESSARY, BAIL OUT.
>  	 */
> -		if (kd != isdongle(peasycap))
> +		if (kd != isdongle(peasycap)) {
> +
> 	mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
>  			return -ERESTARTSYS;
> +		}
>  		if (!file) {
>  			SAY("ERROR:  file is NULL\n");
> 
> 	mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
> --
> 1.7.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

