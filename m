Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0HWQTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:19:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:46774 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0HWQTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:19:16 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 4/4] fanotify: drops the packed attribute from userspace event metadata
Date: Mon, 23 Aug 2010 18:13:39 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
References: <1282523830-27751-1-git-send-email-eparis@redhat.com> <1282523830-27751-3-git-send-email-eparis@redhat.com> <1282523830-27751-4-git-send-email-eparis@redhat.com>
In-Reply-To: <1282523830-27751-4-git-send-email-eparis@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008231813.39759.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 August 2010 02:37:10 Eric Paris wrote:
>  #define FANOTIFY_METADATA_VERSION	1

FANOTIFY_METADATA_VERSION should be incremented, too.

>  struct fanotify_event_metadata {
>  	__u32 event_len;
>  	__u32 vers;
>  	__u64 mask;

We don't actually care if there are any holes in this structure; all we
care about is that the structure has the same alignment on 32-bit and
64-bit architectures.

Using type aligned_u64 here instead of __u64 will do the trick.

> +#ifdef __KERNEL__
> +/* see struct fanotify_event_metadata for the reason this exists */
> +struct fan_event_meta_packed {
> +	__u32 event_len;
> +	__u32 vers;
> +	__u64 mask;
> +	__s32 fd;
> +	__s32 pid;
> +} __attribute__ ((packed));

This does not add much value; the two structures can still go out of sync
A note to be careful about changes to struct fanotify_event_metadata
should really be warning enough.

Andreas
