Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab2BJPgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:36:09 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53732 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845Ab2BJPgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:36:07 -0500
X-Sasl-enc: MOoVpK1ZLiQ8A5cxHauoJftHbErJ1XKDggtHZWYWxmcm 1328888166
Message-ID: <4F353964.1000405@fastmail.fm>
Date: Fri, 10 Feb 2012 15:36:04 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        dzickus@redhat.com, vgoyal@redhat.com, seiji.aguchi@hds.com
Subject: Re: [PATCH] kmsg_dump: Don't run on non-error paths by default
References: <1328886693-20670-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1328886693-20670-1-git-send-email-mjg@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/12 15:11, Matthew Garrett wrote:
> +/*
> + * Keep this list arranged in rough order of priority. Anything listed after
> + * KMSG_DUMP_OOPS will not be logged by default unless printk.always_kmsg_dump
> + * is passed to the kernel.
> + */
>  enum kmsg_dump_reason {
> -	KMSG_DUMP_OOPS,
>  	KMSG_DUMP_PANIC,
> +	KMSG_DUMP_OOPS,
> +	KMSG_DUMP_EMERG,
>  	KMSG_DUMP_RESTART,
>  	KMSG_DUMP_HALT,
>  	KMSG_DUMP_POWEROFF,
> -	KMSG_DUMP_EMERG,
>  };

...

> +	if (reason > KMSG_DUMP_PANIC && !always_kmsg_dump)
> +		return;
> +

Did you mean KMSG_DUMP_OOPS here?
