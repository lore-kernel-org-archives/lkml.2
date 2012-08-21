Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2HUSwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:52:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50745 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2HUSwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:52:44 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120821183301.GG5156@phenom.ffwll.local>
References: <CA+icZUWg7qEFvAsTMb9OFKmdW7XD4op14Ps2y6PLByZRArjeLg@mail.gmail.com>
	<CA+icZUVjr6aaopVAhGRr13RLDy=epdnU30YTHOhjXmrWb2sAjA@mail.gmail.com>
	<CA+icZUXD+oWqTKB2b_xu8UEDnX6mSs_aELaGu9UQs_U4fHaKGQ@mail.gmail.com>
	<CAKMK7uFr972_aC8+HojLYe+Dsa0Abo0_qkLq8mbgSQs09sXihQ@mail.gmail.com>
	<CA+icZUVVjJ8wzJjM=Agw7xU65qgSekwW++wo_vNe_YELUT0bWA@mail.gmail.com>
	<CAKMK7uHfLOOWLfw6QJP4RQOoD3znOqZcY-qF-ry77z1seLWmBw@mail.gmail.com>
	<CA+icZUXGpTMgP7BX-RWHK=pKMu3x9z7UnHiDELDg94esW24FvA@mail.gmail.com>
	<20120821183301.GG5156@phenom.ffwll.local>
