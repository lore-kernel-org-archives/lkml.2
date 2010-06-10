Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab0FJMHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:07:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:56608 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab0FJMHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:07:16 -0400
Subject: Re: [PATCH 02/13] jump label v9: base patch
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
In-Reply-To: <ba56ef382c3b1a1d17a21005d5c4eda54cced0bf.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
	 <ba56ef382c3b1a1d17a21005d5c4eda54cced0bf.1276116186.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 14:06:53 +0200
Message-ID: <1276171613.2077.194.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 17:38 -0400, Jason Baron wrote:
> +static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
> +{
> +       int swapped = 0;
> +       struct jump_entry *iter;
> +       struct jump_entry *iter_next;
> +
> +       do {
> +               swapped = 0;
> +               iter = start;
> +               iter_next = start;
> +               iter_next++;
> +               for (; iter_next < stop; iter++, iter_next++) {
> +                       if (strcmp((char *)iter->name,
> +                                               (char *)iter_next->name) > 0) {
> +                               swap_jump_label_entries(iter, iter_next);
> +                               swapped = 1;
> +                       }
> +               }
> +       } while (swapped == 1);
> +} 

Would lib/sort.c be of any help?
