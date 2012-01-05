Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab2AEPaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:30:19 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40273 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2AEPaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:30:17 -0500
MIME-Version: 1.0
In-Reply-To: <NEXT-4f054a51a74772.60877329@nextmail.ru>
References: <NEXT-4f054a51a74772.60877329@nextmail.ru>
Date: Thu, 5 Jan 2012 21:00:15 +0530
Message-ID: <CAD2nsn2KMYMP+JNHpNi0QTqp-U_YO2p4M5stp4L9aVm3SawnVA@mail.gmail.com>
Subject: Re: ath9k crash 3.2-rc7
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: MR <g7af0ec1e3ea1e7b1@nextmail.ru>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec54ee964ecbba804b5c99b0d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec54ee964ecbba804b5c99b0d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2012/1/5 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
> =A0> Hi John,
>
> I am the stupid original submitter who only sent this to linux-kernel
> initially.

:) no problem. i hope for you can recreate the issue consistently ,
can you please test with the attached patch and another debug patch.
please let me know if there is no panic but there are warnings (or) if
there are no warnings (or) the issue still appears(also the trace
thanks) , also if you need any help
let me also start the overnight wifi traffic in 3.2-rc7


>
> =A0> we will take a look at this.
> =A0>
> =A0> i can later come up with few debug patches to narrow down the panic.
> =A0> looks like a problem in ath_update_survey_stats(survey pointer). ful=
l
> =A0> stack trace will be helpful
> =A0> thanks.
>
> What I have posted is the full call trace. Right above this is the stack
> trace in hex:
>
> Process kworker/u:2 (pid: 6668, threadinfo ffff880027cd4000, task
> ffff880076a38000)
> Stack:
> =A0ffff880027cd5808 ffffffff81064830 ffff880027cd5808 ffff880147c51c80
> =A0ffff880027cd58b8 ffffffff8135a117 ffff880076a38620 0000000000011c80
> =A00000000000011c80 ffff880076a38000 0000000000011c80 ffff880027cd5fd8
>
> Currently I have booted Linux 3.0 kernel to check whether the problem is
> already there. Unfortunately, with Linux 3.1 and 3.0 I often get the
> following in dmesg (this is at module load; sometimes the driver just sto=
ps
> working - then I get this on reloading the module):
>
> ath9k 0000:03:00.0: enabling device (0000 -> 0002)
> ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> ath9k 0000:03:00.0: setting latency timer to 64
> ath9k 0000:03:00.0: Failed to initialize device
> ath9k 0000:03:00.0: PCI INT A disabled
> ath9k: probe of 0000:03:00.0 failed with error -5
>
> As far as I understood, some similar problem was fixed after Linux 3.1.
>
> =A0> >> My card is (as lspci says):
> =A0> >>
> =A0> >> 03:00.0 Network controller: Atheros Communications Inc. AR9285
> Wireless
> =A0> >> Network Adapter (PCI-Express) (rev 01)
> =A0> >> =A0 =A0 =A0 =A0 Subsystem: Device 1a3b:1089
>
> =A0> >> wq_worker_sleeping+0x10/0xa0
> =A0> >> __schedule+0x427/0x7b0
> =A0> >> ? call_rcu_sched+0x10/0x20
> =A0> >> schedule+0x3a/0x50
> =A0> >> do_exit+0x57c/0x840
> =A0> >> ? kmsg_dump+0x45/0xe0
> =A0> >> oops_end+0xa5/0xf0
> =A0> >> no_context+0xf2/0x270
> =A0> >> __bad_area_no_semaphore+0xe/0x10
> =A0> >> do_page_fault+0x2ba/0x450
> =A0> >> ? up+0x2d/0x50
> =A0> >> ? console_unlock+0x1df/0x250
> =A0> >> ? select_task_rq_fair+0x5be/0x970
> =A0> >> page_fault+0x25/0x30
> =A0> >> ? ath_update_survey_stats+0xb7/0x1c0 [ath9k]
> =A0> >> ath9k_config+0x115/0x780 [ath9k]
> =A0> >> ? queue_work+0x1a/0x20
> =A0> >> ? queue_delayed_work+0x25/0x30
> =A0> >> ? ieee80211_queue_delayed_work+0x46/0x60 [mac80211]
> =A0> >> ? ath9k_flush+0x155/0x1d0 [ath9k]
> =A0> >> ieee80211_hw_config+0xe2/0x160 [mac80211]
> =A0> >> ieee80211_scan_work+0x243/0x5c0 [mac80211]
> =A0> >> ? ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
> =A0> >> process_one_work+0x111/0x390
> =A0> >> worker_thread+0x162/0x340
> =A0> >> manage_workers.clone.26+0x240/0x240
> =A0> >> kthread+0x96/0xa0
> =A0> >> kernel_thread_helper+0x4/0x10
> =A0> >> ? kthread_worker_fn+0x190/0x190
> =A0> >> ? gs_change+0x13/0x13
>
>



--=20
shafi

--bcaec54ee964ecbba804b5c99b0d
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-mac80211-fix-scan-state-machine.patch"
Content-Disposition: attachment; 
	filename="0001-mac80211-fix-scan-state-machine.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx1xlz540