Date: Tue, 21 Aug 2012 20:52:41 +0200
Message-ID: <CA+icZUV6bavBYFB0ZMRK2v1dquu0tyhT7wtUu8NKd-dSNtHcog@mail.gmail.com>
Subject: Re: inux-next: Tree for Aug 21 (call-trace when suspending: PM?)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Content-Type: multipart/mixed; boundary=f46d04016a238e8f7b04c7cb218c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04016a238e8f7b04c7cb218c
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 21, 2012 at 8:33 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Aug 21, 2012 at 08:20:35PM +0200, Sedat Dilek wrote:
>> On Tue, Aug 21, 2012 at 6:39 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> > On Tue, Aug 21, 2012 at 3:24 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> >> On Tue, Aug 21, 2012 at 1:53 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> >>> On Tue, Aug 21, 2012 at 1:14 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> >>>> On Tue, Aug 21, 2012 at 1:03 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> >>>>> On Tue, Aug 21, 2012 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> >>>>>> On Tue, Aug 21, 2012 at 8:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >>>>>>> Hi all,
>> >>>>>>>
>> >>>>>>> Changes since 20120820:
>> >>>>>>>
>> >>>>>>> The rr tree gained a conflict against Linus' tree.
>> >>>>>>>
>> >>>>>>> The tip tree still has its build failure so I used the version from
>> >>>>>>> next-20120814.
>> >>>>>>>
>> >>>>>>> The workqueues tree gained a conflict against the hid tree.
>> >>>>>>>
>> >>>>>>> The drivers-x86 tree still has its build failure so I used the version
>> >>>>>>> from next-20120817.
>> >>>>>>>
>> >>>>>>> The signal tree gained a conflict against Linus' tree.  I have still
>> >>>>>>> reverted 3 commits from the signal tree at the request of the arm
>> >>>>>>> maintainer.
>> >>>>>>>
>> >>>>>>> ----------------------------------------------------------------------------
>> >>>>>>>
>> >>>>>>
>> >>>>>> Hi,
>> >>>>>>
>> >>>>>> I have compiled linux-next (next-20120821) and see the attached
>> >>>>>> call-trace when suspending.
>> >>>>>> Suspending did NOT work (Xorg seems to cause it) - machine came back to desktop.
>> >>>>>>
>> >>>>>> With yesterday's next-20120820 I haven't seen this.
>> >>>>>>
>> >>>>>> I am not sure what is this causing... PM, x86/sched or even VFS?
>> >>>>>> Any help for debugging appreciated.
>> >>>>>>
>> >>>>>> I am on Ubuntu/precise AMD64 and use systemd-v43 as init-system.
>> >>>>>>
>> >>>>>> Regards,
>> >>>>>> - Sedat -
>> >>>>>
>> >>>>> Forgot attachment!
>> >>>>> If you don't succeed - try try try...
>> >>>>>
>> >>>>> - Sedat -
>> >>>>
>> >>>> [ CC danvet ]
>> >>>>
>> >>>> I have pulled in drm-intel-fixes into my local GIT tree and rebuilt
>> >>>> i915 - this seems to fix the problem.
>> >>>> Daniel any suggestion which patch in d-i-f did it?
>> >>>
>> >>> Without the backtrace it's kinda hard to tell ... Also, if you can
>> >>> dump a git log of the commits from -fixes that you don't yet have.
>> >>> -Daniel
>> >>>
>> >>
>> >> Hi Daniel,
>> >>
>> >> $ git log --oneline v3.6.0-rc2-next20120821-1-iniza-generic..drm-intel-fixes
>> >> 1ee9ae3 drm/i915: use hsw rps tuning values everywhere on gen6+
>> >> f1a2f5b drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads
>> >> 4eab813 drm/i915: extract connector update from intel_ddc_get_modes() for reuse
>> >> a843af1 drm/i915: fix hsw uncached pte
>> >> b6c7488 drm/i915/contexts: fix list corruption
>> >> 38ab8a2 drm/i915: fix EDID memory leak in SDVO
>> >>
>> >> Looks like "1ee9ae3 drm/i915: use hsw rps tuning values everywhere on
>> >> gen6+" has PM fixes for i915.
>> >>
>> >> I tried with only that patch on top of today's linux-next - and I can
>> >> suspend/resume again!
>> >
>> > Well, this is slightly shocking - this patch /should/ only optimize
>> > power consumption, it should in now way fix suspend/resume (i.e. it
>> > doesn't even apply any h/w workaround). Do you have any more details
>> > what's going wrong here (logs, ...)?
>> >
>>
>> Forgot to CC you on my 1st emails.
>> [2] has the call-trace I have seen.
>>
>> - Sedat -
>>
>> [2] http://marc.info/?l=linux-next&m=134554704504603&w=2
>
> Hm, that smells more like a race, and changing the gpu turbo settins is
> known to rather massively move such races around (since this affects the
> power consumption and hence also max cpu turbo states, besides massively
> changing wakeup latency, since only when the gpu is in rc6 the entire
> cpu+gpu package can go into the lowest power state).
>
> I'd wager this thing will pop up again :(

I have re-installed the problematic kernel.
After 3 suspends I could twice resume successfully.

I have attached both kern-logs (1st reported call-trace, 2nd new one).

First was caused by Xorg and the 2nd by aptd.

$ sudo grep -A1 "Freezing of tasks failed after" /var/log/kern.log
Aug 21 12:53:18 fambox kernel: [ 2569.853137] Freezing of tasks failed
after 20.00 seconds (1 tasks refusing to freeze, wq_busy=0):
Aug 21 12:53:18 fambox kernel: [ 2569.853151] Xorg            D
0000000000000000     0   762    724 0x00400004
--
Aug 21 20:37:46 fambox kernel: [  125.031876] Freezing of tasks failed
after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
Aug 21 20:37:46 fambox kernel: [  125.031909] aptd            D
ffffffff8180cd00     0  2071      1 0x00000004

IIRC PM is now async?

- Sedat -

> -Daniel
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48

--f46d04016a238e8f7b04c7cb218c
Content-Type: text/plain; charset=US-ASCII; name="CALL-TRACE_kern-log_1.txt"
Content-Disposition: attachment; filename="CALL-TRACE_kern-log_1.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h65cny3s0

QXVnIDIxIDEyOjUyOjU1IGZhbWJveCBrZXJuZWw6IFsgMjU0Ny4wOTc1NjVdIHdsYW4wOiBkZWF1
dGhlbnRpY2F0aW5nIGZyb20gMDA6MDQ6MGU6ZTQ6MDA6M2QgYnkgbG9jYWwgY2hvaWNlIChyZWFz
b249MykKQXVnIDIxIDEyOjUyOjU1IGZhbWJveCBrZXJuZWw6IFsgMjU0Ny4xMDc1NjNdIGNmZzgw
MjExOiBBbGwgZGV2aWNlcyBhcmUgZGlzY29ubmVjdGVkLCBnb2luZyB0byByZXN0b3JlIHJlZ3Vs
YXRvcnkgc2V0dGluZ3MKQXVnIDIxIDEyOjUyOjU1IGZhbWJveCBrZXJuZWw6IFsgMjU0Ny4xMDc1
NjddIGNmZzgwMjExOiBSZXN0b3JpbmcgcmVndWxhdG9yeSBzZXR0aW5ncwpBdWcgMjEgMTI6NTI6
NTUgZmFtYm94IGtlcm5lbDogWyAyNTQ3LjEwNzU3Ml0gY2ZnODAyMTE6IENhbGxpbmcgQ1JEQSB0
byB1cGRhdGUgd29ybGQgcmVndWxhdG9yeSBkb21haW4KQXVnIDIxIDEyOjUyOjU1IGZhbWJveCBr
ZXJuZWw6IFsgMjU0Ny4xMTE4MDhdIGNmZzgwMjExOiBJZ25vcmluZyByZWd1bGF0b3J5IHJlcXVl
c3QgU2V0IGJ5IGNvcmUgc2luY2UgdGhlIGRyaXZlciB1c2VzIGl0cyBvd24gY3VzdG9tIHJlZ3Vs
YXRvcnkgZG9tYWluCkF1ZyAyMSAxMjo1Mjo1NSBmYW1ib3gga2VybmVsOiBbIDI1NDcuMTExODEx
XSBjZmc4MDIxMTogV29ybGQgcmVndWxhdG9yeSBkb21haW4gdXBkYXRlZDoKQXVnIDIxIDEyOjUy
OjU1IGZhbWJveCBrZXJuZWw6IFsgMjU0Ny4xMTE4MTNdIGNmZzgwMjExOiAgIChzdGFydF9mcmVx
IC0gZW5kX2ZyZXEgQCBiYW5kd2lkdGgpLCAobWF4X2FudGVubmFfZ2FpbiwgbWF4X2VpcnApCkF1
ZyAyMSAxMjo1Mjo1NSBmYW1ib3gga2VybmVsOiBbIDI1NDcuMTExODE0XSBjZmc4MDIxMTogICAo
MjQwMjAwMCBLSHogLSAyNDcyMDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1C
bSkKQXVnIDIxIDEyOjUyOjU1IGZhbWJveCBrZXJuZWw6IFsgMjU0Ny4xMTE4MTZdIGNmZzgwMjEx
OiAgICgyNDU3MDAwIEtIeiAtIDI0ODIwMDAgS0h6IEAgMjAwMDAgS0h6KSwgKDMwMCBtQmksIDIw
MDAgbUJtKQpBdWcgMjEgMTI6NTI6NTUgZmFtYm94IGtlcm5lbDogWyAyNTQ3LjExMTgxN10gY2Zn
ODAyMTE6ICAgKDI0NzQwMDAgS0h6IC0gMjQ5NDAwMCBLSHogQCAyMDAwMCBLSHopLCAoMzAwIG1C
aSwgMjAwMCBtQm0pCkF1ZyAyMSAxMjo1Mjo1NSBmYW1ib3gga2VybmVsOiBbIDI1NDcuMTExODE5
XSBjZmc4MDIxMTogICAoNTE3MDAwMCBLSHogLSA1MjUwMDAwIEtIeiBAIDQwMDAwIEtIeiksICgz
MDAgbUJpLCAyMDAwIG1CbSkKQXVnIDIxIDEyOjUyOjU1IGZhbWJveCBrZXJuZWw6IFsgMjU0Ny4x
MTE4MjBdIGNmZzgwMjExOiAgICg1NzM1MDAwIEtIeiAtIDU4MzUwMDAgS0h6IEAgNDAwMDAgS0h6
KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpBdWcgMjEgMTI6NTI6NTcgZmFtYm94IGtlcm5lbDogWyAy
NTQ5LjUxMjE1OV0gUE06IFN5bmNpbmcgZmlsZXN5c3RlbXMgLi4uIGRvbmUuCkF1ZyAyMSAxMjo1
Mjo1NyBmYW1ib3gga2VybmVsOiBbIDI1NDkuNTE0OTU1XSBQTTogUHJlcGFyaW5nIHN5c3RlbSBm
b3IgbWVtIHNsZWVwCkF1ZyAyMSAxMjo1MzoxOCBmYW1ib3gga2VybmVsOiBbIDI1NDkuODY2NjMw
XSBGcmVlemluZyB1c2VyIHNwYWNlIHByb2Nlc3NlcyAuLi4gCkF1ZyAyMSAxMjo1MzoxOCBmYW1i
b3gga2VybmVsOiBbIDI1NjkuODUzMTM3XSBGcmVlemluZyBvZiB0YXNrcyBmYWlsZWQgYWZ0ZXIg
MjAuMDAgc2Vjb25kcyAoMSB0YXNrcyByZWZ1c2luZyB0byBmcmVlemUsIHdxX2J1c3k9MCk6CkF1
ZyAyMSAxMjo1MzoxOCBmYW1ib3gga2VybmVsOiBbIDI1NjkuODUzMTUxXSBYb3JnICAgICAgICAg
ICAgRCAwMDAwMDAwMDAwMDAwMDAwICAgICAwICAgNzYyICAgIDcyNCAweDAwNDAwMDA0CkF1ZyAy
MSAxMjo1MzoxOCBmYW1ib3gga2VybmVsOiBbIDI1NjkuODUzMTU1XSAgZmZmZjg4MDEwMDQ2ZmFk
OCAwMDAwMDAwMDAwMDAwMDgyIDAwMDAwMDAwMDAwMjEzZGEgZmZmZmVhMDAwMzFiZDY4MApBdWcg
MjEgMTI6NTM6MTggZmFtYm94IGtlcm5lbDogWyAyNTY5Ljg1MzE1OF0gIGZmZmY4ODAxMTZhYmM0
NzAgZmZmZjg4MDEwMDQ2ZmZkOCBmZmZmODgwMTAwNDZmZmQ4IGZmZmY4ODAxMDA0NmZmZDgKQXVn
IDIxIDEyOjUzOjE4IGZhbWJveCBrZXJuZWw6IFsgMjU2OS44NTMxNjBdICBmZmZmODgwMTE2NDYx
NmQwIGZmZmY4ODAxMTZhYmM0NzAgZmZmZjg4MDEwMDQ2ZmFkOCBmZmZmODgwMTFmYTU0NmUwCkF1
ZyAyMSAxMjo1MzoxOCBmYW1ib3gga2VybmVsOiBbIDI1NjkuODUzMTYzXSBDYWxsIFRyYWNlOgpB
dWcgMjEgMTI6NTM6MTggZmFtYm94IGtlcm5lbDogWyAyNTY5Ljg1MzE3MF0gIFs8ZmZmZmZmZmY4
MTEyODY1MD5dID8gc2xlZXBfb25fcGFnZSsweDIwLzB4MjAKQXVnIDIxIDEyOjUzOjE4IGZhbWJv
eCBrZXJuZWw6IFsgMjU2OS44NTMxNzNdICBbPGZmZmZmZmZmODE2MzE5Njk+XSBzY2hlZHVsZSsw
eDI5LzB4NzAKQXVnIDIxIDEyOjUzOjE4IGZhbWJveCBrZXJuZWw6IFsgMjU2OS44NTMxNzVdICBb
PGZmZmZmZmZmODE2MzFhM2Y+XSBpb19zY2hlZHVsZSsweDhmLzB4ZDAKQXVnIDIxIDEyOjUzOjE4
IGZhbWJveCBrZXJuZWw6IFsgMjU2OS44NTMxNzhdICBbPGZmZmZmZmZmODExMjg2NWU+XSBzbGVl
cF9vbl9wYWdlX2tpbGxhYmxlKzB4ZS8weDQwCkF1ZyAyMSAxMjo1MzoxOCBmYW1ib3gga2VybmVs
OiBbIDI1NjkuODUzMTgwXSAgWzxmZmZmZmZmZjgxNjMwMjNmPl0gX193YWl0X29uX2JpdCsweDVm
LzB4OTAKQXVnIDIxIDEyOjUzOjE4IGZhbWJveCBrZXJuZWw6IFsgMjU2OS44NTMxODNdICBbPGZm
ZmZmZmZmODExMmFlMzA+XSB3YWl0X29uX3BhZ2VfYml0X2tpbGxhYmxlKzB4ODAvMHg5MApBdWcg
MjEgMTI6NTM6MTggZmFtYm94IGtlcm5lbDogWyAyNTY5Ljg1MzE4OF0gIFs8ZmZmZmZmZmY4MTA3
Yjg3MD5dID8gYXV0b3JlbW92ZV93YWtlX2Z1bmN0aW9uKzB4NDAvMHg0MApBdWcgMjEgMTI6NTM6
MTggZmFtYm94IGtlcm5lbDogWyAyNTY5Ljg1MzE5MF0gIFs8ZmZmZmZmZmY4MTEyYWVlNj5dIF9f
bG9ja19wYWdlX29yX3JldHJ5KzB4YTYvMHhkMApBdWcgMjEgMTI6NTM6MTggZmFtYm94IGtlcm5l
bDogWyAyNTY5Ljg1MzE5M10gIFs8ZmZmZmZmZmY4MTEyYjJiNz5dIGZpbGVtYXBfZmF1bHQrMHgz
YTcvMHg0ODAKQXVnIDIxIDEyOjUzOjE4IGZhbWJveCBrZXJuZWw6IFsgMjU2OS44NTMxOTddICBb
PGZmZmZmZmZmODExNGNmM2Y+XSBfX2RvX2ZhdWx0KzB4NmYvMHg1MDAKQXVnIDIxIDEyOjUzOjE4
IGZhbWJveCBrZXJuZWw6IFsgMjU2OS44NTMyMDBdICBbPGZmZmZmZmZmODExOTRkMzA+XSA/IF9f
cG9sbHdhaXQrMHhmMC8weGYwCkF1ZyAyMSAxMjo1MzoxOCBmYW1ib3gga2VybmVsOiBbIDI1Njku
ODUzMjAzXSAgWzxmZmZmZmZmZjgxMTUwMDA3Pl0gaGFuZGxlX3B0ZV9mYXVsdCsweGY3LzB4OWEw
CkF1ZyAyMSAxMjo1MzoxOCBmYW1ib3gga2VybmVsOiBbIDI1NjkuODUzMjIwXSAgWzxmZmZmZmZm
ZmEwMzFlMDQ1Pl0gPyBpOTE1X2dlbV9zZXRfZG9tYWluX2lvY3RsKzB4YzUvMHgxMDAgW2k5MTVd
CkF1ZyAyMSAxMjo1MzoxOCBmYW1ib3gga2VybmVsOiBbIDI1NjkuODUzMjMxXSAgWzxmZmZmZmZm
ZmEwMjJmMzhjPl0gPyBkcm1faW9jdGwrMHg0N2MvMHg1NDAgW2RybV0KQXVnIDIxIDEyOjUzOjE4
IGZhbWJveCBrZXJuZWw6IFsgMjU2OS44NTMyMzRdICBbPGZmZmZmZmZmODExNTFiMDk+XSBoYW5k
bGVfbW1fZmF1bHQrMHgyNTkvMHgzNDAKQXVnIDIxIDEyOjUzOjE4IGZhbWJveCBrZXJuZWw6IFsg
MjU2OS44NTMyMzhdICBbPGZmZmZmZmZmODE2MzY2ODI+XSBfX2RvX3BhZ2VfZmF1bHQrMHgxNTIv
MHg1MjAKQXVnIDIxIDEyOjUzOjE4IGZhbWJveCBrZXJuZWw6IFsgMjU2OS44NTMyNDBdICBbPGZm
ZmZmZmZmODExOTNkZjg+XSA/IGRvX3Zmc19pb2N0bCsweDk4LzB4NTUwCkF1ZyAyMSAxMjo1Mzox
OCBmYW1ib3gga2VybmVsOiBbIDI1NjkuODUzMjQzXSAgWzxmZmZmZmZmZjgxNjM2YTVlPl0gZG9f
cGFnZV9mYXVsdCsweGUvMHgxMApBdWcgMjEgMTI6NTM6MTggZmFtYm94IGtlcm5lbDogWyAyNTY5
Ljg1MzI0NV0gIFs8ZmZmZmZmZmY4MTYzMzBlNT5dIHBhZ2VfZmF1bHQrMHgyNS8weDMwCkF1ZyAy
MSAxMjo1MzoxOCBmYW1ib3gga2VybmVsOiBbIDI1NjkuODUzMjYzXSAKQXVnIDIxIDEyOjUzOjE4
IGZhbWJveCBrZXJuZWw6IFsgMjU2OS44NTMyNjRdIFJlc3RhcnRpbmcgdGFza3MgLi4uIGRvbmUu
CkF1ZyAyMSAxMjo1MzoxOCBmYW1ib3gga2VybmVsOiBbIDI1NjkuODU5NTg3XSB2aWRlbyBMTlhW
SURFTzowMDogUmVzdG9yaW5nIGJhY2tsaWdodCBzdGF0ZQpBdWcgMjEgMTI6NTM6MTkgZmFtYm94
IGtlcm5lbDogWyAyNTcwLjYyNjIzMF0gaXdsd2lmaSAwMDAwOjAxOjAwLjA6IEwxIEVuYWJsZWQ7
IERpc2FibGluZyBMMFMKQXVnIDIxIDEyOjUzOjE5IGZhbWJveCBrZXJuZWw6IFsgMjU3MC42MzI5
NjVdIGl3bHdpZmkgMDAwMDowMTowMC4wOiBSYWRpbyB0eXBlPTB4MS0weDItMHgwCkF1ZyAyMSAx
Mjo1MzoxOSBmYW1ib3gga2VybmVsOiBbIDI1NzAuNzQ5NDM4XSBJUHY2OiBBRERSQ09ORihORVRE
RVZfVVApOiB3bGFuMDogbGluayBpcyBub3QgcmVhZHkKQXVnIDIxIDEyOjUzOjE5IGZhbWJveCBr
ZXJuZWw6IFsgMjU3MC45OTY0MjZdIGNmZzgwMjExOiBGb3VuZCBuZXcgYmVhY29uIG9uIGZyZXF1
ZW5jeTogMjQ2NyBNSHogKENoIDEyKSBvbiBwaHkwCkF1ZyAyMSAxMjo1MzoyNSBmYW1ib3gga2Vy
bmVsOiBbIDI1NzcuMDY3MjIwXSB3bGFuMDogYXV0aGVudGljYXRlIHdpdGggMDA6MDQ6MGU6ZTQ6
MDA6M2QKQXVnIDIxIDEyOjUzOjI1IGZhbWJveCBrZXJuZWw6IFsgMjU3Ny4wNzY3MTddIHdsYW4w
OiBzZW5kIGF1dGggdG8gMDA6MDQ6MGU6ZTQ6MDA6M2QgKHRyeSAxLzMpCkF1ZyAyMSAxMjo1Mzoy
NSBmYW1ib3gga2VybmVsOiBbIDI1NzcuMDc4NjEyXSB3bGFuMDogYXV0aGVudGljYXRlZApBdWcg
MjEgMTI6NTM6MjUgZmFtYm94IGtlcm5lbDogWyAyNTc3LjA3OTEzOV0gaXdsd2lmaSAwMDAwOjAx
OjAwLjA6IHdsYW4wOiBkaXNhYmxpbmcgSFQgYXMgV01NL1FvUyBpcyBub3Qgc3VwcG9ydGVkIGJ5
IHRoZSBBUApBdWcgMjEgMTI6NTM6MjUgZmFtYm94IGtlcm5lbDogWyAyNTc3LjA3OTE0N10gaXds
d2lmaSAwMDAwOjAxOjAwLjA6IHdsYW4wOiBkaXNhYmxpbmcgVkhUIGFzIFdNTS9Rb1MgaXMgbm90
IHN1cHBvcnRlZCBieSB0aGUgQVAKQXVnIDIxIDEyOjUzOjI1IGZhbWJveCBrZXJuZWw6IFsgMjU3
Ny4wNzk4OTFdIHdsYW4wOiBhc3NvY2lhdGUgd2l0aCAwMDowNDowZTplNDowMDozZCAodHJ5IDEv
MykKQXVnIDIxIDEyOjUzOjI1IGZhbWJveCBrZXJuZWw6IFsgMjU3Ny4wODM4ODddIHdsYW4wOiBS
WCBBc3NvY1Jlc3AgZnJvbSAwMDowNDowZTplNDowMDozZCAoY2FwYWI9MHg0MTEgc3RhdHVzPTAg
YWlkPTIpCkF1ZyAyMSAxMjo1MzoyNSBmYW1ib3gga2VybmVsOiBbIDI1NzcuMDkwNzk2XSB3bGFu
MDogYXNzb2NpYXRlZApBdWcgMjEgMTI6NTM6MjUgZmFtYm94IGtlcm5lbDogWyAyNTc3LjA5MDg4
Nl0gSVB2NjogQUREUkNPTkYoTkVUREVWX0NIQU5HRSk6IHdsYW4wOiBsaW5rIGJlY29tZXMgcmVh
ZHkK
--f46d04016a238e8f7b04c7cb218c
Content-Type: text/plain; charset=US-ASCII; name="CALL-TRACE_kern-log_2.txt"
Content-Disposition: attachment; filename="CALL-TRACE_kern-log_2.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h65co0pe1

QXVnIDIxIDIwOjM3OjI0IGZhbWJveCBrZXJuZWw6IFsgIDEwMi4yNDI1MzBdIHdsYW4wOiBkZWF1
dGhlbnRpY2F0aW5nIGZyb20gMDA6MDQ6MGU6ZTQ6MDA6M2QgYnkgbG9jYWwgY2hvaWNlIChyZWFz
b249MykKQXVnIDIxIDIwOjM3OjI0IGZhbWJveCBrZXJuZWw6IFsgIDEwMi4yNTQxNzddIGNmZzgw
MjExOiBBbGwgZGV2aWNlcyBhcmUgZGlzY29ubmVjdGVkLCBnb2luZyB0byByZXN0b3JlIHJlZ3Vs
YXRvcnkgc2V0dGluZ3MKQXVnIDIxIDIwOjM3OjI0IGZhbWJveCBrZXJuZWw6IFsgIDEwMi4yNTQx
ODZdIGNmZzgwMjExOiBSZXN0b3JpbmcgcmVndWxhdG9yeSBzZXR0aW5ncwpBdWcgMjEgMjA6Mzc6
MjQgZmFtYm94IGtlcm5lbDogWyAgMTAyLjI1NDE5Nl0gY2ZnODAyMTE6IENhbGxpbmcgQ1JEQSB0
byB1cGRhdGUgd29ybGQgcmVndWxhdG9yeSBkb21haW4KQXVnIDIxIDIwOjM3OjI0IGZhbWJveCBr
ZXJuZWw6IFsgIDEwMi4yNjQxNjldIGNmZzgwMjExOiBJZ25vcmluZyByZWd1bGF0b3J5IHJlcXVl
c3QgU2V0IGJ5IGNvcmUgc2luY2UgdGhlIGRyaXZlciB1c2VzIGl0cyBvd24gY3VzdG9tIHJlZ3Vs
YXRvcnkgZG9tYWluCkF1ZyAyMSAyMDozNzoyNCBmYW1ib3gga2VybmVsOiBbICAxMDIuMjY0MTgw
XSBjZmc4MDIxMTogV29ybGQgcmVndWxhdG9yeSBkb21haW4gdXBkYXRlZDoKQXVnIDIxIDIwOjM3
OjI0IGZhbWJveCBrZXJuZWw6IFsgIDEwMi4yNjQxODVdIGNmZzgwMjExOiAgIChzdGFydF9mcmVx
IC0gZW5kX2ZyZXEgQCBiYW5kd2lkdGgpLCAobWF4X2FudGVubmFfZ2FpbiwgbWF4X2VpcnApCkF1
ZyAyMSAyMDozNzoyNCBmYW1ib3gga2VybmVsOiBbICAxMDIuMjY0MTkyXSBjZmc4MDIxMTogICAo
MjQwMjAwMCBLSHogLSAyNDcyMDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1C
bSkKQXVnIDIxIDIwOjM3OjI0IGZhbWJveCBrZXJuZWw6IFsgIDEwMi4yNjQxOTddIGNmZzgwMjEx
OiAgICgyNDU3MDAwIEtIeiAtIDI0ODIwMDAgS0h6IEAgMjAwMDAgS0h6KSwgKDMwMCBtQmksIDIw
MDAgbUJtKQpBdWcgMjEgMjA6Mzc6MjQgZmFtYm94IGtlcm5lbDogWyAgMTAyLjI2NDIwM10gY2Zn
ODAyMTE6ICAgKDI0NzQwMDAgS0h6IC0gMjQ5NDAwMCBLSHogQCAyMDAwMCBLSHopLCAoMzAwIG1C
aSwgMjAwMCBtQm0pCkF1ZyAyMSAyMDozNzoyNCBmYW1ib3gga2VybmVsOiBbICAxMDIuMjY0MjA4
XSBjZmc4MDIxMTogICAoNTE3MDAwMCBLSHogLSA1MjUwMDAwIEtIeiBAIDQwMDAwIEtIeiksICgz
MDAgbUJpLCAyMDAwIG1CbSkKQXVnIDIxIDIwOjM3OjI0IGZhbWJveCBrZXJuZWw6IFsgIDEwMi4y
NjQyMTNdIGNmZzgwMjExOiAgICg1NzM1MDAwIEtIeiAtIDU4MzUwMDAgS0h6IEAgNDAwMDAgS0h6
KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpBdWcgMjEgMjA6Mzc6MjYgZmFtYm94IGtlcm5lbDogWyAg
MTA0LjY5NjY1M10gUE06IFN5bmNpbmcgZmlsZXN5c3RlbXMgLi4uIGRvbmUuCkF1ZyAyMSAyMDoz
NzoyNiBmYW1ib3gga2VybmVsOiBbICAxMDQuNzAyMzU2XSBQTTogUHJlcGFyaW5nIHN5c3RlbSBm
b3IgbWVtIHNsZWVwCkF1ZyAyMSAyMDozNzo0NiBmYW1ib3gga2VybmVsOiBbICAxMDUuMDMyOTk1
XSBGcmVlemluZyB1c2VyIHNwYWNlIHByb2Nlc3NlcyAuLi4gCkF1ZyAyMSAyMDozNzo0NiBmYW1i
b3gga2VybmVsOiBbICAxMjUuMDMxODc2XSBGcmVlemluZyBvZiB0YXNrcyBmYWlsZWQgYWZ0ZXIg
MjAuMDEgc2Vjb25kcyAoMSB0YXNrcyByZWZ1c2luZyB0byBmcmVlemUsIHdxX2J1c3k9MCk6CkF1
ZyAyMSAyMDozNzo0NiBmYW1ib3gga2VybmVsOiBbICAxMjUuMDMxOTA5XSBhcHRkICAgICAgICAg
ICAgRCBmZmZmZmZmZjgxODBjZDAwICAgICAwICAyMDcxICAgICAgMSAweDAwMDAwMDA0CkF1ZyAy
MSAyMDozNzo0NiBmYW1ib3gga2VybmVsOiBbICAxMjUuMDMxOTEyXSAgZmZmZjg4MDA0YTA2MTU5
OCAwMDAwMDAwMDAwMDAwMDg2IDAwMDAwMDAwMDAwMDAwODIgZmZmZjg4MDA0YTA2MTU0OApBdWcg
MjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMTkxNV0gIGZmZmY4ODAwNTZhNDVi
NDAgZmZmZjg4MDA0YTA2MWZkOCBmZmZmODgwMDRhMDYxZmQ4IGZmZmY4ODAwNGEwNjFmZDgKQXVn
IDIxIDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzE5MThdICBmZmZmODgwMTFhYmI0
NDcwIGZmZmY4ODAwNTZhNDViNDAgZmZmZjg4MDA0YTA2MTU2OCBmZmZmODgwMTFmYWQ0NmUwCkF1
ZyAyMSAyMDozNzo0NiBmYW1ib3gga2VybmVsOiBbICAxMjUuMDMxOTIxXSBDYWxsIFRyYWNlOgpB
dWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMTkyOF0gIFs8ZmZmZmZmZmY4
MTFiMjVkMD5dID8gX193YWl0X29uX2J1ZmZlcisweDMwLzB4MzAKQXVnIDIxIDIwOjM3OjQ2IGZh
bWJveCBrZXJuZWw6IFsgIDEyNS4wMzE5MzFdICBbPGZmZmZmZmZmODE2MzE5Njk+XSBzY2hlZHVs
ZSsweDI5LzB4NzAKQXVnIDIxIDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzE5MzNd
ICBbPGZmZmZmZmZmODE2MzFhM2Y+XSBpb19zY2hlZHVsZSsweDhmLzB4ZDAKQXVnIDIxIDIwOjM3
OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzE5MzZdICBbPGZmZmZmZmZmODExYjI1ZGU+XSBz
bGVlcF9vbl9idWZmZXIrMHhlLzB4MjAKQXVnIDIxIDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsg
IDEyNS4wMzE5MzhdICBbPGZmZmZmZmZmODE2MzAyM2Y+XSBfX3dhaXRfb25fYml0KzB4NWYvMHg5
MApBdWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMTk0MV0gIFs8ZmZmZmZm
ZmY4MTJiMGQ2Nz5dID8gc3VibWl0X2JpbysweDg3LzB4MTEwCkF1ZyAyMSAyMDozNzo0NiBmYW1i
b3gga2VybmVsOiBbICAxMjUuMDMxOTQzXSAgWzxmZmZmZmZmZjgxMWIyNWQwPl0gPyBfX3dhaXRf
b25fYnVmZmVyKzB4MzAvMHgzMApBdWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1
LjAzMTk0NV0gIFs8ZmZmZmZmZmY4MTYzMDJlYz5dIG91dF9vZl9saW5lX3dhaXRfb25fYml0KzB4
N2MvMHg5MApBdWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMTk1MF0gIFs8
ZmZmZmZmZmY4MTA3Yjg3MD5dID8gYXV0b3JlbW92ZV93YWtlX2Z1bmN0aW9uKzB4NDAvMHg0MApB
dWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMTk1M10gIFs8ZmZmZmZmZmY4
MTFiMjVjZT5dIF9fd2FpdF9vbl9idWZmZXIrMHgyZS8weDMwCkF1ZyAyMSAyMDozNzo0NiBmYW1i
b3gga2VybmVsOiBbICAxMjUuMDMxOTcxXSAgWzxmZmZmZmZmZmEwMDY4NjI4Pl0gZXh0NF93YWl0
X2Jsb2NrX2JpdG1hcCsweGM4LzB4ZDAgW2V4dDRdCkF1ZyAyMSAyMDozNzo0NiBmYW1ib3gga2Vy
bmVsOiBbICAxMjUuMDMxOTgzXSAgWzxmZmZmZmZmZmEwMGEyOWRlPl0gZXh0NF9tYl9pbml0X2Nh
Y2hlKzB4MWRlLzB4NzEwIFtleHQ0XQpBdWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAg
MTI1LjAzMTk4Nl0gIFs8ZmZmZmZmZmY4MTEyOTUwYz5dID8gYWRkX3RvX3BhZ2VfY2FjaGVfbG9j
a2VkKzB4YWMvMHhmMApBdWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMTk4
OV0gIFs8ZmZmZmZmZmY4MTEyOTU4NT5dID8gYWRkX3RvX3BhZ2VfY2FjaGVfbHJ1KzB4MzUvMHg1
MApBdWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMTk5OF0gIFs8ZmZmZmZm
ZmZhMDBhMzA1ZT5dIGV4dDRfbWJfaW5pdF9ncm91cCsweDE0ZS8weDIwMCBbZXh0NF0KQXVnIDIx
IDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzIwMDZdICBbPGZmZmZmZmZmYTAwYTMy
NjA+XSBleHQ0X21iX2dvb2RfZ3JvdXArMHgxNTAvMHgxNjAgW2V4dDRdCkF1ZyAyMSAyMDozNzo0
NiBmYW1ib3gga2VybmVsOiBbICAxMjUuMDMyMDE0XSAgWzxmZmZmZmZmZmEwMGE1MmQ5Pl0gZXh0
NF9tYl9yZWd1bGFyX2FsbG9jYXRvcisweDFhOS8weDQzMCBbZXh0NF0KQXVnIDIxIDIwOjM3OjQ2
IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzIwMjJdICBbPGZmZmZmZmZmYTAwYTZlZWQ+XSBleHQ0
X21iX25ld19ibG9ja3MrMHg0MGQvMHg1NjAgW2V4dDRdCkF1ZyAyMSAyMDozNzo0NiBmYW1ib3gg
a2VybmVsOiBbICAxMjUuMDMyMDI0XSAgWzxmZmZmZmZmZjgxNjMyODRlPl0gPyBfcmF3X3NwaW5f
bG9jaysweGUvMHgyMApBdWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMjAz
M10gIFs8ZmZmZmZmZmZhMDA5OGEwZT5dID8gZXh0NF9leHRfcHV0X2luX2NhY2hlKzB4NmUvMHhm
MCBbZXh0NF0KQXVnIDIxIDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzIwNDFdICBb
PGZmZmZmZmZmYTAwOWQyMTg+XSBleHQ0X2V4dF9tYXBfYmxvY2tzKzB4ZTI4LzB4MWM4MCBbZXh0
NF0KQXVnIDIxIDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzIwNDldICBbPGZmZmZm
ZmZmYTAwNzY0Mzg+XSA/IGV4dDRfaW9fc3VibWl0KzB4MzgvMHg2MCBbZXh0NF0KQXVnIDIxIDIw
OjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzIwNTZdICBbPGZmZmZmZmZmYTAwNzAwOTU+
XSBleHQ0X21hcF9ibG9ja3MrMHgxZjUvMHgyYzAgW2V4dDRdCkF1ZyAyMSAyMDozNzo0NiBmYW1i
b3gga2VybmVsOiBbICAxMjUuMDMyMDY0XSAgWzxmZmZmZmZmZmEwMDc0MzM2Pl0gbXBhZ2VfZGFf
bWFwX2FuZF9zdWJtaXQrMHhiNi8weDQ4MCBbZXh0NF0KQXVnIDIxIDIwOjM3OjQ2IGZhbWJveCBr
ZXJuZWw6IFsgIDEyNS4wMzIwNjZdICBbPGZmZmZmZmZmODExMjkyYWI+XSA/IGZpbmRfZ2V0X3Bh
Z2VzX3RhZysweGNiLzB4MTcwCkF1ZyAyMSAyMDozNzo0NiBmYW1ib3gga2VybmVsOiBbICAxMjUu
MDMyMDczXSAgWzxmZmZmZmZmZmEwMDc0NzYwPl0gbXBhZ2VfYWRkX2JoX3RvX2V4dGVudCsweDYw
LzB4ZTAgW2V4dDRdCkF1ZyAyMSAyMDozNzo0NiBmYW1ib3gga2VybmVsOiBbICAxMjUuMDMyMDgw
XSAgWzxmZmZmZmZmZmEwMDc0YWUxPl0gd3JpdGVfY2FjaGVfcGFnZXNfZGErMHgzMDEvMHg0NTAg
W2V4dDRdCkF1ZyAyMSAyMDozNzo0NiBmYW1ib3gga2VybmVsOiBbICAxMjUuMDMyMDg4XSAgWzxm
ZmZmZmZmZmEwMDc0ZjgwPl0gZXh0NF9kYV93cml0ZXBhZ2VzKzB4MzUwLzB4NjIwIFtleHQ0XQpB
dWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMjA5MV0gIFs8ZmZmZmZmZmY4
MTEzNGFmMD5dIGRvX3dyaXRlcGFnZXMrMHgyMC8weDQwCkF1ZyAyMSAyMDozNzo0NiBmYW1ib3gg
a2VybmVsOiBbICAxMjUuMDMyMDkzXSAgWzxmZmZmZmZmZjgxMTI5ZjA5Pl0gX19maWxlbWFwX2Zk
YXRhd3JpdGVfcmFuZ2UrMHg1OS8weDYwCkF1ZyAyMSAyMDozNzo0NiBmYW1ib3gga2VybmVsOiBb
ICAxMjUuMDMyMDk2XSAgWzxmZmZmZmZmZjgxMTI5ZjYyPl0gZmlsZW1hcF93cml0ZV9hbmRfd2Fp
dF9yYW5nZSsweDUyLzB4ODAKQXVnIDIxIDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4w
MzIxMDNdICBbPGZmZmZmZmZmYTAwNmFlNWY+XSBleHQ0X3N5bmNfZmlsZSsweDZmLzB4M2QwIFtl
eHQ0XQpBdWcgMjEgMjA6Mzc6NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMjEwNl0gIFs8ZmZm
ZmZmZmY4MTFiMDFmYj5dIHZmc19mc3luYysweDJiLzB4NDAKQXVnIDIxIDIwOjM3OjQ2IGZhbWJv
eCBrZXJuZWw6IFsgIDEyNS4wMzIxMDhdICBbPGZmZmZmZmZmODExNTk0ZTQ+XSBzeXNfbXN5bmMr
MHgxNDQvMHgxZDAKQXVnIDIxIDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzIxMTFd
ICBbPGZmZmZmZmZmODE2M2FkNjk+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWIKQXVn
IDIxIDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wMzIxMTNdIApBdWcgMjEgMjA6Mzc6
NDYgZmFtYm94IGtlcm5lbDogWyAgMTI1LjAzMjExM10gUmVzdGFydGluZyB0YXNrcyAuLi4gZG9u
ZS4KQXVnIDIxIDIwOjM3OjQ2IGZhbWJveCBrZXJuZWw6IFsgIDEyNS4wNDEwNjJdIHZpZGVvIExO
WFZJREVPOjAwOiBSZXN0b3JpbmcgYmFja2xpZ2h0IHN0YXRlCkF1ZyAyMSAyMDozNzo0NyBmYW1i
b3gga2VybmVsOiBbICAxMjUuOTg5NTQ4XSBpd2x3aWZpIDAwMDA6MDE6MDAuMDogTDEgRW5hYmxl
ZDsgRGlzYWJsaW5nIEwwUwpBdWcgMjEgMjA6Mzc6NDcgZmFtYm94IGtlcm5lbDogWyAgMTI1Ljk5
NjM1OF0gaXdsd2lmaSAwMDAwOjAxOjAwLjA6IFJhZGlvIHR5cGU9MHgxLTB4Mi0weDAKQXVnIDIx
IDIwOjM3OjQ3IGZhbWJveCBrZXJuZWw6IFsgIDEyNi4xMTA1NjNdIElQdjY6IEFERFJDT05GKE5F
VERFVl9VUCk6IHdsYW4wOiBsaW5rIGlzIG5vdCByZWFkeQpBdWcgMjEgMjA6Mzc6NDggZmFtYm94
IGtlcm5lbDogWyAgMTI2LjM0NTUxNF0gY2ZnODAyMTE6IEZvdW5kIG5ldyBiZWFjb24gb24gZnJl
cXVlbmN5OiAyNDY3IE1IeiAoQ2ggMTIpIG9uIHBoeTAKQXVnIDIxIDIwOjM3OjUxIGZhbWJveCBr
ZXJuZWw6IFsgIDEyOS42MjM2MzVdIGNmZzgwMjExOiBGb3VuZCBuZXcgYmVhY29uIG9uIGZyZXF1
ZW5jeTogMjQ3MiBNSHogKENoIDEzKSBvbiBwaHkwCkF1ZyAyMSAyMDozNzo1NCBmYW1ib3gga2Vy
bmVsOiBbICAxMzIuMzk3ODA3XSB3bGFuMDogYXV0aGVudGljYXRlIHdpdGggMDA6MDQ6MGU6ZTQ6
MDA6M2QKQXVnIDIxIDIwOjM3OjU0IGZhbWJveCBrZXJuZWw6IFsgIDEzMi40MDU1NjVdIHdsYW4w
OiBzZW5kIGF1dGggdG8gMDA6MDQ6MGU6ZTQ6MDA6M2QgKHRyeSAxLzMpCkF1ZyAyMSAyMDozNzo1
NCBmYW1ib3gga2VybmVsOiBbICAxMzIuNDA3MzU3XSB3bGFuMDogYXV0aGVudGljYXRlZApBdWcg
MjEgMjA6Mzc6NTQgZmFtYm94IGtlcm5lbDogWyAgMTMyLjQwNzU1NV0gaXdsd2lmaSAwMDAwOjAx
OjAwLjA6IHdsYW4wOiBkaXNhYmxpbmcgSFQgYXMgV01NL1FvUyBpcyBub3Qgc3VwcG9ydGVkIGJ5
IHRoZSBBUApBdWcgMjEgMjA6Mzc6NTQgZmFtYm94IGtlcm5lbDogWyAgMTMyLjQwNzU2MF0gaXds
d2lmaSAwMDAwOjAxOjAwLjA6IHdsYW4wOiBkaXNhYmxpbmcgVkhUIGFzIFdNTS9Rb1MgaXMgbm90
IHN1cHBvcnRlZCBieSB0aGUgQVAKQXVnIDIxIDIwOjM3OjU0IGZhbWJveCBrZXJuZWw6IFsgIDEz
Mi40MTA1MTddIHdsYW4wOiBhc3NvY2lhdGUgd2l0aCAwMDowNDowZTplNDowMDozZCAodHJ5IDEv
MykKQXVnIDIxIDIwOjM3OjU0IGZhbWJveCBrZXJuZWw6IFsgIDEzMi40MTQzMzRdIHdsYW4wOiBS
WCBBc3NvY1Jlc3AgZnJvbSAwMDowNDowZTplNDowMDozZCAoY2FwYWI9MHg0MTEgc3RhdHVzPTAg
YWlkPTIpCkF1ZyAyMSAyMDozNzo1NCBmYW1ib3gga2VybmVsOiBbICAxMzIuNDE4NDQ5XSB3bGFu
MDogYXNzb2NpYXRlZApBdWcgMjEgMjA6Mzc6NTQgZmFtYm94IGtlcm5lbDogWyAgMTMyLjQxODQ4
OV0gSVB2NjogQUREUkNPTkYoTkVUREVWX0NIQU5HRSk6IHdsYW4wOiBsaW5rIGJlY29tZXMgcmVh
ZHkK
--f46d04016a238e8f7b04c7cb218c--
