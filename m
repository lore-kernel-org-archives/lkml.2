Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab0FJMWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:22:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0FJMWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:22:46 -0400
Subject: Re: [PATCH 04/13] jump label v9: tracepoint support
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
In-Reply-To: <bbfb88524578de36c3167941948a525a8424d870.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
	 <bbfb88524578de36c3167941948a525a8424d870.1276116186.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 14:22:31 +0200
Message-ID: <1276172551.2077.216.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> +               JUMP_LABEL(&__tracepoint_##name, do_trace, __tracepoint_##name.state);\


> +#define JUMP_LABEL(tag, label, cond)                           \
> +       do {                                                    \
> +               extern const char __jlstrtab_##tag[];           \


So that results in:

 extern const char __jlstrtab_&__tracepoint_FOO[]; ?
