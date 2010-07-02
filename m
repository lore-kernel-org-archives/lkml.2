Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0GBIGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:06:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:3128 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0GBIGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:06:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,525,1272870000"; 
   d="scan'208";a="532501344"
Subject: Re: [rfc] Describe events in a structured way via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100629102656.GA25512@elte.hu>
References: <1277187920.4467.3.camel@minggr.sh.intel.com>
	 <1277189971.3637.5.camel@jlt3.sipsolutions.net>
	 <1277191359.5025.4.camel@minggr.sh.intel.com>
	 <1277192007.3637.8.camel@jlt3.sipsolutions.net>
	 <20100624093625.GA26931@elte.hu>
	 <1277396053.3870.16.camel@jlt3.sipsolutions.net>
	 <20100624173315.GA30403@elte.hu>
	 <1277792114.5400.5.camel@minggr.sh.intel.com>
	 <20100629085532.GE22344@elte.hu>
	 <1277803248.5400.16.camel@minggr.sh.intel.com>
	 <20100629102656.GA25512@elte.hu>
Content-Type: text/plain
Date: Fri, 02 Jul 2010 16:06:36 +0800
Message-Id: <1278057996.3841.26.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 18:26 +0800, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > > Also, we can (optionally) consider 'generic', subsystem level events to 
> > > also show up under:
> > > 
> > >    /sys/bus/pci/drivers/i915/events/
> > > 
> > > This would give a model to non-device-specific events to be listed one 
> > > level higher in the sysfs hierarchy.
> > > 
> > > This too would be done in the driver, not by generic code. It's generally 
> > > the driver which knows how the events should be categorized.
> > 
> > This is a bit difficult. I'd like not to touch TRACE_EVENT(). [...]
> 
> We can certainly start with the simpler variant - it's also the more common 
> case.
> 
> > [...] How does the driver know if an event is 'generic' if TRACE_EVENT is 
> > not touched?
> 
> Well, it's per driver code which creates the 'events' directory anyway, so 
> that code decides where to link things. It can link it to the per driver kobj 
> - or to the per subsys kobj.
> 
> > > I'd imagine something similar for wireless drivers as well - most 
> > > currently defined events would show up on a per device basis there.
> > > 
> > > Can you see practical problems with this scheme?
> > 
> > Not now. I may find some problems when write more detail code.
> 
> Ok. Feel free to post RFC patches (even if they are not fully complete yet), 
> so that we can see how things are progressing.
> 
> I suspect the best approach would be to try to figure out the right sysfs 
> placement for one or two existing driver tracepoints, so that we can see it 
> all in practice. (Obviously any changes to drivers will have to go via the 
> relevant driver maintainer tree(s).)

Well, take i915 tracepoints as an example, the sys structures as below

