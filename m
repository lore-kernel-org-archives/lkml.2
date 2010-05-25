Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab0EYUIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:08:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933433Ab0EYUIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:08:49 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=hc5N0AaGBeUA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=omOdbC7AAAAA:8 a=jNtqXs92S4I_OJGI7tMA:9 a=A5VyjzsPcmFf0R4eJ4oMcIMOND8A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] drm/i915: Convert more trace events to DEFINE_EVENT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Eric Anholt <eric@anholt.net>, airlied@linux.ie, chris@chris-wilson.co.uk,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
In-Reply-To: <4BFA3808.5080203@cn.fujitsu.com>
References: <4BFA3808.5080203@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 25 May 2010 16:08:46 -0400
Message-ID: <1274818126.22648.221.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 16:25 +0800, Li Zefan wrote:
> Convert i915_gem_object_clflush to DEFINE_EVENT, and save ~0.5K:
> 
>    text    data     bss     dec     hex filename
>   13204    2732      12   15948    3e4c i915_trace_points.o.orig
>   12668    2732      12   15412    3c34 i915_trace_points.o
> 
> No change in functionality.
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

I'm expecting that this will be going through the DRM/i915 path.

-- Steve

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  drivers/gpu/drm/i915/i915_trace.h |   24 +++++++-----------------
>  1 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
> index 9e4c45f..fab2176 100644
> --- a/drivers/gpu/drm/i915/i915_trace.h
> +++ b/drivers/gpu/drm/i915/i915_trace.h
> @@ -53,23 +53,6 @@ TRACE_EVENT(i915_gem_object_bind,
>  		      __entry->obj, __entry->gtt_offset)
>  );
>  
> -TRACE_EVENT(i915_gem_object_clflush,
> -
> -	    TP_PROTO(struct drm_gem_object *obj),
> -
> -	    TP_ARGS(obj),
> -
> -	    TP_STRUCT__entry(
> -			     __field(struct drm_gem_object *, obj)
> -			     ),
> -
> -	    TP_fast_assign(
> -			   __entry->obj = obj;
> -			   ),
> -
> -	    TP_printk("obj=%p", __entry->obj)
> -);
> -
>  TRACE_EVENT(i915_gem_object_change_domain,
>  
>  	    TP_PROTO(struct drm_gem_object *obj, uint32_t old_read_domains, uint32_t old_write_domain),
> @@ -132,6 +115,13 @@ DECLARE_EVENT_CLASS(i915_gem_object,
>  	    TP_printk("obj=%p", __entry->obj)
>  );
>  
> +DEFINE_EVENT(i915_gem_object, i915_gem_object_clflush,
> +
> +	    TP_PROTO(struct drm_gem_object *obj),
> +
> +	    TP_ARGS(obj)
> +);
> +
>  DEFINE_EVENT(i915_gem_object, i915_gem_object_unbind,
>  
>  	    TP_PROTO(struct drm_gem_object *obj),


