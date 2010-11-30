Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0K3WYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:24:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0K3WYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:24:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Charles Manning <cdhmanning@gmail.com>
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
Date: Tue, 30 Nov 2010 23:23:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <1291154254-22533-4-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1291154254-22533-4-git-send-email-cdhmanning@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011302323.53313.arnd@arndb.de>
X-Provags-ID: V02:K0:nT4YiPThKAhhzibfYLMyxDAVUq5tiEu/3PY4zGO0ZPg
 y05Mgg+e7TDqtEFPD7QhygUybWS2bxKw6xt3nAL7DWo6ZSQE5Q
 hu+ylQtqEzAFkgsqi/MnAde7ViuyrgUlTJ/gHS3PtK6Tc1dkXN
 E0LpnyabDQ7mDxsj8mHpK+CGl3NO+HuvLqYAufUYlndsfwPXpC
 67CGMuxGJC6wTZAhIRLZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 November 2010 22:57:29 Charles Manning wrote:

I think I made these comments before, not sure what happened to them...

> +
> +/* Robustification (if it ever comes about...) */
> +static void yaffs_retire_block(struct yaffs_dev *dev, int flash_block);
> +static void yaffs_handle_chunk_wr_error(struct yaffs_dev *dev, int nand_chunk,
> +					int erased_ok);
> +static void yaffs_handle_chunk_wr_ok(struct yaffs_dev *dev, int nand_chunk,
> +				     const u8 * data,
> +				     const struct yaffs_ext_tags *tags);
> +static void yaffs_handle_chunk_update(struct yaffs_dev *dev, int nand_chunk,
> +				      const struct yaffs_ext_tags *tags);

It would be better to reorder the functions in each file so that
you don't need forward declarations. This generally makes reading
the code easier because it is what people expect to see. It
also makes it clearer where you have possible recursions in the code.

> +
> +	T(YAFFS_TRACE_BUFFERS,
> +	  (TSTR("Out of temp buffers at line %d, other held by lines:"),
> +	   line_no));
> +	for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> +		T(YAFFS_TRACE_BUFFERS,
> +		  (TSTR(" %d "), dev->temp_buffer[i].line));
> +
> +	T(YAFFS_TRACE_BUFFERS, (TSTR(" " TENDSTR)));

The tracing functions are rather obscure. I would recommend dropping
them all for now, in order to get the code included. At a later
stage, you can add standard trace points.

> +	return YMALLOC(dev->data_bytes_per_chunk);

In general, don't wrap standard kernel API functions with your
own abstractions, just use kmalloc here for instance.

It is rather annoying when you want to understand code and it
calls nonstandard functions that do almost the same that the
standard API does.

If you find something lacking in the existing API, feel free
to make suggestions for improving it. Either it is a good idea
and everyone will be happy about the useful new interface,
or it is a bad idea and you shouldn't be using it in the first
place.

	Arnd
