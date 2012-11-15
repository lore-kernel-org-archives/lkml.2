Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768861Ab2KOTz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:55:27 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:55468 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768746Ab2KOTzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:55:25 -0500
MIME-Version: 1.0
In-Reply-To: <1352946459.18025.88.camel@gandalf.local.home>
References: <1352944274-21699-1-git-send-email-dhsharp@google.com>
 <1352944274-21699-4-git-send-email-dhsharp@google.com> <1352946459.18025.88.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Thu, 15 Nov 2012 11:55:04 -0800
Message-ID: <CAJL_ekt_D3h_5LbnmCrD_s3F3G8PRP3YenVO0WBnhw+GYwZTew@mail.gmail.com>
Subject: Re: [PATCH 4/4] kernelshark: Full-height cursor and mark lines
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 6:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-11-14 at 17:51 -0800, David Sharp wrote:
>> "width" and "height" were swapped, causing the vertical marker and cursor lines
>> to be drawn with the wrong height.
>
> Is this the fix to the strange "mark bottom stays around" bug? It's been
> on my TODO list for a long time to fix that. ;-)

That's not how I would have described the bug, but maybe it's the
same. What I was seeing was the marks not extending all the way to the
bottom of all the plot area when scrolled down. I assume it would only
manifest that way when the plot is taller than it is wide (eg, tons of
thread plots and fully zoomed out). In the reverse situation, it would
be telling gdk to draw outside the bounds of the widget, which might
do something weird, although I would hope it would just draw what it
could and refuse to draw outside.

>
> -- Steve
>
>>
>> Signed-off-by: David Sharp <dhsharp@google.com>
>> ---
>>  trace-graph.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/trace-graph.c b/trace-graph.c
>> index 6f72350..60e5241 100644
>> --- a/trace-graph.c
>> +++ b/trace-graph.c
>> @@ -380,7 +380,7 @@ static void draw_cursor(struct graph_info *ginfo)
>>       x = convert_time_to_x(ginfo, ginfo->cursor);
>>
>>       gdk_draw_line(ginfo->draw->window, ginfo->draw->style->mid_gc[3],
>> -                   x, 0, x, ginfo->draw->allocation.width);
>> +                   x, 0, x, ginfo->draw->allocation.height);
>>  }
>>
>>  static void draw_marka(struct graph_info *ginfo)
>> @@ -392,7 +392,7 @@ static void draw_marka(struct graph_info *ginfo)
>>
>>       x = convert_time_to_x(ginfo, ginfo->marka_time);
>>       gdk_draw_line(ginfo->draw->window, green,
>> -                   x, 0, x, ginfo->draw->allocation.width);
>> +                   x, 0, x, ginfo->draw->allocation.height);
>>  }
>>
>>  static void draw_markb(struct graph_info *ginfo)
>> @@ -404,7 +404,7 @@ static void draw_markb(struct graph_info *ginfo)
>>
>>       x = convert_time_to_x(ginfo, ginfo->markb_time);
>>       gdk_draw_line(ginfo->draw->window, red,
>> -                   x, 0, x, ginfo->draw->allocation.width);
>> +                   x, 0, x, ginfo->draw->allocation.height);
>>  }
>>
>>  static void update_with_backend(struct graph_info *ginfo,
>> @@ -434,7 +434,7 @@ static void
>>  draw_line(GtkWidget *widget, gdouble x, struct graph_info *ginfo)
>>  {
>>       gdk_draw_line(widget->window, widget->style->black_gc,
>> -                   x, 0, x, widget->allocation.width);
>> +                   x, 0, x, widget->allocation.height);
>>  }
>>
>>  static void clear_line(struct graph_info *ginfo, gint x)
>
>
