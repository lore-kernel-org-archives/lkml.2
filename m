Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1AERIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:08:04 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:45188 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1AERIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:08:02 -0500
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Subject: Re: [V9fs-developer] [PATCH] net/9p: Use proper data types
Date: Wed, 5 Jan 2011 22:37:42 +0530
User-Agent: KMail/1.13.5 (Linux/2.6.35.10-74.fc14.i686.PAE; KDE/4.5.4; i686; ; )
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1294246423-8454-1-git-send-email-mohan@in.ibm.com>
In-Reply-To: <1294246423-8454-1-git-send-email-mohan@in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101052237.42802.mohan@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 33551d7be66cec324c47990ed526b7fe327b011f net/9p/protocol.c: Remove 
duplicated macros from Thiago Farina <tfransosi@gmail.com> exposed this issue


On Wednesday 05 January 2011 10:23:43 pm M. Mohan Kumar wrote:
> Use proper data types for storing the count of the binary blob and
> length of a string. Without this patch length calculation of string will
> always result in -1 because of comparision between signed and unsigned
> integer.
> 
> Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
> ---
>  net/9p/protocol.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/9p/protocol.c b/net/9p/protocol.c
> index c5180fd..2902eb1 100644
> --- a/net/9p/protocol.c
> +++ b/net/9p/protocol.c
> @@ -234,14 +234,14 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version,
> const char *fmt, }
>  			break;
>  		case 'D':{
> -				int32_t *count = va_arg(ap, int32_t *);
> +				uint32_t *count = va_arg(ap, int32_t *);
>  				void **data = va_arg(ap, void **);
> 
>  				errcode =
>  				    p9pdu_readf(pdu, proto_version, "d", count);
>  				if (!errcode) {
>  					*count =
> -					    min_t(int32_t, *count,
> +					    min_t(uint32_t, *count,
>  						  pdu->size - pdu->offset);
>  					*data = &pdu->sdata[pdu->offset];
>  				}
> @@ -404,9 +404,9 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version,
> const char *fmt, break;
>  		case 's':{
>  				const char *sptr = va_arg(ap, const char *);
> -				int16_t len = 0;
> +				uint16_t len = 0;
>  				if (sptr)
> -					len = min_t(int16_t, strlen(sptr),
> +					len = min_t(uint16_t, strlen(sptr),
>  								USHRT_MAX);
> 
>  				errcode = p9pdu_writef(pdu, proto_version,

----
M. Mohan Kumar