RnJvbSA1MDlhMTQxZTE0Zjc5NGRlOGZiZmU4NDdhM2RlNTQ4YWNlMjFkN2VjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNb2hhbW1lZCBTaGFmaSBTaGFqYWtoYW4gPG1vaGFtbWVkQHFj
YS5xdWFsY29tbS5jb20+CkRhdGU6IFdlZCwgMjEgRGVjIDIwMTEgMjA6MTE6MzUgKzA1MzAKU3Vi
amVjdDogW1BBVENIIHYyXSBtYWM4MDIxMTogZml4IHNjYW4gc3RhdGUgbWFjaGluZQoKd2hlbiB3
ZSBydW4gaGlnaCBiYW5kd2lkdGggVURQIHRyYWZmaWMgYW5kIHdlIHRyaWdnZXIgYSBzY2FuLCB0
aGUgc2NhbgpzdGF0ZSBtYWNoaW5lIHNlZW1zIHRvIGJlIGxvb3BpbmcgaW4gU1VTUEVORC0+UkVT
VU1FLT5ERUNJU0lPTi0+U1VTUEVORAphbmQgU0VUX0NIQU5ORUwgc2VlbXMgdG8gYmUgbmV2ZXIg
Y2FsbGVkIGFzICd0eF9lbXB0eScgaXMgbmV2ZXIgdHJ1ZQp3aGlsZSBydW5uaW5nIFVEUCB0cmFm
ZmljLiBmaXggdGhpcyBieSBzZXR0dGluZyBTRVRfQ0hBTk5FTCBzdGF0ZSB3aGVuCndlIGdldCBp
bnRvIFJFU1VNRSBzdGF0ZS4KCkNjOiBMZWVsYSBLZWxsYSA8bGVlbGFAcWNhLnF1YWxjb21tLmNv
bT4KU2lnbmVkLW9mZi1ieTogTW9oYW1tZWQgU2hhZmkgU2hhamFraGFuIDxtb2hhbW1lZEBxY2Eu
cXVhbGNvbW0uY29tPgotLS0KIG5ldC9tYWM4MDIxMS9zY2FuLmMgfCAgICAyICstCiAxIGZpbGVz
IGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9u
ZXQvbWFjODAyMTEvc2Nhbi5jIGIvbmV0L21hYzgwMjExL3NjYW4uYwppbmRleCAyYzUwNDFjLi4y
OTA4ZTU2IDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEvc2Nhbi5jCisrKyBiL25ldC9tYWM4MDIx
MS9zY2FuLmMKQEAgLTYyNSw3ICs2MjUsNyBAQCBzdGF0aWMgdm9pZCBpZWVlODAyMTFfc2Nhbl9z
dGF0ZV9yZXN1bWUoc3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9jYWwsCiAJbG9jYWwtPmxlYXZl
X29wZXJfY2hhbm5lbF90aW1lID0gamlmZmllczsKIAogCS8qIGFkdmFuY2UgdG8gdGhlIG5leHQg
Y2hhbm5lbCB0byBiZSBzY2FubmVkICovCi0JbG9jYWwtPm5leHRfc2Nhbl9zdGF0ZSA9IFNDQU5f
REVDSVNJT047CisJbG9jYWwtPm5leHRfc2Nhbl9zdGF0ZSA9IFNDQU5fU0VUX0NIQU5ORUw7CiB9
CiAKIHZvaWQgaWVlZTgwMjExX3NjYW5fd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCi0t
IAoxLjcuMC40Cgo=
--bcaec54ee964ecbba804b5c99b0d
Content-Type: text/x-diff; charset=US-ASCII; name="survey-debug.patch"
Content-Disposition: attachment; filename="survey-debug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx1xm6ce1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWluLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvbWFpbi5jCmluZGV4IDZlM2Q4MzguLjRmOGM5MDUg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWluLmMKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL21haW4uYwpAQCAtMTkwLDYgKzE5MCwxOSBA
QCBzdGF0aWMgaW50IGF0aF91cGRhdGVfc3VydmV5X3N0YXRzKHN0cnVjdCBhdGhfc29mdGMgKnNj
KQogCWlmICghYWgtPmN1cmNoYW4pCiAJCXJldHVybiAtMTsKIAorCS8qIGp1c3QgdG8gbWFrZSBw
b3MgZG9lcyBub3QgZXhjZWVkcyBBVEg5S19OVU1fQ0hBTk5FTFMgLSAxICovCisJaWYgKHBvcyA+
IDM3KSB7CisJCVdBUk5fT04oMSk7CisJCXByaW50aygiXG5wb3MgaXMgJWQgaW5kZXggb3V0IG9m
IGJvdW5kcyEhISBpbiAlcyIsIHBvcywgX19mdW5jX18pOworCQlyZXR1cm4gLTE7CisJfQorCisJ
aWYgKCFzdXJ2ZXkpIHsKKwkJV0FSTl9PTigxKTsKKwkJcHJpbnRrKCJcbk5VTEwgcG9pbnRlciBm
b3Igc3VydmV5ICEhISBpbiAlcyIsIF9fZnVuY19fKTsKKwkJcmV0dXJuIC0xOworCX0KKwogCWlm
IChhaC0+cG93ZXJfbW9kZSA9PSBBVEg5S19QTV9BV0FLRSkKIAkJYXRoX2h3X2N5Y2xlX2NvdW50
ZXJzX3VwZGF0ZShjb21tb24pOwogCg==
--bcaec54ee964ecbba804b5c99b0d--
