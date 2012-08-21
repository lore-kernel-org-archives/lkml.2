Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab2HUNYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:24:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43448 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2HUNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:24:32 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKMK7uFr972_aC8+HojLYe+Dsa0Abo0_qkLq8mbgSQs09sXihQ@mail.gmail.com>
References: <CA+icZUWg7qEFvAsTMb9OFKmdW7XD4op14Ps2y6PLByZRArjeLg@mail.gmail.com>
	<CA+icZUVjr6aaopVAhGRr13RLDy=epdnU30YTHOhjXmrWb2sAjA@mail.gmail.com>
	<CA+icZUXD+oWqTKB2b_xu8UEDnX6mSs_aELaGu9UQs_U4fHaKGQ@mail.gmail.com>
	<CAKMK7uFr972_aC8+HojLYe+Dsa0Abo0_qkLq8mbgSQs09sXihQ@mail.gmail.com>
Date: Tue, 21 Aug 2012 15:24:30 +0200
Message-ID: <CA+icZUVVjJ8wzJjM=Agw7xU65qgSekwW++wo_vNe_YELUT0bWA@mail.gmail.com>
Subject: Re: inux-next: Tree for Aug 21 (call-trace when suspending: PM?)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=f46d04016983e03d7e04c7c68bfe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04016983e03d7e04c7c68bfe
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 21, 2012 at 1:53 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Aug 21, 2012 at 1:14 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Tue, Aug 21, 2012 at 1:03 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Tue, Aug 21, 2012 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> On Tue, Aug 21, 2012 at 8:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>> Hi all,
>>>>>
>>>>> Changes since 20120820:
>>>>>
>>>>> The rr tree gained a conflict against Linus' tree.
>>>>>
>>>>> The tip tree still has its build failure so I used the version from
>>>>> next-20120814.
>>>>>
>>>>> The workqueues tree gained a conflict against the hid tree.
>>>>>
>>>>> The drivers-x86 tree still has its build failure so I used the version
>>>>> from next-20120817.
>>>>>
>>>>> The signal tree gained a conflict against Linus' tree.  I have still
>>>>> reverted 3 commits from the signal tree at the request of the arm
>>>>> maintainer.
>>>>>
>>>>> ----------------------------------------------------------------------------
>>>>>
>>>>
>>>> Hi,
>>>>
>>>> I have compiled linux-next (next-20120821) and see the attached
>>>> call-trace when suspending.
>>>> Suspending did NOT work (Xorg seems to cause it) - machine came back to desktop.
>>>>
>>>> With yesterday's next-20120820 I haven't seen this.
>>>>
>>>> I am not sure what is this causing... PM, x86/sched or even VFS?
>>>> Any help for debugging appreciated.
>>>>
>>>> I am on Ubuntu/precise AMD64 and use systemd-v43 as init-system.
>>>>
>>>> Regards,
>>>> - Sedat -
>>>
>>> Forgot attachment!
>>> If you don't succeed - try try try...
>>>
>>> - Sedat -
>>
>> [ CC danvet ]
>>
>> I have pulled in drm-intel-fixes into my local GIT tree and rebuilt
>> i915 - this seems to fix the problem.
>> Daniel any suggestion which patch in d-i-f did it?
>
> Without the backtrace it's kinda hard to tell ... Also, if you can
> dump a git log of the commits from -fixes that you don't yet have.
> -Daniel
>

Hi Daniel,

$ git log --oneline v3.6.0-rc2-next20120821-1-iniza-generic..drm-intel-fixes
1ee9ae3 drm/i915: use hsw rps tuning values everywhere on gen6+
f1a2f5b drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads
4eab813 drm/i915: extract connector update from intel_ddc_get_modes() for reuse
a843af1 drm/i915: fix hsw uncached pte
b6c7488 drm/i915/contexts: fix list corruption
38ab8a2 drm/i915: fix EDID memory leak in SDVO

Looks like "1ee9ae3 drm/i915: use hsw rps tuning values everywhere on
gen6+" has PM fixes for i915.

I tried with only that patch on top of today's linux-next - and I can
suspend/resume again!

$ git log --oneline
v3.6.0-rc2-next20120821-1-iniza-generic..drm-intel-fixes-1ee9ae3
88eb888 drm/i915: use hsw rps tuning values everywhere on gen6+

Hope this helps others - sorry for bothering other maintainers.

- Sedat -

>>
>> [1] http://cgit.freedesktop.org/~danvet/drm-intel/log/?h=drm-intel-fixes
>
>
>
> --
> Daniel Vetter
> daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch

--f46d04016983e03d7e04c7c68bfe
Content-Type: application/octet-stream; 
	name="0001-drm-i915-use-hsw-rps-tuning-values-everywhere-on-gen.patch"
Content-Disposition: attachment; 
	filename="0001-drm-i915-use-hsw-rps-tuning-values-everywhere-on-gen.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h650xygw0

