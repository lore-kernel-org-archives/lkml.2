Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1BWKLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:11:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1BWKLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:11:52 -0500
Subject: Re: [PATCH] jump label: introduce static_branch() interface
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: hpa@zytor.com, mathieu.desnoyers@polymtl.ca, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
References: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 11:11:25 +0100
Message-ID: <1298455885.2217.354.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 17:28 -0500, Jason Baron wrote:
> @@ -33,7 +28,11 @@ struct _ddebug {
>  #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using
> the format */
>  #define _DPRINTK_FLAGS_DEFAULT 0
>         unsigned int flags:8;
> -       char enabled;
> +#ifdef HAVE_JUMP_LABEL
> +       struct jump_label_key enabled;
> +#else
> +       int enabled;
> +#endif
>  } __attribute__((aligned(8)));
>   

Also, didn't you promise Mathieu a comment explaining why dynamic debug
does funny things like this? :-) I mean we all know its because of the
cyclic header stuff involving atomic etc.. but I'm also quite sure we'll
all have forgotten about that in a few weeks time.
