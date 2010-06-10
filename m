Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091Ab0FJMPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:15:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905Ab0FJMPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:15:50 -0400
Subject: Re: [PATCH 03/13] jump label v9: x86 support
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
In-Reply-To: <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
	 <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 14:15:31 +0200
Message-ID: <1276172131.2077.205.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> +#define JUMP_LABEL(tag, label, cond)                           \
> +       do {                                                    \
> +               extern const char __jlstrtab_##tag[];           \
> +               asm goto("1:"                                   \
> +                       JUMP_LABEL_NOP                          \
> +                       ".pushsection __jump_table,  \"a\" \n\t"\
> +                       _ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
> +                       ".popsection \n\t"                      \
> +                       : :  "i" (__jlstrtab_##tag) :  : label);\
> +       } while (0) 

Would it make sense to have that macro at least evaluate cond in some
way?
