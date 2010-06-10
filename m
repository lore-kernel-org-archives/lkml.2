Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab0FJMoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:44:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab0FJMoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:44:01 -0400
Subject: Re: [PATCH 10/13] jump label v9: convert jump label to use a key
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
In-Reply-To: <2a7e0be296375cf6658647c8a9c6cb208d875ac8.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
	 <2a7e0be296375cf6658647c8a9c6cb208d875ac8.1276116186.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 14:43:46 +0200
Message-ID: <1276173826.2077.252.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> -static inline int enable_jump_label(const char *name)
> -{
> -       return 0;
> -}
> -
> -static inline int disable_jump_label(const char *name)
> -{
> -       return 0;
> -}
> +#define enable_jump_label(key)
> +#define disable_jump_label(key) 

I would expect enable_jump_label() to look something like:

#define enable_jump_label(cond_var)	\
do {					\
	*(cond_var) = 1;		\
} while (0)

That way the HAVE_JUMP_LABEL and !HAVE_JUMP_LABEL code has similar
effects.
