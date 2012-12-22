Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2LVERd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:17:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2LVERc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:17:32 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-GlUy2-qm20A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=BQHvJmDDzFQA:10 a=IQek-EcBAAAA:8 a=js1SdzAvwm9XtGChb_4A:9 a=PUjeQqilurYA:10 a=mp5XFF02ptoA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356149848.5896.124.camel@gandalf.local.home>
Subject: Re: [PATCHv4 3/8] gpu: host1x: Add channel support
From: Steven Rostedt <rostedt@goodmis.org>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: thierry.reding@avionic-design.de, airlied@linux.ie, dev@lynxeye.de,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Dec 2012 23:17:28 -0500
In-Reply-To: <1356089964-5265-4-git-send-email-tbergstrom@nvidia.com>
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
	 <1356089964-5265-4-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 13:39 +0200, Terje Bergstrom wrote:

> diff --git a/include/trace/events/host1x.h b/include/trace/events/host1x.h
> index d98d74c..e087910 100644
> --- a/include/trace/events/host1x.h
> +++ b/include/trace/events/host1x.h
> @@ -37,6 +37,214 @@ DECLARE_EVENT_CLASS(host1x,
>  	TP_printk("name=%s", __entry->name)
>  );
>  
> +DEFINE_EVENT(host1x, host1x_channel_open,
> +	TP_PROTO(const char *name),
> +	TP_ARGS(name)
> +);
> +
> +DEFINE_EVENT(host1x, host1x_channel_release,
> +	TP_PROTO(const char *name),
> +	TP_ARGS(name)
> +);
> +
> +TRACE_EVENT(host1x_cdma_begin,
> +	TP_PROTO(const char *name),
> +
> +	TP_ARGS(name),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = name;
> +	),
> +
> +	TP_printk("name=%s",
> +		__entry->name)
> +);
> +
> +TRACE_EVENT(host1x_cdma_end,
> +	TP_PROTO(const char *name),
> +
> +	TP_ARGS(name),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = name;
> +	),
> +
> +	TP_printk("name=%s",
> +		__entry->name)
> +);

The above two should be combined into a DECLARE_EVENT_CLASS() and
DEFINE_EVENT()s. Saves text and data space that way.

