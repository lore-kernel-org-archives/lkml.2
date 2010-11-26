Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0KZKL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:11:59 -0500
Received: from mx2.sophos.com ([195.166.81.53]:60261 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab0KZKL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:11:57 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Subject: Re: [PATCH 4/4] fanotify: Expose the file changes to the user
Date: Fri, 26 Nov 2010 10:11:54 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3; KDE/4.5.3; x86_64; ; )
CC: Eric Paris <eparis@redhat.com>, Scott Hassan <hassan@dotfunk.com>,
        Jan Kara <jack@suse.cz>, "agruen@linbit.com" <agruen@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20101122002747.13674.69384.stgit@zaytsev.su> <20101122003357.13674.30341.stgit@zaytsev.su>
In-Reply-To: <20101122003357.13674.30341.stgit@zaytsev.su>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201011261011.55266.tvrtko.ursulin@sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 Nov 2010 00:37:21 Alexey Zaytsev wrote:
> +struct fanotify_opt_hdr {
> +       __u8 type;
> +       __u8 reserved;
> +       __u16 len;
> +       /* Payload goes here. */
> +};
> +
> +#define FANOTIFY_METADATA_VERSION      3
>
>  struct fanotify_event_metadata {
> -       __u16 event_len;
> +       __u16 event_len; /* Including the options */
>         __u8 vers;
> -       __u8 reserved;
> +       __u8 options_offset; /* Aka header length */
>         __s32 fd;
>         __aligned_u64 mask;
>         __s32 pid;
> +       /* Options go here. */
>  };

I am not 100% comfortable with having 16 bits length fields because I am just
not sure there is a measurable performance difference versus just going with
32 bits.

Also, options_offset is, if I understood it correctly, basically the lenght of
fanotify_event_metadata. As such, isn't that field redundant since the lenght
is implied from the protocol version?

For which it follows that maybe no changes to fanotify_event_metadata are
needed to grow the protocol in the future. We have the version and total
lenght. All that is required is that we never change width and position of
version and lenght field and we should be fine. Later we can define option
structures each of which will "point" to the next and thats it, no?

Tvrtko

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.
