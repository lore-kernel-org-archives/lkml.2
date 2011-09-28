Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1I1FL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:11:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1I1FLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:11:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110928145144.3d074db9aa9b6f858e0dc4fb@canb.auug.org.au>
References: <20110928145144.3d074db9aa9b6f858e0dc4fb@canb.auug.org.au>
Date: Wed, 28 Sep 2011 13:11:24 +0800
Message-ID: <CACVXFVMrPNZupCQnBMBXsSA1OH=15m9QBKhXT1Of+LghZbKn0Q@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pm tree
From: Ming Lei <ming.lei@canonical.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e64c145e6fa9e804adf96c52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64c145e6fa9e804adf96c52
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Stephen and Rafael,

Sorry, the attachment patch can fix the build failure, which is
caused by unset CONFIG_RUNTIME_PM.

thanks,
--
Ming Lei

On Wed, Sep 28, 2011 at 12:51 PM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> Hi Rafael,
>
> After merging the pm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> In file included from include/trace/ftrace.h:567:0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from include/trace/define_trace.h:96,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from include/trace/events/rpm.h:99,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from kernel/trace/rpm-traces.c:15:
> include/trace/events/rpm.h: In function 'ftrace_raw_event_rpm_internal':
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'usage_count'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'disable_depth'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'runtime_auto'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'request_pending'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'irq_safe'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'child_count'
> In file included from include/trace/ftrace.h:771:0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from include/trace/define_trace.h:96,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from include/trace/events/rpm.h:99,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from kernel/trace/rpm-traces.c:15:
> include/trace/events/rpm.h: In function 'perf_trace_rpm_internal':
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'usage_count'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'disable_depth'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'runtime_auto'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'request_pending'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'irq_safe'
> include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no membe=
r named 'child_count'
>
> Presumably caused by commit 53b615ccca56 ("PM / Runtime: Introduce trace
> points for tracing rpm_* functions").
>
> I have used the pm tree from next-20110927 for today.
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr@canb.auug.org=
.au
> http://www.canb.auug.org.au/~sfr/
>

--0016e64c145e6fa9e804adf96c52
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-kernel-trace-rpm-traces.c-fix-build-failure-if-RUNTI.patch"
Content-Disposition: attachment; 
	filename="0001-kernel-trace-rpm-traces.c-fix-build-failure-if-RUNTI.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gt3uwngy1

RnJvbSBmZWIwMzdlOTU3MTQ5ZjBkYzQwNWI4MGI0YmI5Y2RhZmVjNmZjYjBmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaW5nIExlaSA8bWluZy5sZWlAY2Fub25pY2FsLmNvbT4KRGF0
ZTogV2VkLCAyOCBTZXAgMjAxMSAxMzowNzowNCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGtlcm5l
bC90cmFjZS9ycG0tdHJhY2VzLmM6IGZpeCBidWlsZCBmYWlsdXJlIGlmIFJVTlRJTUVfUE0KIHVu
c2V0CgoKU2lnbmVkLW9mZi1ieTogTWluZyBMZWkgPG1pbmcubGVpQGNhbm9uaWNhbC5jb20+Ci0t
LQoga2VybmVsL3RyYWNlL3JwbS10cmFjZXMuYyB8ICAgIDIgKysKIDEgZmlsZXMgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFj
ZS9ycG0tdHJhY2VzLmMgYi9rZXJuZWwvdHJhY2UvcnBtLXRyYWNlcy5jCmluZGV4IDk5ODk0OWUu
LmMxNjFjNWUgMTAwNjQ0Ci0tLSBhL2tlcm5lbC90cmFjZS9ycG0tdHJhY2VzLmMKKysrIGIva2Vy
bmVsL3RyYWNlL3JwbS10cmFjZXMuYwpAQCAtMTEsNiArMTEsNyBAQAogI2luY2x1ZGUgPGxpbnV4
L21vZHVsZS5oPgogI2luY2x1ZGUgPGxpbnV4L3VzYi5oPgogCisjaWZkZWYgQ09ORklHX1BNX1JV
TlRJTUUKICNkZWZpbmUgQ1JFQVRFX1RSQUNFX1BPSU5UUwogI2luY2x1ZGUgPHRyYWNlL2V2ZW50
cy9ycG0uaD4KIApAQCAtMTgsNCArMTksNSBAQCBFWFBPUlRfVFJBQ0VQT0lOVF9TWU1CT0xfR1BM
KHJwbV9yZXR1cm5faW50KTsKIEVYUE9SVF9UUkFDRVBPSU5UX1NZTUJPTF9HUEwocnBtX2lkbGUp
OwogRVhQT1JUX1RSQUNFUE9JTlRfU1lNQk9MX0dQTChycG1fc3VzcGVuZCk7CiBFWFBPUlRfVFJB
Q0VQT0lOVF9TWU1CT0xfR1BMKHJwbV9yZXN1bWUpOworI2VuZGlmCiAKLS0gCjEuNy41LjQKCg==
--0016e64c145e6fa9e804adf96c52--
