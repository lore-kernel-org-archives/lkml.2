Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0FDSIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 14:08:37 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:32111 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0FDSIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 14:08:36 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Fri, 4 Jun 2010 18:07:00 +0000
Subject: RE: [PATCH -mmotm] cciss: fix build for CONFIG_PROC_FS=n
Thread-Topic: [PATCH -mmotm] cciss: fix build for CONFIG_PROC_FS=n
Thread-Index: AcsEBOdToZ92b+ITTHmV94bH5ugQUQAC7P5g
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D01432795@GVW0547EXC.americas.hpqcorp.net>
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
 <20100604094137.0702daa1.randy.dunlap@oracle.com>
In-Reply-To: <20100604094137.0702daa1.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Randy Dunlap [mailto:randy.dunlap@oracle.com] 
> Sent: Friday, June 04, 2010 11:42 AM
> To: linux-kernel@vger.kernel.org
> Cc: akpm@linux-foundation.org; Miller, Mike (OS Dev)
> Subject: [PATCH -mmotm] cciss: fix build for CONFIG_PROC_FS=n
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build for CONFIG_PROC_FS not enabled; fixes this build error:
> drivers/block/cciss.c:3422: error: implicit declaration of 
> function 'next_command'
> 
> Looks like the next_command() function was added at a bad 
> location in cciss-add-performant-mode-support-for-stars-sirius.patch.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, Randy. But I'm working on that plus a couple other miscues.

-- mikem

> Cc: Mike Miller <mike.miller@hp.com>
> ---
>  drivers/block/cciss.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- mmotm-2010-0603-1636.orig/drivers/block/cciss.c
> +++ mmotm-2010-0603-1636/drivers/block/cciss.c
> @@ -372,8 +372,6 @@ static const char *raid_label[] = { "0",  
> };  #define RAID_UNKNOWN (sizeof(raid_label) / 
> sizeof(raid_label[0])-1)
>  
> -#ifdef CONFIG_PROC_FS
> -
>  static inline u32 next_command(ctlr_info_t *h)  {
>  	u32 a;
> @@ -396,6 +394,8 @@ static inline u32 next_command(ctlr_info
>  	return a;
>  }
>  
> +#ifdef CONFIG_PROC_FS
> +
>  /*
>   * Report information about this controller.
>   */
> 