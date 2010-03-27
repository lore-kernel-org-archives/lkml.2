Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0C0DO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 23:14:59 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49407 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0C0DO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 23:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WtCRMoUmU5YYylZjLwzwh4zvtvzCajHcGTPPDIpr+qbNAGHIYO2KhkNksUVYWZU5+S
         IeFiVJZekHqaxK87YvQCZXNj/liPrcU3OA9/5X4szIpmJYxo7OwL10IiRYvqaQ3OMMIb
         KWHwIY6EUbkxo88y7OPl8F1HvBLK3ZS8Z0sQM=
Date: Sat, 27 Mar 2010 04:14:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: Re: [RFC PATCH 2/7] perf: add pipe-specific header read/write and
	event processing code
Message-ID: <20100327031455.GN7166@nowhere>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com> <1267599929-8310-3-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267599929-8310-3-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 01:05:24AM -0600, Tom Zanussi wrote:
>  
> +int perf_header__write_pipe(struct perf_header *self, int fd)
> +{
> +	struct perf_file_header_pipe f_header;
> +	int err;
> +
> +	f_header = (struct perf_file_header_pipe){
> +		.magic	   = PERF_MAGIC,
> +		.size	   = sizeof(f_header),
> +	};
> +
> +	err = do_write(fd, &f_header, sizeof(f_header));
> +	if (err < 0) {
> +		pr_debug("failed to write perf pipe header\n");
> +		return err;
> +	}
> +
> +	self->frozen = 1;
> +	return 0;
> +}



I actually wonder why you bother with a header in the pipe mode,
since it only contains MAGIC and its size.

