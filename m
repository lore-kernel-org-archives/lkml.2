Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2DWJfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:35:44 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:43059 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab2DWJfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:35:43 -0400
Message-ID: <1335173738.4777.1.camel@odin>
Subject: Re: linux-next: build warnings after merge of the sound-asoc tree
From: Liam Girdwood <lrg@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Apr 2012 10:35:38 +0100
In-Reply-To: <20120420142850.b276b5fa80e857f8c997e99b@canb.auug.org.au>
References: <20120420142850.b276b5fa80e857f8c997e99b@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 14:28 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
> 
> In file included from include/trace/ftrace.h:567:0,
>                  from include/trace/define_trace.h:86,
>                  from include/trace/events/asoc.h:410,
>                  from sound/soc/soc-core.c:45:
> include/trace/events/asoc.h: In function 'ftrace_raw_event_snd_soc_dapm_output_path':
> include/trace/events/asoc.h:246:1: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> include/trace/events/asoc.h: In function 'ftrace_raw_event_snd_soc_dapm_input_path':
> include/trace/events/asoc.h:275:1: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Following fix sent to alsa-devel.

diff --git a/include/trace/events/asoc.h b/include/trace/events/asoc.h
index 6d8efb1..5fc2dcd 100644
--- a/include/trace/events/asoc.h
+++ b/include/trace/events/asoc.h
@@ -263,7 +263,7 @@ TRACE_EVENT(snd_soc_dapm_output_path,
 		__assign_str(pname, path->name ? path->name : DAPM_DIRECT);
 		__assign_str(psname, path->sink->name);
 		__entry->path_connect = path->connect;
-		__entry->path_sink = (int)path->sink;
+		__entry->path_sink = (long)path->sink;
 	),
 
 	TP_printk("%c%s -> %s -> %s\n",
@@ -292,7 +292,7 @@ TRACE_EVENT(snd_soc_dapm_input_path,
 		__assign_str(pname, path->name ? path->name : DAPM_DIRECT);
 		__assign_str(psname, path->source->name);
 		__entry->path_connect = path->connect;
-		__entry->path_source = (int)path->source;
+		__entry->path_source = (long)path->source;
 	),
 
 	TP_printk("%c%s <- %s <- %s\n",
-- 
1.7.5.4


