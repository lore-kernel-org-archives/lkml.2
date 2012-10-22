Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2JVVFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:05:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51821 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2JVVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:05:41 -0400
Date: Mon, 22 Oct 2012 14:05:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sangho Yi <antiroot@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: csr: Fixed indentation from 4 spaces to
 tabs on mlme.c
Message-ID: <20121022210537.GC23826@kroah.com>
References: <n>
 <1350405408-2702-1-git-send-email-antiroot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350405408-2702-1-git-send-email-antiroot@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 01:36:45AM +0900, Sangho Yi wrote:
> There were all the 4 spaces indentation, so I fixed them using the tabs.
> 
> Signed-off-by: Sangho Yi <antiroot@gmail.com>
> ---
>  drivers/staging/csr/mlme.c |  598 ++++++++++++++++++++++----------------------
>  1 file changed, 299 insertions(+), 299 deletions(-)
> 
> diff --git a/drivers/staging/csr/mlme.c b/drivers/staging/csr/mlme.c
> index ed767ec..a16841f 100644
> --- a/drivers/staging/csr/mlme.c
> +++ b/drivers/staging/csr/mlme.c
> @@ -1,9 +1,9 @@
>  /*
>   * ---------------------------------------------------------------------------
> - * FILE:     mlme.c
> + * FILE:	 mlme.c
>   *
>   * PURPOSE:
> - *      This file provides functions to send MLME requests to the UniFi.
> + *	  This file provides functions to send MLME requests to the UniFi.
>   *
>   * Copyright (C) 2007-2008 by Cambridge Silicon Radio Ltd.
>   *
> @@ -19,114 +19,114 @@
>   * ---------------------------------------------------------------------------
>   * unifi_mlme_wait_for_reply
>   *
> - *      Wait for a reply after sending a signal.
> + *	  Wait for a reply after sending a signal.
>   *
>   * Arguments:
> - *      priv            Pointer to device private context struct
> - *      ul_client       Pointer to linux client
> - *      sig_reply_id    ID of the expected reply (defined in sigs.h).
> - *      timeout         timeout in ms
> + *	  priv			Pointer to device private context struct
> + *	  ul_client	   Pointer to linux client
> + *	  sig_reply_id	ID of the expected reply (defined in sigs.h).
> + *	  timeout		 timeout in ms
>   *
>   * Returns:
> - *      0 on success, -ve POSIX code on error.
> + *	  0 on success, -ve POSIX code on error.
>   *
>   * Notes:
> - *      This function waits for a specific (sig_reply_id) signal from UniFi.
> - *      It also match the sequence number of the received (cfm) signal, with
> - *      the latest sequence number of the signal (req) we have sent.
> - *      These two number match be equal.
> - *      Should only be used for waiting xxx.cfm signals and only after
> - *      we have sent the matching xxx.req signal to UniFi.
> - *      If no response is received within the expected time (timeout), we assume
> - *      that the UniFi is busy and return an error.
> - *      If the wait is aborted by a kernel signal arriving, we stop waiting.
> - *      If a response from UniFi is not what we expected, we discard it and
> - *      wait again. This could be a response from an aborted request. If we
> - *      see several bad responses we assume we have lost synchronisation with
> - *      UniFi.
> + *	  This function waits for a specific (sig_reply_id) signal from UniFi.
> + *	  It also match the sequence number of the received (cfm) signal, with
> + *	  the latest sequence number of the signal (req) we have sent.
> + *	  These two number match be equal.
> + *	  Should only be used for waiting xxx.cfm signals and only after
> + *	  we have sent the matching xxx.req signal to UniFi.
> + *	  If no response is received within the expected time (timeout), we assume
> + *	  that the UniFi is busy and return an error.
> + *	  If the wait is aborted by a kernel signal arriving, we stop waiting.
> + *	  If a response from UniFi is not what we expected, we discard it and
> + *	  wait again. This could be a response from an aborted request. If we
> + *	  see several bad responses we assume we have lost synchronisation with
> + *	  UniFi.
>   * ---------------------------------------------------------------------------
>   */
>  static int
>  unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli, int sig_reply_id, int timeout)
>  {
> -    int retries = 0;
> -    long r;
> -    long t = timeout;
> -    unsigned int sent_seq_no;
> -
> -    /* Convert t in ms to jiffies */
> -    t = msecs_to_jiffies(t);
> -
> -    do {
> -        /* Wait for the confirm or timeout. */
> -        r = wait_event_interruptible_timeout(pcli->udi_wq,
> -                                             (pcli->wake_up_wq_id) || (priv->io_aborted == 1),
> -                                             t);
> -        /* Check for general i/o error */
> -        if (priv->io_aborted) {
> -            unifi_error(priv, "MLME operation aborted\n");
> -            return -EIO;
> -        }
> -
> -        /*
> -         * If r=0 the request has timed-out.
> -         * If r>0 the request has completed successfully.
> -         * If r=-ERESTARTSYS an event (kill signal) has interrupted the wait_event.
> -         */
> -        if ((r == 0) && (pcli->wake_up_wq_id == 0)) {
> -            unifi_error(priv, "mlme_wait: timed-out waiting for 0x%.4X, after %lu msec.\n",
> -                        sig_reply_id,  jiffies_to_msecs(t));
> -            pcli->wake_up_wq_id = 0;
> -            return -ETIMEDOUT;
> -        } else if (r == -ERESTARTSYS) {
> -            unifi_error(priv, "mlme_wait: waiting for 0x%.4X was aborted.\n", sig_reply_id);
> -            pcli->wake_up_wq_id = 0;
> -            return -EINTR;
> -        } else {
> -            /* Get the sequence number of the signal that we previously set. */
> -            if (pcli->seq_no != 0) {
> -                sent_seq_no = pcli->seq_no - 1;
> -            } else {
> -                sent_seq_no = 0x0F;
> -            }
> -
> -            unifi_trace(priv, UDBG5, "Received 0x%.4X, seq: (r:%d, s:%d)\n",
> -                        pcli->wake_up_wq_id,
> -                        pcli->wake_seq_no, sent_seq_no);
> -
> -            /* The two sequence ids must match. */
> -            if (pcli->wake_seq_no == sent_seq_no) {
> -                /* and the signal ids must match. */
> -                if (sig_reply_id == pcli->wake_up_wq_id) {
> -                    /* Found the expected signal */
> -                    break;
> -                } else {
> -                    /* This should never happen ... */
> -                    unifi_error(priv, "mlme_wait: mismatching signal id (0x%.4X - exp 0x%.4X) (seq %d)\n",
> -                                pcli->wake_up_wq_id,
> -                                sig_reply_id,
> -                                pcli->wake_seq_no);
> -                    pcli->wake_up_wq_id = 0;
> -                    return -EIO;
> -                }
> -            }
> -            /* Wait for the next signal. */
> -            pcli->wake_up_wq_id = 0;
> -
> -            retries ++;
> -            if (retries >= 3) {
> -                unifi_error(priv, "mlme_wait: confirm wait retries exhausted (0x%.4X - exp 0x%.4X)\n",
> -                            pcli->wake_up_wq_id,
> -                            sig_reply_id);
> -                pcli->wake_up_wq_id = 0;
> -                return -EIO;
> -            }
> -        }
> -    } while (1);
> -
> -    pcli->wake_up_wq_id = 0;
> -
> -    return 0;
> +	int retries = 0;
> +	long r;
> +	long t = timeout;
> +	unsigned int sent_seq_no;
> +
> +	/* Convert t in ms to jiffies */
> +	t = msecs_to_jiffies(t);
> +
> +	do {
> +		/* Wait for the confirm or timeout. */
> +		r = wait_event_interruptible_timeout(pcli->udi_wq,
> +											 (pcli->wake_up_wq_id) || (priv->io_aborted == 1),
> +											 t);

What happened there?

Please be smart about your cleanups, you have to do it by hand in
places.

Care to redo this series also and resend it?

thanks,

greg k-h
