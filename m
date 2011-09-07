Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1IGVLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:11:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56503 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab1IGVLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110907205856.GB21603@hostway.ca>
References: <20110906173605.GA12577@hostway.ca>
	<87aaag9vb8.fsf@begreifnix.stackframe.org>
	<CA+5PVA5aEAgdKexWK_cg2zRJk5CFsg6rhp9Wx+80GjR7iaLkOA@mail.gmail.com>
	<20110907104432.2f9d8b0a@jbarnes-x220>
	<20110907191859.GB14950@hostway.ca>
	<20110907204754.GA21603@hostway.ca>
	<CAMaF-rOrA==mN-BaPVr8SB14XgXZWd0wMb0WP=-Xqzf7-w73Ag@mail.gmail.com>
	<20110907205856.GB21603@hostway.ca>
Date: Wed, 7 Sep 2011 14:10:59 -0700
Message-ID: <CAMaF-rOZ28UdUUMPjL_4v-_Tqk26otyhzVAmjvRXyE0tqc8odg@mail.gmail.com>
Subject: Re: [3.1-rc4] Bus Fatal Error caused by "PCI: Set PCI-E Max Payload
 Size on fabric"
From: Jon Mason <mason@myri.com>
To: Simon Kirby <sim@hostway.ca>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Josh Boyer <jwboyer@gmail.com>,
        Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org,
        Jordan_Hargrave@dell.com
Content-Type: multipart/mixed; boundary=001636ed65fd84a35b04ac60611b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636ed65fd84a35b04ac60611b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 7, 2011 at 1:58 PM, Simon Kirby <sim@hostway.ca> wrote:
> On Wed, Sep 07, 2011 at 01:57:28PM -0700, Jon Mason wrote:
>
>> On Wed, Sep 7, 2011 at 1:47 PM, Simon Kirby <sim@hostway.ca> wrote:
>> > On Wed, Sep 07, 2011 at 12:18:59PM -0700, Simon Kirby wrote:
>> >
>> >> On Wed, Sep 07, 2011 at 10:44:32AM -0700, Jesse Barnes wrote:
>> >>
>> >> > On Wed, 7 Sep 2011 12:52:25 -0400
>> >> > Josh Boyer <jwboyer@gmail.com> wrote:
>> >> >
>> >> > > On Wed, Sep 7, 2011 at 12:22 PM, Sven Schnelle <svens@stackframe.=
org>
>> >> > > wrote:
>> >> > > > Simon Kirby <sim@hostway.ca> writes:
>> >> > > >
>> >> > > >> Hello!
>> >> > > >>
>> >> > > >> Since trying 3.1-rc4 on a few Dell servers, all of them have
>> >> > > >> booted up with the amber error LED lit. "ipmitool sel list" sh=
ows:
>> >> > > >>
>> >> > > >> ?? ??1 | 09/06/2011 | 17:21:56 | Event Logging Disabled #0x72 =
| Log
>> >> > > >> area reset/cleared | Asserted 2 | 09/06/2011 | 17:25:38 | Crit=
ical
>> >> > > >> Interrupt #0x18 | Bus Fatal Error | Asserted 3 | 09/06/2011 |
>> >> > > >> 17:25:38 | Unknown #0x1a | 4 | 09/06/2011 | 17:25:38 | Unknown
>> >> > > >> #0x1a |
>> >> > > >
>> >> > > > I'm seeing exact the same issue on a Dell 1950 Server. If anyon=
e
>> >> > > > wants me to try additional debugging/patches, feel free to do
>> >> > > > so. Unfortunately i don't have the time/knowledge to debug that=
 by
>> >> > > > myself.
>> >> > >
>> >> > > I thought Jesse or Jon had a revert or partial fix queued up to s=
end
>> >> > > to Linus, but I don't see anything in or post -rc5 yet. ?That was
>> >> > > indicated in https://bugzilla.kernel.org/show_bug.cgi?id=3D42162
>> >> > >
>> >> > > Jesse, Jon?
>> >> >
>> >> > kernel.org is still down and I haven't pushed anything to github. ?=
I
>> >> > asked Jon to send his patch directly to Linus today instead.
>> >>
>> >> FWIW, this patch didn't seem to fix it:
>> >> https://bugzilla.kernel.org/attachment.cgi?id=3D71222
>> >>
>> >> dmesg used to say:
>> >>
>> >> pci 0000:00:02.0: Dev MPS 128 MPSS 256 MRRS 128
>> >> pci 0000:00:02.0: Dev MPS 256 MPSS 256 MRRS 128
>> >> pci 0000:06:00.0: Dev MPS 128 MPSS 256 MRRS 4096
>> >> pci 0000:06:00.0: Dev MPS 256 MPSS 256 MRRS 128
>> >> pci 0000:07:00.0: Dev MPS 128 MPSS 256 MRRS 4096
>> >> pci 0000:07:00.0: Dev MPS 256 MPSS 256 MRRS 128
>> >> pci 0000:08:00.0: Dev MPS 128 MPSS 128 MRRS 128
>> >> pci 0000:08:00.0: MPS configured higher than maximum supported by the=
 device. ?If a bus issue occurs, try running with pci=3Dpcie_bus_safe.
