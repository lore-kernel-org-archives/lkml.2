Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab1HHGip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 02:38:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51850 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1HHGin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 02:38:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAJn8CcF0+tU3PMwG2Rfn6L03coL-Z8-OU4KYY9LNf4joOuFkcQ@mail.gmail.com>
References: <20110805010038.GA18148@redhat.com>
	<20110805084614.GA1588@x4.trippels.de>
	<CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
	<alpine.DEB.2.00.1108051131440.28580@router.home>
	<20110805163948.GA11113@redhat.com>
	<alpine.DEB.2.00.1108051146180.28580@router.home>
	<20110805165119.GA11593@redhat.com>
	<alpine.DEB.2.00.1108051158400.28580@router.home>
	<20110805171607.GA11703@redhat.com>
	<alpine.DEB.2.00.1108051312090.28580@router.home>
	<20110805182008.GA22314@redhat.com>
	<CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com>
	<alpine.DEB.2.00.1108072155240.9480@tiger>
	<CA+55aFzdp+7+AcCFbx3dCkfqERzYvOZG3c3SUuNAw+X0MJ8iNw@mail.gmail.com>
	<alpine.DEB.2.00.1108080817050.25955@tiger>
	<CAJn8CcGqQwLPoweUN3fed2j0SorZO08NPpxeH70e+rogVsvhAw@mail.gmail.com>
	<CAOJsxLGyoJjaqsDN8CLVAMF+h72tepSpaouGJ2diQ=FpMiJqdg@mail.gmail.com>
	<CAJn8CcF0+tU3PMwG2Rfn6L03coL-Z8-OU4KYY9LNf4joOuFkcQ@mail.gmail.com>
