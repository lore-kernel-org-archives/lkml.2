Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423579Ab2KOC1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:27:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423500Ab2KOC1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:27:40 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=yCdjX90S8KAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Wfdz3iwNL3EA:10 a=1XWaLZrsAAAA:8 a=TrYN-dBiYt-XusSz4tAA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352946459.18025.88.camel@gandalf.local.home>
Subject: Re: [PATCH 4/4] kernelshark: Full-height cursor and mark lines
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 14 Nov 2012 21:27:39 -0500
In-Reply-To: <1352944274-21699-4-git-send-email-dhsharp@google.com>
References: <1352944274-21699-1-git-send-email-dhsharp@google.com>
	 <1352944274-21699-4-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 17:51 -0800, David Sharp wrote:
> "width" and "height" were swapped, causing the vertical marker and cursor lines
> to be drawn with the wrong height.

Is this the fix to the strange "mark bottom stays around" bug? It's been
on my TODO list for a long time to fix that. ;-)

-- Steve

> 
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  trace-graph.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/trace-graph.c b/trace-graph.c
> index 6f72350..60e5241 100644
> --- a/trace-graph.c
> +++ b/trace-graph.c
> @@ -380,7 +380,7 @@ static void draw_cursor(struct graph_info *ginfo)
>  	x = convert_time_to_x(ginfo, ginfo->cursor);
>  
>  	gdk_draw_line(ginfo->draw->window, ginfo->draw->style->mid_gc[3],
> -		      x, 0, x, ginfo->draw->allocation.width);
> +		      x, 0, x, ginfo->draw->allocation.height);
>  }
>  
>  static void draw_marka(struct graph_info *ginfo)
> @@ -392,7 +392,7 @@ static void draw_marka(struct graph_info *ginfo)
>  
>  	x = convert_time_to_x(ginfo, ginfo->marka_time);
>  	gdk_draw_line(ginfo->draw->window, green,
> -		      x, 0, x, ginfo->draw->allocation.width);
> +		      x, 0, x, ginfo->draw->allocation.height);
>  }
>  
>  static void draw_markb(struct graph_info *ginfo)
> @@ -404,7 +404,7 @@ static void draw_markb(struct graph_info *ginfo)
>  
>  	x = convert_time_to_x(ginfo, ginfo->markb_time);
>  	gdk_draw_line(ginfo->draw->window, red,
> -		      x, 0, x, ginfo->draw->allocation.width);
> +		      x, 0, x, ginfo->draw->allocation.height);
>  }
>  
>  static void update_with_backend(struct graph_info *ginfo,
> @@ -434,7 +434,7 @@ static void
>  draw_line(GtkWidget *widget, gdouble x, struct graph_info *ginfo)
>  {
>  	gdk_draw_line(widget->window, widget->style->black_gc,
> -		      x, 0, x, widget->allocation.width);
> +		      x, 0, x, widget->allocation.height);
>  }
>  
>  static void clear_line(struct graph_info *ginfo, gint x)