>> >> pci 0000:08:00.0: Dev MPS 256 MPSS 256 MRRS 128
>> >> Uhhuh. NMI received for unknown reason 21 on CPU 0.
>> >> Do you have a strange power saving mode enabled?
>> >> Dazed and confused, but trying to continue
>> >
>> > Ok, I commented out the "pcie_write_mps(dev, mps);" line and the error
>> > stopped, but this made me realize that the pci=3Dpcie_bus_safe option =
must
>> > have been missing. It turns out I had hacked a custom grub entry to lo=
ad
>> > the newest kernel into grub instead of the one with the highest versio=
n
>> > number (grumble), so the default kopt didn't apply there.
>> >
>> > So, pci=3Dpcie_bus_safe DOES fix this case, and I've confirmed that th=
e
>> > MRRS-dissabling patch makes no difference in this case.
>> >
>> > Can we just make pci=3Dpcie_bus_safe (as in previous behavior) the def=
ault,
>> > or make it not change where it would otherwise warn, or does that
>> > basically make the thing useless?
>>
>> I have a patch that does does pcie_bus_safe as the default behavior
>> and does not modify the MRRS. =A0Would you be willing to test this patch
>> for me?
>
> Sure, of course. (It compiles, ship it. :))

Great, thanks!  I've attached a patch file to this e-mail.

Thanks,
Jon

>
> Simon-
>