Date: Mon, 8 Aug 2011 09:38:42 +0300
X-Google-Sender-Auth: 3V19ViwtkR32zrUMTMvHLKCPT_U
Message-ID: <CAOJsxLEUwPgVh4g7OXk_n8b=vcC5zdUWoOPdGvx5W8f12yd6kg@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
From: Pekka Enberg <penberg@kernel.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: multipart/mixed; boundary=bcaec5014c5bb87b8904a9f8b2df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec5014c5bb87b8904a9f8b2df
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 8, 2011 at 9:31 AM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> On Mon, Aug 8, 2011 at 2:18 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> On Mon, Aug 8, 2011 at 9:14 AM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>>> On Mon, Aug 8, 2011 at 1:18 PM, Pekka Enberg <penberg@kernel.org> wrote=
:
>>>> Hi Linus,
>>>>
>>>> On Sun, Aug 7, 2011 at 11:58 AM, Pekka Enberg <penberg@kernel.org> wro=
te:
>>>>>>
>>>>>> Christoph, I've been reading the code and spotted two potential issu=
es in
>>>>>> __slab_free(). The first one seems like an off-by-one where our
>>>>>> comparison
>>>>>> in deactivate_slab() doesn't match __slab_free.
>>>>>>
>>>>>> The other one is remove_full() call in __slab_free() that can get ca=
lled
>>>>>> even if cache debugging is not enabled.
>>>>>>
>>>>>> Hmm?
>>>>
>>>> On Sun, 7 Aug 2011, Linus Torvalds wrote:
>>>>>
>>>>> I'd like to do -rc1 today, regardless of whether this fixes things or
>>>>> not (-rc1 is already a few days delayed).
>>>>>
>>>>> The patch seems to be a good fix, and a likely candidate for the
>>>>> corruption. Commit log and sign-off? I assume you've given it some
>>>>> testing, even if you couldn't reproduce the original issue?
>>>>
>>>> No, I haven't tested the patch myself but here's one in proper format =
in
>>>> case someone wants to test it.
>>>
>>> I applied it and I'm still seeing the corruption warning start from thi=
s :(
>>>
>>> =A0[ 3674.255030] ------------[ cut here ]------------
>>> =A0[ 3674.255040] WARNING: at lib/list_debug.c:53 __list_del_entry+0xa1=
/0xd0()
>>> =A0[ 3674.255042] Hardware name: 42424XC
>>> =A0[ 3674.255045] list_del corruption. prev->next should be
>>> ffffea0000493420, but was ffffea0001ab0520
>>> =A0[ 3674.255047] Modules linked in: ip6table_filter ip6_tables
>>> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
>>> xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
>>> iptable_filter ip_tables x_tables binfmt_misc bridge stp parport_pc
>>> ppdev snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep
>>> snd_pcm thinkpad_acpi arc4 cryptd aes_x86_64 aes_generic snd_seq_midi
>>> i915 snd_rawmidi snd_seq_midi_event snd_seq joydev iwlagn btusb
>>> snd_timer snd_seq_device drm_kms_helper bluetooth uvcvideo snd
>>> videodev drm mac80211 cfg80211 i2c_algo_bit soundcore tpm_tis tpm
>>> tpm_bios lp snd_page_alloc psmouse serio_raw v4l2_compat_ioctl32 nvram
>>> video parport usbhid hid sdhci_pci firewire_ohci ahci libahci sdhci
>>> firewire_core crc_itu_t e1000e
>>> =A0[ 3674.255129] Pid: 3, comm: ksoftirqd/0 Not tainted 3.1.0-rc1+ #38
>>> =A0[ 3674.255131] Call Trace:
>>> =A0[ 3674.255138] =A0[<ffffffff8106db3f>] warn_slowpath_common+0x7f/0xc=
0
>>> =A0[ 3674.255143] =A0[<ffffffff8106dc36>] warn_slowpath_fmt+0x46/0x50
>>> =A0[ 3674.255147] =A0[<ffffffff81331851>] __list_del_entry+0xa1/0xd0
>>> =A0[ 3674.255151] =A0[<ffffffff81331891>] list_del+0x11/0x40
>>> =A0[ 3674.255156] =A0[<ffffffff81179631>] __slab_free+0x3d1/0x3e0
>>> =A0[ 3674.255162] =A0[<ffffffff811c5b06>] ? bvec_free_bs+0x26/0x40
>>> =A0[ 3674.255166] =A0[<ffffffff8117ab27>] ? kmem_cache_free+0x97/0x220
>>> =A0[ 3674.255170] =A0[<ffffffff811c5b06>] ? bvec_free_bs+0x26/0x40
>>> =A0[ 3674.255174] =A0[<ffffffff811c5b06>] ? bvec_free_bs+0x26/0x40
>>> =A0[ 3674.255179] =A0[<ffffffff8117ac9f>] kmem_cache_free+0x20f/0x220
>>
>> Can you please also run
>>
>> =A0addr2line -e vmlinux
>> =A00xffffffff81179631
>>
>
> /opt/upstream/linux-3.0/mm/slub.c:1061
>
>
> /*
> =A0* list_lock must be held.
> =A0*/
> static void remove_full(struct kmem_cache *s, struct page *page)
> {
> =A0 =A0 =A0 =A0if (!(s->flags & SLAB_STORE_USER))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> =A0 =A0 =A0 =A0list_del(&page->lru); =A0 =A0 =A0 <=3D=3D=3D here
> }

OK, so it's the full list. Looking at deactivate_slab() we actually
can access the list without n->list_lock held. Does the attached patch
help?

                        Pekka

--bcaec5014c5bb87b8904a9f8b2df
Content-Type: application/octet-stream; name="slub-full-list.patch"
Content-Disposition: attachment; filename="slub-full-list.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gr32kj0i0

ZGlmZiAtLWdpdCBhL21tL3NsdWIuYyBiL21tL3NsdWIuYwppbmRleCBlYjVhOGY5Li43NjkwN2Ux
IDEwMDY0NAotLS0gYS9tbS9zbHViLmMKKysrIGIvbW0vc2x1Yi5jCkBAIC0xODY3LDkgKzE4Njcs
MTAgQEAgcmVkbzoKIAkJCSAqLwogCQkJc3Bpbl9sb2NrKCZuLT5saXN0X2xvY2spOwogCQl9Ci0J
fSBlbHNlIHsKKwl9IGVsc2UgaWYgKGttZW1fY2FjaGVfZGVidWcocykpIHsKIAkJbSA9IE1fRlVM
TDsKLQkJaWYgKGttZW1fY2FjaGVfZGVidWcocykgJiYgIWxvY2spIHsKKworCQlpZiAoIWxvY2sp
IHsKIAkJCWxvY2sgPSAxOwogCQkJLyoKIAkJCSAqIFRoaXMgYWxzbyBlbnN1cmVzIHRoYXQgdGhl
IHNjYW5uaW5nIG9mIGZ1bGwKQEAgLTIzNzYsNyArMjM3Nyw4IEBAIHN0YXRpYyB2b2lkIF9fc2xh
Yl9mcmVlKHN0cnVjdCBrbWVtX2NhY2hlICpzLCBzdHJ1Y3QgcGFnZSAqcGFnZSwKIAkJICogdGhl
biBhZGQgaXQuCiAJCSAqLwogCQlpZiAodW5saWtlbHkoIXByaW9yKSkgewotCQkJcmVtb3ZlX2Z1
bGwocywgcGFnZSk7CisJCQlpZiAoa21lbV9jYWNoZV9kZWJ1ZyhzKSkKKwkJCQlyZW1vdmVfZnVs
bChzLCBwYWdlKTsKIAkJCWFkZF9wYXJ0aWFsKG4sIHBhZ2UsIDApOwogCQkJc3RhdChzLCBGUkVF
X0FERF9QQVJUSUFMKTsKIAkJfQo=
--bcaec5014c5bb87b8904a9f8b2df--
