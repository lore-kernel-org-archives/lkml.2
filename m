Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0HTMtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:49:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48606 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HTMtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:49:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C6E79B2.1040309@s5r6.in-berlin.de>
Date: Fri, 20 Aug 2010 14:48:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] User-space API definition
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-2-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-2-git-send-email-mitr@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miloslav Trmač wrote:
> --- /dev/null
> +++ b/include/linux/ncr.h
[...]
> +struct ncr_session_input_data {
> +	const void __user *data;
> +	__kernel_size_t data_size;
> +};
> +
> +struct ncr_session_output_buffer {
> +	void __user *buffer;
> +	__kernel_size_t buffer_size;
> +	__kernel_size_t __user *result_size_ptr;
> +};

Why not using fixed-size fit-all members?

struct ncr_session_input_data {
	__u64 data;		/* user pointer, cast to/from u64 */
	__u32 data_size;	/* or __u64? */
};

struct ncr_session_output_buffer {
	__u64 buffer;
	__u64 result_size_ptr;	/* can't this be a direct output member? */
	__u32 buffer_size;	/* or __u64? */
};

And then get rid of all the COMAPT code paths.
-- 
Stefan Richter
-=====-==-=- =--- =-=--
http://arcgraph.de/sr/
