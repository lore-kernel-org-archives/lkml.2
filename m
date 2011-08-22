Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab1HVPvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:51:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65052 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1HVPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:51:05 -0400
Subject: Re: [PATCH] perf, tool, record: Fix the header generation for pipe
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110822145210.GA8694@jolsa.brq.redhat.com>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
	 <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110822145210.GA8694@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Aug 2011 17:51:06 +0200
Message-ID: <1314028266.2307.93.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 22 août 2011 à 16:52 +0200, Jiri Olsa a écrit :

> - fd is always file.. the descriptor, which might be pipe, is in output_fd variable
>   but, maybe the die call is not necessary.. this should not fail
> 
> - the record_file function is called only on debugfs or procfs files:
> 	events/header_page
> 	events/header_event
> 	events/**/format
> 	printk_formats
> 	/proc/kallsyms
> 
> so I think I need to read the whole file as in current code.
> 

You read the file twice. Is it the right fix ?

Once to compute the length to be able to write the output header, once
to process the content.

Are you sure length cannot change between the two phases ?

/proc/kallsyms can definitely change when a module is loaded.

Usually, when input "file" is not seekable or procfs based (fstat()
returns st_size=0), we must load/cache it in memory (or using a
temporary file) to get a consistent view of it.

This is what is done by following commands :

cat /proc/kallsyms | less
less /proc/kallsyms



