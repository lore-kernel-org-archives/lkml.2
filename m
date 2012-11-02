Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2KBAgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:36:31 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63367 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2KBAg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:36:26 -0400
MIME-Version: 1.0
In-Reply-To: <20121031003314.763160265@goodmis.org>
References: <20121031003258.811955127@goodmis.org>
	<20121031003314.763160265@goodmis.org>
Date: Thu, 1 Nov 2012 17:36:25 -0700
X-Google-Sender-Auth: iDbNnK7slPeeoCNGOEboWyMOm4E
Message-ID: <CAN8Q1EcHJyDMs-z8Vw_=cpnCL2FO_pATaGThh2UHv4ketC-_Jw@mail.gmail.com>
Subject: Re: [PATCH RT 3/4] net: netfilter: Serialize xt_write_recseq sections
 on RT
From: Peter LaDow <petela@gocougs.wsu.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 5:33 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> The netfilter code relies only on the implicit semantics of
> local_bh_disable() for serializing wt_write_recseq sections. RT breaks
> that and needs explicit serialization here.
>
> Reported-by: Peter LaDow <petela@gocougs.wsu.edu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

> diff --git a/include/linux/locallock.h b/include/linux/locallock.h
> index f1804a3..a5eea5d 100644

> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index 32cddf7..bed90da2 100644

> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 899b71c..5db16ea 100644

I'm have a setup running 3.0.48-rt72.  It's been running about 8 hours
so far, and tomorrow I'll know if there's been any problems.  I'm
confident things will be fine tomorrow, and at that time I'll be glad
to attach a Tested-by tag.

Thanks,
Pete
