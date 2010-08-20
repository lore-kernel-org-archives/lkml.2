Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0HTM70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:59:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48658 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0HTM7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:59:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C6E7C1A.1070203@s5r6.in-berlin.de>
Date: Fri, 20 Aug 2010 14:59:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/19] Add ioctl() argument and attribute handling utils
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-7-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-7-git-send-email-mitr@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miloslav Trmač wrote:
> --- /dev/null
> +++ b/crypto/userspace/utils.c
[...]
> +#ifdef CONFIG_COMPAT
> +/* max() is too clever for compile-time constants */
> +#define CONST_MAX(A, B) ((A) > (B) ? (A) : (B))
> +
> +#define MAX_SESSION_INPUT_DATA_SIZE					\
> +	(CONST_MAX(sizeof(struct ncr_session_input_data),		\
> +		   sizeof(struct compat_ncr_session_input_data)))
> +#define MAX_SESSION_OUTPUT_BUFFER_SIZE					\
> +	(CONST_MAX(sizeof(struct ncr_session_output_buffer),		\
> +		   sizeof(struct compat_ncr_session_output_buffer)))
> +
> +#else /* !CONFIG_COMPAT */
> +
> +#define MAX_SESSION_INPUT_DATA_SIZE (sizeof(struct ncr_session_input_data))
> +#define MAX_SESSION_OUTPUT_BUFFER_SIZE			\
> +	(sizeof(struct ncr_session_output_buffer))
> +
> +#endif /* !CONFIG_COMPAT */

struct compat_xyz cannot be bigger than struct xyz, can it?
-- 
Stefan Richter
-=====-==-=- =--- =-=--
http://arcgraph.de/sr/
