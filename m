Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab2C1KAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:00:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52847
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908Ab2C1KAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:00:32 -0400
Date: Wed, 28 Mar 2012 06:00:27 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
Subject: Re: [PATCH 4/4] compat: add some tracing backport work
Message-ID: <20120328100027.GA4420@bombadil.infradead.org>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
 <1332214021-9716-5-git-send-email-mcgrof@frijolero.org>
 <1332245766.3329.14.camel@jlt3.sipsolutions.net>
 <CAB=NE6XyDDfzu71K-1ecMQ+F-0Z1iTN4OKCUjJ+E3yxvydks0Q@mail.gmail.com>
 <CAB=NE6XXd-T5B37Cc_eCwnWHRk-_UVn0JY0mQjzMQcK+ZcLuWQ@mail.gmail.com>
 <1332751768.3511.3.camel@jlt3.sipsolutions.net>
 <20120326125822.GA11929@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120326125822.GA11929@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 08:58:22AM -0400, Luis R. Rodriguez wrote:
> On Mon, Mar 26, 2012 at 10:49:28AM +0200, Johannes Berg wrote:
> > On Wed, 2012-03-21 at 21:29 -0700, Luis R. Rodriguez wrote:
> > 
> > > But no dice. I then figured it may be my kernel with
> > > CONFIG_TRACEPOINTS=y and indeed that is the case -- so we have to
> > > consider the case where the target kernel may have tracing enabled and
> > > we have to disable it somehow. Undef'ing CONFIG_TRACEPOINTS and
> > > DECLARE_TRACE doesn't really do it.
> > 
> > Oh, ok, yuck. So I guess we can't easily disable tracing if it's enabled
> > in the base kernel ...
> 
> Its a  bit tough.

I've managed to backport tracing it seems, even when CONFIG_TRACEPOINTS
is enabled. The patch below covers that. I'll spew out the latest
error log on compaling compat-wireless though, this is down on
2.6.31.

/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_power_on’:
/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c:771:19: warning: unused variable ‘host’
/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_power_save’:
/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c:1071:2: error: implicit declaration of function ‘pm_runtime_put_sync’
/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_power_restore’:
/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c:1081:2: error: implicit declaration of function ‘pm_runtime_get_sync’
/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_probe’:
/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c:1231:2: error: implicit declaration of function ‘pm_runtime_put_noidle’
/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_remove’:
/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.c:1268:2: error: implicit declaration of function ‘pm_runtime_get_noresume’
make[4]: *** [/home/mcgrof/devel/compat-wireless/drivers/net/wireless/libertas/if_sdio.o] Error 1

This compilation issue is not related to tracing and seems trivial to
resolve. So hey this is great progress..

>From 7d549b33d180b96a6b34e1c9d1298a1c1ec557d4 Mon Sep 17 00:00:00 2001
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 28 Mar 2012 02:45:07 -0700
Subject: [PATCH] compat: complete tracepoint backport

Tested also against compat-wireless against:

	* 2.6.33
	* 2.6.32

I'm happy with this.

compat ckmake:

Trying kernel                  3.3.0-030300rc2-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                        2.6.38-13-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                        2.6.31-22-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [OK]
Trying kernel                    2.6.24-020624-generic  [OK]

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 include/linux/tracepoint.h |  145 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 140 insertions(+), 5 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index a5bd743..44c9a5d 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -13,10 +13,12 @@
 #define TP_STRUCT__entry(args...) args
 #endif
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
 /* Backports 091ad365, a rename */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
 #define DECLARE_EVENT_CLASS TRACE_EVENT_TEMPLATE
+#endif
 
+/* Backpports 2939b0469 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
 #define TP_PROTO TPPROTO
 #define TP_ARGS TPARGS
@@ -24,7 +26,143 @@
 #define TP_RAW_FMT TPRAWFMT
 #endif
 
-#endif
+/* Force disabling tracing */
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+
+#define DEFINE_EVENT(template, name, proto, args)               \
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+
+#undef DECLARE_TRACE_NOARGS
+#define DECLARE_TRACE_NOARGS(name)					\
+		__DECLARE_TRACE(name, void, , 1, void *__data, __data)
+
+
+/* Backports 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
+
+#undef DECLARE_TRACE
+#define DECLARE_TRACE(name, proto, args)				\
+		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), 1,	\
+				PARAMS(void *__data, proto),		\
+				PARAMS(__data, args))
+
+#undef DECLARE_TRACE_CONDITION
+#define DECLARE_TRACE_CONDITION(name, proto, args, cond)		\
+	__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), PARAMS(cond), \
+			PARAMS(void *__data, proto),			\
+			PARAMS(__data, args))
+
+#else
+
+#undef DECLARE_TRACE
+#define DECLARE_TRACE(name, proto, args)				\
+		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), 1,	\
+				PARAMS(void *__data, proto),		\
+				PARAMS(__data, args))
+
+#undef DECLARE_TRACE_CONDITION
+#define DECLARE_TRACE_CONDITION(name, proto, args, cond)		\
+	__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), PARAMS(cond), \
+			PARAMS(void *__data, proto),			\
+			PARAMS(__data, args))
+#endif /* backport 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e */
+
+/* Backports 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
+
+/* Backports c420970ef476d7d68df119711700666224001f43 */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
+
+#undef __DECLARE_TRACE
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{ }								\
+	static inline int						\
+	register_trace_##name(void (*probe)(proto))			\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline void						\
+	unregister_trace_##name(void (*probe)(proto))			\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
+	{								\
+	}
+#else
+
+#undef __DECLARE_TRACE
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{ }								\
+	static inline int						\
+	register_trace_##name(void (*probe)(proto))			\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline int						\
+	unregister_trace_##name(void (*probe)(proto))			\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
+	{								\
+	}
+#endif /* backport c420970ef476d7d68df119711700666224001f43 */
+
+#else
+
+#undef __DECLARE_TRACE
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{ }								\
+	static inline int						\
+	register_trace_##name(void (*probe)(data_proto),		\
+			      void *data)				\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline int						\
+	unregister_trace_##name(void (*probe)(data_proto),		\
+				void *data)				\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
+	{								\
+	}
+
+#endif /* backport 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e */
+
+#undef DEFINE_TRACE_FN
+#define DEFINE_TRACE_FN(name, reg, unreg)
+
+#undef DEFINE_TRACE
+#define DEFINE_TRACE(name)
+
+#undef EXPORT_TRACEPOINT_SYMBOL_GPL
+#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
+
+#undef EXPORT_TRACEPOINT_SYMBOL
+#define EXPORT_TRACEPOINT_SYMBOL(name)
+
+#ifdef CONFIG_TRACEPOINTS
+#else /* CONFIG_TRACEPOINTS */
+#endif /* CONFIG_TRACEPOINTS */
 
 #else /* just disable tracing */
 
@@ -42,9 +180,6 @@ static inline void trace_ ## name(proto) {}
 #define TP_ARGS(args...)   args
 #define TP_CONDITION(args...)      args
 
-struct tracepoint_iter {
-};
-
 #endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
 
 #endif	/* _COMPAT_LINUX_TRACEPOINT_H */
-- 
1.7.10.rc1.22.gf5241

