Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2DEMdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 08:33:12 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2DEMdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 08:33:10 -0400
Message-ID: <1333629184.3494.12.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH 4/4] compat: add some tracing backport work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
Date: Thu, 05 Apr 2012 14:33:04 +0200
In-Reply-To: <20120328100027.GA4420@bombadil.infradead.org> (sfid-20120328_120100_045553_52796B2A)
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
	 <1332214021-9716-5-git-send-email-mcgrof@frijolero.org>
	 <1332245766.3329.14.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XyDDfzu71K-1ecMQ+F-0Z1iTN4OKCUjJ+E3yxvydks0Q@mail.gmail.com>
	 <CAB=NE6XXd-T5B37Cc_eCwnWHRk-_UVn0JY0mQjzMQcK+ZcLuWQ@mail.gmail.com>
	 <1332751768.3511.3.camel@jlt3.sipsolutions.net>
	 <20120326125822.GA11929@bombadil.infradead.org>
	 <20120328100027.GA4420@bombadil.infradead.org>
	 (sfid-20120328_120100_045553_52796B2A)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 06:00 -0400, Luis R. Rodriguez wrote:

> I've managed to backport tracing it seems, even when CONFIG_TRACEPOINTS
> is enabled.

Nope, you've managed to completely kill tracing.


> +#undef __DECLARE_TRACE
> +#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
> +	static inline void trace_##name(proto)				\
> +	{ }								\
> +	static inline void trace_##name##_rcuidle(proto)		\
> +	{ }								\
> +	static inline int						\
> +	register_trace_##name(void (*probe)(proto))			\
> +	{								\
> +		return -ENOSYS;						\
> +	}								\
> +	static inline void						\
> +	unregister_trace_##name(void (*probe)(proto))			\
> +	{								\
> +		return -ENOSYS;						\
> +	}								\
> +	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
> +	{								\
> +	}

All of this simply completely kills tracing. Worse, the tracepoints get
registered, but their trace_##name functions do nothing, so you can
think that they're there, but they never record data ...

The old way was much better. Can we just let 2.6.24 and the other
ancients die in peace?

johannes