--001636ed65fd84a35b04ac60611b
Content-Type: text/x-patch; charset=US-ASCII; name="test.patch"
Content-Disposition: attachment; filename="test.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsasvlel0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5jIGIvZHJpdmVycy9wY2kvcGNpLmMKaW5kZXgg
MGNlNjc0Mi4uNGU4NGZkNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvcGNpLmMKKysrIGIvZHJp
dmVycy9wY2kvcGNpLmMKQEAgLTc3LDcgKzc3LDcgQEAgdW5zaWduZWQgbG9uZyBwY2lfY2FyZGJ1
c19tZW1fc2l6ZSA9IERFRkFVTFRfQ0FSREJVU19NRU1fU0laRTsKIHVuc2lnbmVkIGxvbmcgcGNp
X2hvdHBsdWdfaW9fc2l6ZSAgPSBERUZBVUxUX0hPVFBMVUdfSU9fU0laRTsKIHVuc2lnbmVkIGxv
bmcgcGNpX2hvdHBsdWdfbWVtX3NpemUgPSBERUZBVUxUX0hPVFBMVUdfTUVNX1NJWkU7CiAKLWVu
dW0gcGNpZV9idXNfY29uZmlnX3R5cGVzIHBjaWVfYnVzX2NvbmZpZyA9IFBDSUVfQlVTX1BFUkZP
Uk1BTkNFOworZW51bSBwY2llX2J1c19jb25maWdfdHlwZXMgcGNpZV9idXNfY29uZmlnID0gUENJ
RV9CVVNfU0FGRTsKIAogLyoKICAqIFRoZSBkZWZhdWx0IENMUyBpcyB1c2VkIGlmIGFyY2ggZGlk
bid0IHNldCBDTFMgZXhwbGljaXRseSBhbmQgbm90CmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9w
cm9iZS5jIGIvZHJpdmVycy9wY2kvcHJvYmUuYwppbmRleCA4NDczNzI3Li44NDdlZTVkIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3BjaS9wcm9iZS5jCisrKyBiL2RyaXZlcnMvcGNpL3Byb2JlLmMKQEAg
LTEzOTYsMzQgKzEzOTYsMzcgQEAgc3RhdGljIHZvaWQgcGNpZV93cml0ZV9tcHMoc3RydWN0IHBj
aV9kZXYgKmRldiwgaW50IG1wcykKIAogc3RhdGljIHZvaWQgcGNpZV93cml0ZV9tcnJzKHN0cnVj
dCBwY2lfZGV2ICpkZXYsIGludCBtcHMpCiB7Ci0JaW50IHJjLCBtcnJzOworCWludCByYywgbXJy
cywgZGV2X21wc3M7CiAKLQlpZiAocGNpZV9idXNfY29uZmlnID09IFBDSUVfQlVTX1BFUkZPUk1B
TkNFKSB7Ci0JCWludCBkZXZfbXBzcyA9IDEyOCA8PCBkZXYtPnBjaWVfbXBzczsKKwkvKiBJbiB0
aGUgInNhZmUiIGNhc2UsIGRvIG5vdCBjb25maWd1cmUgdGhlIE1SUlMuICBUaGVyZSBhcHBlYXIg
dG8gYmUKKwkgKiBpc3N1ZXMgd2l0aCBzZXR0aW5nIE1SUlMgdG8gMCBvbiBhIG51bWJlciBvZiBk
ZXZpY2VzLgorCSAqLwogCi0JCS8qIEZvciBNYXggcGVyZm9ybWFuY2UsIHRoZSBNUlJTIG11c3Qg
YmUgc2V0IHRvIHRoZSBsYXJnZXN0Ci0JCSAqIHN1cHBvcnRlZCB2YWx1ZS4gIEhvd2V2ZXIsIGl0
IGNhbm5vdCBiZSBjb25maWd1cmVkIGxhcmdlcgotCQkgKiB0aGFuIHRoZSBNUFMgdGhlIGRldmlj
ZSBvciB0aGUgYnVzIGNhbiBzdXBwb3J0LiAgVGhpcyBhc3N1bWVzCi0JCSAqIHRoYXQgdGhlIGxh
cmdlc3QgTVJSUyBhdmFpbGFibGUgb24gdGhlIGRldmljZSBjYW5ub3QgYmUKLQkJICogc21hbGxl
ciB0aGFuIHRoZSBkZXZpY2UgTVBTUy4KLQkJICovCi0JCW1ycnMgPSBtcHMgPCBkZXZfbXBzcyA/
IG1wcyA6IGRldl9tcHNzOwotCX0gZWxzZQotCQkvKiBJbiB0aGUgInNhZmUiIGNhc2UsIGNvbmZp
Z3VyZSB0aGUgTVJSUyBmb3IgZmFpcm5lc3Mgb24gdGhlCi0JCSAqIGJ1cyBieSBtYWtpbmcgYWxs
IGRldmljZXMgaGF2ZSB0aGUgc2FtZSBzaXplCi0JCSAqLwotCQltcnJzID0gbXBzOworCWlmIChw
Y2llX2J1c19jb25maWcgIT0gUENJRV9CVVNfUEVSRk9STUFOQ0UpCisJCXJldHVybjsKKworCWRl
dl9tcHNzID0gMTI4IDw8IGRldi0+cGNpZV9tcHNzOwogCisJLyogRm9yIE1heCBwZXJmb3JtYW5j
ZSwgdGhlIE1SUlMgbXVzdCBiZSBzZXQgdG8gdGhlIGxhcmdlc3Qgc3VwcG9ydGVkCisJICogdmFs
dWUuICBIb3dldmVyLCBpdCBjYW5ub3QgYmUgY29uZmlndXJlZCBsYXJnZXIgdGhhbiB0aGUgTVBT
IHRoZQorCSAqIGRldmljZSBvciB0aGUgYnVzIGNhbiBzdXBwb3J0LiAgVGhpcyBhc3N1bWVzIHRo
YXQgdGhlIGxhcmdlc3QgTVJSUworCSAqIGF2YWlsYWJsZSBvbiB0aGUgZGV2aWNlIGNhbm5vdCBi
ZSBzbWFsbGVyIHRoYW4gdGhlIGRldmljZSBNUFNTLgorCSAqLworCW1ycnMgPSBtaW4obXBzLCBk
ZXZfbXBzcyk7CiAKIAkvKiBNUlJTIGlzIGEgUi9XIHJlZ2lzdGVyLiAgSW52YWxpZCB2YWx1ZXMg
Y2FuIGJlIHdyaXR0ZW4sIGJ1dCBhCi0JICogc3Vic2lxdWVudCByZWFkIHdpbGwgdmVyaWZ5IGlm
IHRoZSB2YWx1ZSBpcyBhY2NlcHRhYmxlIG9yIG5vdC4KLQkgKiBJZiB0aGUgTVJSUyB2YWx1ZSBw
cm92aWRlZCBpcyBub3QgYWNjZXB0YWJsZSAoZS5nLiwgdG9vIGxhcmdlKSwKLQkgKiBzaHJpbmsg
dGhlIHZhbHVlIHVudGlsIGl0IGlzIGFjY2VwdGFibGUgdG8gdGhlIEhXLgorCSAqIHN1YnNpcXVl
bnQgcmVhZCB3aWxsIHZlcmlmeSBpZiB0aGUgdmFsdWUgaXMgYWNjZXB0YWJsZSBvciBub3QuICBJ
ZgorCSAqIHRoZSBNUlJTIHZhbHVlIHByb3ZpZGVkIGlzIG5vdCBhY2NlcHRhYmxlIChlZywgdG9v
IGxhcmdlKSwgc2hyaW5rIHRoZQorCSAqIHZhbHVlIHVudGlsIGl0IGlzIGFjY2VwdGFibGUgdG8g
dGhlIEhXLgogIAkgKi8KIAl3aGlsZSAobXJycyAhPSBwY2llX2dldF9yZWFkcnEoZGV2KSAmJiBt
cnJzID49IDEyOCkgeworCQlkZXZfd2FybigmZGV2LT5kZXYsICJBdHRlbXB0aW5nIHRvIG1vZGlm
eSB0aGUgUENJLUUgTVJSUyB2YWx1ZSIKKwkJCSAiIHRvICVkLiAgSWYgYW55IGlzc3VlcyBhcmUg
ZW5jb3VudGVyZWQsIHBsZWFzZSB0cnkgIgorCQkJICJydW5uaW5nIHdpdGggcGNpPXBjaWVfYnVz
X3NhZmVcbiIsIG1ycnMpOwogCQlyYyA9IHBjaWVfc2V0X3JlYWRycShkZXYsIG1ycnMpOwogCQlp
ZiAocmMpCi0JCQlkZXZfZXJyKCZkZXYtPmRldiwgIkZhaWxlZCBhdHRlbXB0aW5nIHRvIHNldCB0
aGUgTVJSU1xuIik7CisJCQlkZXZfZXJyKCZkZXYtPmRldiwKKwkJCQkiRmFpbGVkIGF0dGVtcHRp
bmcgdG8gc2V0IHRoZSBNUlJTXG4iKTsKIAogCQltcnJzIC89IDI7CiAJfQpAQCAtMTQzNiwxMyAr
MTQzOSwxMyBAQCBzdGF0aWMgaW50IHBjaWVfYnVzX2NvbmZpZ3VyZV9zZXQoc3RydWN0IHBjaV9k
ZXYgKmRldiwgdm9pZCAqZGF0YSkKIAlpZiAoIXBjaV9pc19wY2llKGRldikpCiAJCXJldHVybiAw
OwogCi0JZGV2X2luZm8oJmRldi0+ZGV2LCAiRGV2IE1QUyAlZCBNUFNTICVkIE1SUlMgJWRcbiIs
CisJZGV2X2RiZygmZGV2LT5kZXYsICJEZXYgTVBTICVkIE1QU1MgJWQgTVJSUyAlZFxuIiwKIAkJ
IHBjaWVfZ2V0X21wcyhkZXYpLCAxMjg8PGRldi0+cGNpZV9tcHNzLCBwY2llX2dldF9yZWFkcnEo
ZGV2KSk7CiAKIAlwY2llX3dyaXRlX21wcyhkZXYsIG1wcyk7CiAJcGNpZV93cml0ZV9tcnJzKGRl
diwgbXBzKTsKIAotCWRldl9pbmZvKCZkZXYtPmRldiwgIkRldiBNUFMgJWQgTVBTUyAlZCBNUlJT
ICVkXG4iLAorCWRldl9kYmcoJmRldi0+ZGV2LCAiRGV2IE1QUyAlZCBNUFNTICVkIE1SUlMgJWRc
biIsCiAJCSBwY2llX2dldF9tcHMoZGV2KSwgMTI4PDxkZXYtPnBjaWVfbXBzcywgcGNpZV9nZXRf
cmVhZHJxKGRldikpOwogCiAJcmV0dXJuIDA7Cg==
--001636ed65fd84a35b04ac60611b--
