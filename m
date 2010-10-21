Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab0JUMGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:06:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51383 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab0JUMGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:06:18 -0400
Message-ID: <4CC02CDF.5040700@cn.fujitsu.com>
Date: Thu, 21 Oct 2010 20:06:55 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nicolas Kaiser <nikai@nikai.net>
CC: Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: remove redundant chunk length check
References: <20101021121409.6de7d429@absol.kitzblitz>
In-Reply-To: <20101021121409.6de7d429@absol.kitzblitz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Kaiser wrote, at 10/21/2010 06:14 PM:
> Checking the chunk length at this point appears redundant, as
> the rest of the packet gets discarded anyway.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Yes, indeed.

How did you find this? By reviewing the source code?

-- 
Best Regards
-----
Shan Wei

> ---
>  net/sctp/sm_statefuns.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 4b4eb7c..9840615 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -3418,12 +3418,6 @@ static sctp_disposition_t sctp_sf_shut_8_4_5(const struct sctp_endpoint *ep,
>  
>  		SCTP_INC_STATS(SCTP_MIB_OUTCTRLCHUNKS);
>  
> -		/* If the chunk length is invalid, we don't want to process
> -		 * the reset of the packet.
> -		 */
> -		if (!sctp_chunk_length_valid(chunk, sizeof(sctp_chunkhdr_t)))
> -			return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
> -
>  		/* We need to discard the rest of the packet to prevent
>  		 * potential bomming attacks from additional bundled chunks.
>  		 * This is documented in SCTP Threats ID.


