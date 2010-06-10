Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723Ab0FJXqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:46:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab0FJXqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:46:45 -0400
Date: Thu, 10 Jun 2010 16:46:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add HW_ERR printk prefix for hardware error logging
Message-Id: <20100610164607.b2908334.akpm@linux-foundation.org>
In-Reply-To: <1275978938.3444.667.camel@yhuang-dev.sh.intel.com>
References: <1275978938.3444.667.camel@yhuang-dev.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jun 2010 14:35:38 +0800
Huang Ying <ying.huang@intel.com> wrote:

> This makes hardware error related log in printk log more explicit. So
> that the users can report it to hardware vendor instead of LKML or
> software vendor.
> 

Spose so.  Some additional words explaining why you think this would
result in an improved kernel would help here.  Are you seeing
misdirected problem reports?  Are we missing out on opportunities to
fix hardware?  What is driving for this change?  Will it bring out some
improvement in something which you're seeing within Intel or was it
just a random hey-lets-try-this thing?

The kernel's whole approach to messaging is pretty haphazard and lame
and sad.  There have been various proposals to improve the usefulness
and to rationally categorise things in way which are more useful to
operators, but nothing seems to ever get over the line.

> ---
>  include/linux/kernel.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 8317ec4..3bf740b 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -247,6 +247,13 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
>  #define FW_WARN		"[Firmware Warn]: "
>  #define FW_INFO		"[Firmware Info]: "
>  
> +/*
> + * HW_ERR
> + * Add this to a message for hardware errors, so that user can report
> + * it to hardware vendor instead of LKML or software vendor.
> + */
> +#define HW_ERR		"[Hardware Error]: "

I'm trying to think of a rational reason for capitalising "Error", and
failing.

Oh well, that's what the other strings do and the kernel already stands
as a punctuation/grammar how-not-to guide. ho hum.
