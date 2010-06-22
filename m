Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab0FVVft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:35:49 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:46190 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab0FVVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:35:44 -0400
X-Authority-Analysis: v=1.0 c=1 a=Y4kVDsoNLLAA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=hGzw-44bAAAA:8 a=6UT2YofcClCzWf3PPoQA:9 a=Ipo6nwFRv7ENfF13HvmH_iG48b8A:4 a=CjuIK1q_8ugA:10 a=0kPLrQdw3YYA:10 a=dowx1zmaLagA:10
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Tue, 22 Jun 2010 17:37:42 -0400
From: Jeff Layton <jlayton@samba.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 02/10] cifs: guard cifsglob.h against multiple
 inclusion
Message-ID: <20100622173742.448e1e94@corrin.poochiereds.net>
In-Reply-To: <1277220170-3442-1-git-send-email-sjayaraman@suse.de>
References: <yes>
	<1277220170-3442-1-git-send-email-sjayaraman@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 20:52:50 +0530
Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Add conditional compile macros to guard the header file against multiple
> inclusion.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
>  fs/cifs/cifsglob.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index a88479c..6b2c39d 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -16,6 +16,9 @@
>   *   the GNU Lesser General Public License for more details.
>   *
>   */
> +#ifndef _CIFS_GLOB_H
> +#define _CIFS_GLOB_H
> +
>  #include <linux/in.h>
>  #include <linux/in6.h>
>  #include <linux/slab.h>
> @@ -733,3 +736,5 @@ GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
>  GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
>  
>  extern const struct slow_work_ops cifs_oplock_break_ops;
> +
> +#endif	/* _CIFS_GLOB_H */

Strong ACK

Acked-by: Jeff Layton <jlayton@samba.org>
