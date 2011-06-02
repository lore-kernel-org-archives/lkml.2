Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab1FBJbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:31:14 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:35867 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932439Ab1FBJbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:31:13 -0400
Date: Thu, 2 Jun 2011 11:30:26 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 11/12] vfs: increase shrinker batch size
Message-ID: <20110602113026.7291b1a7@absol.kitzblitz>
In-Reply-To: <1306998067-27659-12-git-send-email-david@fromorbit.com>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
 <1306998067-27659-12-git-send-email-david@fromorbit.com>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just noticed below two typos.

* Dave Chinner <david@fromorbit.com>:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the per-sb shrinker is responsible for shrinking 2 or more
> caches, increase the batch size to keep econmies of scale for

economies

(..)

>  Documentation/filesystems/vfs.txt |    5 +++++
>  fs/super.c                        |    1 +
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index dc732d2..2e26973 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -317,6 +317,11 @@ or bottom half).
>  	the VM is trying to reclaim under GFP_NOFS conditions, hence this
>  	method does not need to handle that situation itself.
>  
> +	Implementations must include conditional reschedule calls inside any
> +	scanning loop that is done. This allows the VFS to determine
> +	appropriate scan batch sizes without having to worry about whether
> +	implementations will cause holdoff problems due ot large batch sizes.

due to

Best regards,
Nicolas Kaiser