RnJvbSAxZWU5YWUzMjQ0YzQ3ODlmMzE4NGM1MTIzZjNiMmQ3ZTQwNWIzZjRjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYW5pZWwgVmV0dGVyIDxkYW5pZWwudmV0dGVyQGZmd2xsLmNo
PgpEYXRlOiBXZWQsIDE1IEF1ZyAyMDEyIDEwOjQxOjQ1ICswMjAwClN1YmplY3Q6IFtQQVRDSF0g
ZHJtL2k5MTU6IHVzZSBoc3cgcnBzIHR1bmluZyB2YWx1ZXMgZXZlcnl3aGVyZSBvbiBnZW42KwoK
SmFtZXMgQm90dG9tbGV5IHJlcG9ydGVkIFsxXSBhIG1hc3NpdmUgcG93ZXIgcmVncmVzc2lvbiwg
ZHVlIHRvIHRoZQplbmFibGluZyBvZiBzZW1hcGhvcmVzIGJ5IGRlZmF1bHQgaW4gMy41LiBBIHdv
cmthcm91bmQgZm9yIGhpbSBpcyB0bwphZ2FpbiBkaXNhYmxlIHNlbWFwaG9yZXMuIEFuZCBpbmRl
ZWQsIGhpcyBzeXN0ZW0gaGFzIGEgdmVyeSBoYXJkIHRpbWUKdG8gZW50ZXIgcmM2IHdpdGggc2Vt
YXBob3JlcyBlbmFibGVkLgoKQmVuIFdpZGF3c2t5IHJ1biBhcm91bmQgd2l0aCBhIGtpbGwtYS13
YXR0IGEgbG90IGFuZCBub3RpY2VkOgotIFRoZXJlIGFyZSBpbmRlZWQgYSBmZXcgcmFyZSBzeXN0
ZW1zIHRoYXQgc2VlbSB0byBoYXZlIGEgaGFyZCB0aW1lCiAgZW50ZXJpbmcgcmM2IHdoZW4gZGVz
a3RvcC1pZGxlLgotIE9uZSBtYWNoaW5lLCBUaGUgSW5kZXN0cnVjdGlibGUgVG9zaGliYSByZWdy
ZXNzZWQgaW4gdGhpcyBiZWhhdmlvdXIKICBiZXR3ZWVuIDMuNSBhbmQgMy42IGluIGEgbWVyZ2Ug
Y29tbWl0ISBTbyByYzYgYmVoYXZpb3VyIHdpdGggdGhlCiAgY3VycmVudCBzZXR0aW5nIHNlZW1z
IHRvIGJlIGhpZ2hseSB0aW1pbmcgZGVwZW5kZW50IGFuZCBub3Qgcm9idXN0CiAgYXQgYWxsLgot
IFRoZSBiZWhhdmlvdXIgSmFtZXMgcmVwb3J0ZWQgd3J0IHNlbWFwaG9yZXMgc2VlbXMgdG8gYmUg
YSBmcmVhawogIHRpbWluZyB0aGluZyB0aGF0IG9ubHkgaGFwcGVucyBvbiBoaXMgc3BlY2lmaWMg
bWFjaGluZSwgY29uZmlybWluZwogIHRoYXQgZW5hYmxpbmcgc2VtYXBob3JlcyBzaG91bGRuJ3Qg
cmVkdWNlIHJjNiByZXNpZGVuY3kuCgpOb3cgZnVydGhlcm1vcmUgdGhlIEdvb2dsZSBDaHJvbWVP
UyBndXlzIHJlcG9ydGVkIFsyXSBhIHdoaWxlIGFnbyB0aGF0CmF0IGxlYXN0IG9uIHNvbWUgbWFj
aGluZXMgYSBzaW1wbHkgYSBibGlua2luZyBjdXJzb3IgY2FuIGtlZXAgdGhlIGdwdQp0dXJibyBh
dCB0aGUgaGlnaGVzdCBmcmVxdWVuY3kuIFRoaXMgaXMgYmVjYXVzZSB0aGUgY3VycmVudCBycHMg
bGltaXRzCnVzZWQgb24gc25iL2l2YiBhcmUgaGlnaGx5IGFzeW1tZXRyaWMuCgpPbiB0aGUgdGhl
b3J5IHRoYXQgZ3B1IHR1cmJvIGFuZCByYzYgdHVuaW5nIHZhbHVlcyBhcmUgcmVsYXRlZCwgd2Un
dmUKdHJpZWQgd2hldGhlciB0aGUgbXVjaCBzYW5lciBsb29raW5nIChzaW5jZSBtdWNoIGxlc3Mg
YXN5bW1ldHJpYykgcnBzCnR1bmluZyB2YWx1ZXMgdXNlZCBmb3IgaHN3IHdvdWxkIGFsc28gaGVs
cCBlbnRlcmluZyByYzYgbW9yZSByb2J1c3RseS4KCkFuZCBpdCBzZWVtcyB0byBtb3N0bHkgd29y
aywgYW5kIHdlIGRvbid0IHJlYWxseSBoYXZlIHRoZSByZXNvdXJjZXMgdG8KdGhyb3VnaC1yb3Vn
aGx5IHR1bmUgdGhpbmdzIGluIGFueSBiZXR0ZXIgd2F5OiBUaGUgdmFsdWVzIGZyb20gdGhlCkNo
cm9tZU9TIHBwbCBzZWVtIHRvIGZhcmUgYSBiaXQgd29yc2UgZm9yIEphbWVzJyBtYWNoaW5lLCBz
byBJIGd1ZXNzCndlIGJldHRlciBzdGljayB3aXRoIHNvbWV0aGluZyB2cGcgKHRoZSBncHUgaHcv
d2luZG93cyBncm91cCkKcHJvdmlkZWQsIGhvcGluZyB0aGF0IHRoZXkndmUgZG9uZSB0aGVpciBq
b2JzLgoKUmVmZXJlbmNlWzFdOiBodHRwOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL2FyY2hpdmVz
L2RyaS1kZXZlbC8yMDEyLUp1bHkvMDI1Njc1Lmh0bWwKUmVmZXJlbmNlWzJdOiBodHRwOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL2FyY2hpdmVzL2ludGVsLWdmeC8yMDEyLUp1bHkvMDE4NjkyLmh0
bWwKQnVnemlsbGE6IGh0dHBzOi8vYnVncy5mcmVlZGVza3RvcC5vcmcvc2hvd19idWcuY2dpP2lk
PTUzMzkzClRlc3RlZC1ieTogQmVuIFdpZGF3c2t5IDxiZW5AYndpZGF3c2submV0PgpDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgVmV0dGVyIDxkYW5pZWwu
dmV0dGVyQGZmd2xsLmNoPgotLS0KIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3BtLmMgfCAg
IDE1ICsrKystLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMTEg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcG0u
YyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3BtLmMKaW5kZXggNThjMDdjZC4uMTg4MWM4
YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcG0uYworKysgYi9kcml2
ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9wbS5jCkBAIC0yNDQxLDE3ICsyNDQxLDEwIEBAIHN0YXRp
YyB2b2lkIGdlbjZfZW5hYmxlX3JwcyhzdHJ1Y3QgZHJtX2RldmljZSAqZGV2KQogCQkgICBkZXZf
cHJpdi0+bWF4X2RlbGF5IDw8IDI0IHwKIAkJICAgZGV2X3ByaXYtPm1pbl9kZWxheSA8PCAxNik7
CiAKLQlpZiAoSVNfSEFTV0VMTChkZXYpKSB7Ci0JCUk5MTVfV1JJVEUoR0VONl9SUF9VUF9USFJF
U0hPTEQsIDU5NDAwKTsKLQkJSTkxNV9XUklURShHRU42X1JQX0RPV05fVEhSRVNIT0xELCAyNDUw
MDApOwotCQlJOTE1X1dSSVRFKEdFTjZfUlBfVVBfRUksIDY2MDAwKTsKLQkJSTkxNV9XUklURShH
RU42X1JQX0RPV05fRUksIDM1MDAwMCk7Ci0JfSBlbHNlIHsKLQkJSTkxNV9XUklURShHRU42X1JQ
X1VQX1RIUkVTSE9MRCwgMTAwMDApOwotCQlJOTE1X1dSSVRFKEdFTjZfUlBfRE9XTl9USFJFU0hP
TEQsIDEwMDAwMDApOwotCQlJOTE1X1dSSVRFKEdFTjZfUlBfVVBfRUksIDEwMDAwMCk7Ci0JCUk5
MTVfV1JJVEUoR0VONl9SUF9ET1dOX0VJLCA1MDAwMDAwKTsKLQl9CisJSTkxNV9XUklURShHRU42
X1JQX1VQX1RIUkVTSE9MRCwgNTk0MDApOworCUk5MTVfV1JJVEUoR0VONl9SUF9ET1dOX1RIUkVT
SE9MRCwgMjQ1MDAwKTsKKwlJOTE1X1dSSVRFKEdFTjZfUlBfVVBfRUksIDY2MDAwKTsKKwlJOTE1
X1dSSVRFKEdFTjZfUlBfRE9XTl9FSSwgMzUwMDAwKTsKIAogCUk5MTVfV1JJVEUoR0VONl9SUF9J
RExFX0hZU1RFUlNJUywgMTApOwogCUk5MTVfV1JJVEUoR0VONl9SUF9DT05UUk9MLAotLSAKMS43
LjkuNQoK
--f46d04016983e03d7e04c7c68bfe--