> +
> +TRACE_EVENT(host1x_cdma_flush,
> +	TP_PROTO(const char *name, int timeout),
> +
> +	TP_ARGS(name, timeout),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(int, timeout)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = name;
> +		__entry->timeout = timeout;
> +	),
> +
> +	TP_printk("name=%s, timeout=%d",
> +		__entry->name, __entry->timeout)
> +);
> +
> +TRACE_EVENT(host1x_cdma_push,
> +	TP_PROTO(const char *name, u32 op1, u32 op2),
> +
> +	TP_ARGS(name, op1, op2),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(u32, op1)
> +		__field(u32, op2)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = name;
> +		__entry->op1 = op1;
> +		__entry->op2 = op2;
> +	),
> +
> +	TP_printk("name=%s, op1=%08x, op2=%08x",
> +		__entry->name, __entry->op1, __entry->op2)
> +);
> +
> +TRACE_EVENT(host1x_cdma_push_gather,
> +	TP_PROTO(const char *name, u32 mem_id,
> +			u32 words, u32 offset, void *cmdbuf),
> +
> +	TP_ARGS(name, mem_id, words, offset, cmdbuf),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(u32, mem_id)
> +		__field(u32, words)
> +		__field(u32, offset)
> +		__field(bool, cmdbuf)
> +		__dynamic_array(u32, cmdbuf, words)
> +	),
> +
> +	TP_fast_assign(
> +		if (cmdbuf) {
> +			memcpy(__get_dynamic_array(cmdbuf), cmdbuf+offset,
> +					words * sizeof(u32));
> +		}
> +		__entry->cmdbuf = cmdbuf;
> +		__entry->name = name;
> +		__entry->mem_id = mem_id;
> +		__entry->words = words;
> +		__entry->offset = offset;
> +	),
> +
> +	TP_printk("name=%s, mem_id=%08x, words=%u, offset=%d, contents=[%s]",
> +	  __entry->name, __entry->mem_id,
> +	  __entry->words, __entry->offset,
> +	  __print_hex(__get_dynamic_array(cmdbuf),
> +		  __entry->cmdbuf ? __entry->words * 4 : 0))
> +);
> +
> +TRACE_EVENT(host1x_channel_submit,
> +	TP_PROTO(const char *name, u32 cmdbufs, u32 relocs, u32 waitchks,
> +			u32 syncpt_id, u32 syncpt_incrs),
> +
> +	TP_ARGS(name, cmdbufs, relocs, waitchks, syncpt_id, syncpt_incrs),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(u32, cmdbufs)
> +		__field(u32, relocs)
> +		__field(u32, waitchks)
> +		__field(u32, syncpt_id)
> +		__field(u32, syncpt_incrs)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = name;
> +		__entry->cmdbufs = cmdbufs;
> +		__entry->relocs = relocs;
> +		__entry->waitchks = waitchks;
> +		__entry->syncpt_id = syncpt_id;
> +		__entry->syncpt_incrs = syncpt_incrs;
> +	),
> +
> +	TP_printk("name=%s, cmdbufs=%u, relocs=%u, waitchks=%d,"
> +		"syncpt_id=%u, syncpt_incrs=%u",
> +	  __entry->name, __entry->cmdbufs, __entry->relocs, __entry->waitchks,
> +	  __entry->syncpt_id, __entry->syncpt_incrs)
> +);
> +
> +TRACE_EVENT(host1x_channel_submitted,
> +	TP_PROTO(const char *name, u32 syncpt_base, u32 syncpt_max),
> +
> +	TP_ARGS(name, syncpt_base, syncpt_max),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(u32, syncpt_base)
> +		__field(u32, syncpt_max)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = name;
> +		__entry->syncpt_base = syncpt_base;
> +		__entry->syncpt_max = syncpt_max;
> +	),
> +
> +	TP_printk("name=%s, syncpt_base=%d, syncpt_max=%d",
> +		__entry->name, __entry->syncpt_base, __entry->syncpt_max)
> +);
> +
> +TRACE_EVENT(host1x_channel_submit_complete,
> +	TP_PROTO(const char *name, int count, u32 thresh),
> +
> +	TP_ARGS(name, count, thresh),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(int, count)
> +		__field(u32, thresh)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = name;
> +		__entry->count = count;
> +		__entry->thresh = thresh;
> +	),
> +
> +	TP_printk("name=%s, count=%d, thresh=%d",
> +		__entry->name, __entry->count, __entry->thresh)
> +);
> +
> +TRACE_EVENT(host1x_wait_cdma,
> +	TP_PROTO(const char *name, u32 eventid),
> +
> +	TP_ARGS(name, eventid),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(u32, eventid)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->name = name;
> +		__entry->eventid = eventid;
> +	),
> +
> +	TP_printk("name=%s, event=%d", __entry->name, __entry->eventid)
> +);
> +
>  TRACE_EVENT(host1x_syncpt_load_min,
>  	TP_PROTO(u32 id, u32 val),
>  
> @@ -55,6 +263,33 @@ TRACE_EVENT(host1x_syncpt_load_min,
>  	TP_printk("id=%d, val=%d", __entry->id, __entry->val)
>  );
>  
> +TRACE_EVENT(host1x_syncpt_wait_check,
> +	TP_PROTO(u32 mem_id, u32 offset, u32 syncpt_id, u32 thresh, u32 min),
> +
> +	TP_ARGS(mem_id, offset, syncpt_id, thresh, min),
> +
> +	TP_STRUCT__entry(
> +		__field(u32, mem_id)
> +		__field(u32, offset)
> +		__field(u32, syncpt_id)
> +		__field(u32, thresh)
> +		__field(u32, min)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->mem_id = mem_id;
> +		__entry->offset = offset;
> +		__entry->syncpt_id = syncpt_id;
> +		__entry->thresh = thresh;
> +		__entry->min = min;
> +	),
> +
> +	TP_printk("mem_id=%08x, offset=%05x, id=%d, thresh=%d, current=%d",
> +		__entry->mem_id, __entry->offset,
> +		__entry->syncpt_id, __entry->thresh,
> +		__entry->min)
> +);

If you can combine any of these others into DECLARE_EVENT_CLASS() and
DEFINE_EVENT()s, please do.

Thanks,

-- Steve

> +
>  #endif /*  _TRACE_HOST1X_H */
>  
>  /* This part must be outside protection */