/sys/class/drm/card0/events/
|-- i915_gem_object_bind
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_object_change_domain
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_object_clflush
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_object_create
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_object_destroy
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_object_get_fence
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_object_unbind
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_request_complete
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_request_flush
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_request_retire
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_request_submit
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_request_wait_begin
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_gem_request_wait_end
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
|-- i915_ring_wait_begin
|   |-- enable
|   |-- filter
|   |-- format
|   `-- id
`-- i915_ring_wait_end
    |-- enable
    |-- filter
    |-- format
    `-- id

And below is the very draft patch to export i915 tracepoints in sysfs.
Is it the right direction?

---
 drivers/gpu/drm/i915/i915_drv.c |   15 +++-
 include/linux/perf_event.h      |    2 +
 kernel/perf_event.c             |  168 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 186 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 423dc90..eb7fa9e 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/perf_event.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
@@ -413,7 +414,19 @@ int i965_reset(struct drm_device *dev, u8 flags)
 static int __devinit
 i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	return drm_get_dev(pdev, ent, &driver);
+	struct kobject *kobj;
+	struct drm_device *drm_dev;
+	int ret;
+
+	ret = drm_get_dev(pdev, ent, &driver);
+
+	if (!ret) {
+		drm_dev = pci_get_drvdata(pdev);
+		kobj = &drm_dev->primary->kdev.kobj;
+		perf_sys_register_tp(kobj, "i915");
+	}
+
+	return ret;
 }
 
 static void
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 716f99b..2a6d834 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1019,6 +1019,8 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+
+extern void perf_sys_register_tp(struct kobject *kobj, char *tp_system);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 403d180..068ee48 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5877,3 +5877,171 @@ static int __init perf_event_sysfs_init(void)
 				  &perfclass_attr_group);
 }
 device_initcall(perf_event_sysfs_init);
+
+#define for_each_event(event, start, end)			\
+	for (event = start;					\
+	     (unsigned long)event < (unsigned long)end;		\
+	     event++)
+
+extern struct ftrace_event_call __start_ftrace_events[];
+extern struct ftrace_event_call __stop_ftrace_events[];
+extern void print_event_filter(struct ftrace_event_call *call,
+                               struct trace_seq *s);
+
+struct tp_kobject {
+	struct kobject *kobj;
+	struct ftrace_event_call *call;
+	struct tp_kobject *next;
+};
+
+static struct tp_kobject *tp_kobject_list;
+
+static struct ftrace_event_call *perf_sys_find_tp_call(struct kobject *kobj)
+{
+	struct tp_kobject *tp_kobj;
+
+	tp_kobj = tp_kobject_list;
+
+	while (tp_kobj) {
+		if (kobj == tp_kobj->kobj)
+			return tp_kobj->call;
+
+		tp_kobj = tp_kobj->next;
+	}
+
+	return NULL;
+}
+
+#define TP_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+#define TP_ATTR(_name) \
+	static struct kobj_attribute _name##_attr = \
+		__ATTR(_name, 0644, _name##_show, _name##_store)
+
+static ssize_t enable_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	struct ftrace_event_call *call;
+
+	call = perf_sys_find_tp_call(kobj);
+	return sprintf(buf, "%d\n", call->flags & TRACE_EVENT_FL_ENABLED);
+}
+
+static ssize_t enable_store(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	/* Not implemented yet */
+
+	return 0;
+}
+TP_ATTR(enable);
+
+static ssize_t filter_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	struct ftrace_event_call *call;
+	struct trace_seq *s;
+
+	call = perf_sys_find_tp_call(kobj);
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	print_event_filter(call, s);
+
+	memcpy(buf, s->buffer, s->len);
+
+	kfree(s);
+
+	return s->len;
+}
+
+static ssize_t filter_store(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	/* Not implemented yet */
+
+	return 0;
+}
+TP_ATTR(filter);
+
+static ssize_t format_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	/* Not implemented yet */
+
+	return 0;
+}
+TP_ATTR_RO(format);
+
+static ssize_t id_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	struct ftrace_event_call *call;
+
+	call = perf_sys_find_tp_call(kobj);
+
+	return sprintf(buf, "%d\n", call->event.type);
+}
+TP_ATTR_RO(id);
+
+static struct attribute *tp_attrs[] = {
+	&enable_attr.attr,
+	&filter_attr.attr,
+	&format_attr.attr,
+	&id_attr.attr,
+	NULL,
+};
+
+static struct attribute_group tp_attr_group = {
+	.attrs = tp_attrs,
+};
+
+static int perf_sys_add_tp(struct kobject *parent, struct ftrace_event_call *call)
+{
+	struct tp_kobject *tp_kobj;
+	struct kobject *event_kobj;
+	int err;
+
+	event_kobj = kobject_create_and_add(call->name, parent);
+	if (!event_kobj)
+		return -ENOMEM;
+	err = sysfs_create_group(event_kobj, &tp_attr_group);
+	if (err) {
+		kobject_put(event_kobj);
+		return -ENOMEM;
+	}
+
+	tp_kobj = kmalloc(sizeof(*tp_kobj), GFP_KERNEL);
+	if (!tp_kobj) {
+		kobject_put(event_kobj);	
+		return -ENOMEM;
+	}	
+
+	tp_kobj->kobj = event_kobj;
+	tp_kobj->call = call;
+	tp_kobj->next = tp_kobject_list;
+	tp_kobject_list = tp_kobj;	
+
+	return 0;
+}
+
+void perf_sys_register_tp(struct kobject *kobj, char *tp_system)
+{
+	struct ftrace_event_call *call;
+	struct kobject *events_kobj;
+
+	events_kobj = kobject_create_and_add("events", kobj);
+	if (!events_kobj)
+		return;
+
+	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
+		if (call->class->system && !strcmp(call->class->system, tp_system)) {
+			perf_sys_add_tp(events_kobj, call);
+		}
+	}
+}


