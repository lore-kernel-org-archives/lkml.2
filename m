Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1LDLuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 06:50:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44569 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1LDLuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 06:50:13 -0500
Message-ID: <4EDB5E70.5000209@googlemail.com>
Date: Sun, 04 Dec 2011 11:50:08 +0000
From: Alan Jenkins <alan.christopher.jenkins@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Daniel Drake <dsd@laptop.org>
CC: x86@kernel.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        dilinger@queued.net, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: Re: [PATCH resend 2] x86, olpc-xo15-sci: Enable lid close wakeup
 control through sysfs
References: <20111129222447.E56959D401E@zog.reactivated.net> <20111130151551.97371bdb.akpm@linux-foundation.org>
In-Reply-To: <20111130151551.97371bdb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/-10/37 20:59, Andrew Morton wrote:
> Let me fix that for you.
>
> --- a/arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix
> +++ a/arch/x86/platform/olpc/olpc-xo15-sci.c
> @@ -58,7 +58,8 @@ static ssize_t lid_wake_on_close_store(s
>   				       const char *buf, size_t n)
>   {
>   	unsigned int val;
> -	if (!sscanf(buf, "%u",&val) == 1)
> +
> +	if (sscanf(buf, "%u",&val) != 1)
>   		return -EINVAL;
>
>   	set_lid_wake_behavior(!!val);
>
> It's kinda irritating that this will cheerfully accept bogus input of
> the form "42foo".  This happens about eleven billion times in sysfs
> write() handlers but afaik we've never implemented a nice
> sysfs_int_from_buffer() thingy which handles all the possible errors.

I thought there was.

strict_strtoul() ?

Alan
