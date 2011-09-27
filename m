Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1I0ScZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:32:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35536 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab1I0ScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:32:24 -0400
Date: Tue, 27 Sep 2011 19:32:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Wilson <wilsons@start.ca>, linux-kernel@vger.kernel.org
Subject: Re: Q: x86: add context tag to mark mm when running a task in 32-bit
 compatibility mode
Message-ID: <20110927183219.GL2203@ZenIV.linux.org.uk>
References: <20110927170448.GA15977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927170448.GA15977@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 07:04:48PM +0200, Oleg Nesterov wrote:
> --- x/arch/x86/kernel/process_64.c
> +++ x/arch/x86/kernel/process_64.c
> @@ -502,10 +502,6 @@ void set_personality_64bit(void)
>  	/* Make sure to be in 64bit mode */
>  	clear_thread_flag(TIF_IA32);
>  
> -	/* Ensure the corresponding mm is not marked. */
> -	if (current->mm)
> -		current->mm->context.ia32_compat = 0;

What happens when 32bit task does exec on 64bit binary?

> -	if (current->mm)
> -		current->mm->context.ia32_compat = 1;
> +	set_bit(MMF_COMPAT, &current->mm->flags);

... assuming current->mm is never NULL here.
