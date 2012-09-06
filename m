Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2IFNfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:35:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34021 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2IFNfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:35:41 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWgPV=RnXGT4hDsk3xDm8iBu8ShvFFrs=t3+3D3=-bP2Q@mail.gmail.com>
References: <CA+icZUWgPV=RnXGT4hDsk3xDm8iBu8ShvFFrs=t3+3D3=-bP2Q@mail.gmail.com>
Date: Thu, 6 Sep 2012 15:35:39 +0200
Message-ID: <CA+icZUUQiPv=iwwC43f6kuU_ikDDKeRC5=QYN4R9OzccmpAEeA@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 6 (does not boot on AMD64)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: multipart/mixed; boundary=f46d0408d7ef2da39404c9089118
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0408d7ef2da39404c9089118
Content-Type: text/plain; charset=UTF-8

On Thu, Sep 6, 2012 at 1:48 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Sep 6, 2012 at 9:23 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20120905:
>>
>> New tree: arm64
>>
>> The powerpc tree gained a build failure for which I reverted 3 commits.
>>
>> The net-next tree lost its build failure.
>>
>> The trivial tree gained a conflict against the powerpc tree.
>>
>> The spi-mb tree gained a build failure so I used the version from
>> next-20120905.
>>
>> The driver-core tree gained a build failure (form an interaction with the
>> workqueues tree) for which I applied a merge fix patch.
>>
>> The tty tree gained a build failure for which I applied a patch.
>>
>> The staging tree lost its build failure.
>>
>> The arm-soc tree gained a conflict against the usb tree.
>>
>> ----------------------------------------------------------------------------
>>
>
> Hi,
>
> Unfortunately, today's linux-next does not boot here on Ubuntu/precise AMD64.
> My yesterday's next-20120905 is fine.
>
> I throw out all my additional patches an rebuild again as "-2", but
> this linux-image does not boot.
> It's in very early stage.
> I removed "quiet" etc. from kernel-command-line, but this reveals not much more.
>
> From the attached kernel-config.diff:
> Dunno why the 2nd is disabled now and try to turn off the 1st one in a
> "-3" build.
>
> +CONFIG_X86_ACPI_CPUFREQ_CPB=y
> -CONFIG_USB_LIBUSUAL=y
>

[ CC Rafael (cpufreq sub-maintainer) ]

I hacked to turn off CONFIG_X86_ACPI_CPUFREQ_CPB, but this is not the
root cause.
Not sure why this setting is default YES, Rafael?

To switch from upstart to systemd does not help.

- Sedat -

> If you know of a culprit or see anything in the kernel-config.diff let me know.
>
> Regards,
> - Sedat -

--f46d0408d7ef2da39404c9089118
Content-Type: application/octet-stream; 
	name="0001-cpufreq-Disable-CONFIG_X86_ACPI_CPUFREQ_CPB-by-defau.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-Disable-CONFIG_X86_ACPI_CPUFREQ_CPB-by-defau.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h6rwe8bk2

RnJvbSBjZjEyN2NmMzliOWE0N2NkZGFlN2QyZTI1M2IzZTc2YmFlZWNkNGMzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUaHUsIDYgU2VwIDIwMTIgMTQ6MjM6NTAgKzAyMDAKU3ViamVjdDogW1BBVENIXSBjcHVm
cmVxOiBEaXNhYmxlIENPTkZJR19YODZfQUNQSV9DUFVGUkVRX0NQQiBieSBkZWZhdWx0CgoKU2ln
bmVkLW9mZi1ieTogU2VkYXQgRGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4KLS0tCiBkcml2
ZXJzL2NwdWZyZXEvS2NvbmZpZy54ODYgfCAgICAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvS2Nv
bmZpZy54ODYgYi9kcml2ZXJzL2NwdWZyZXEvS2NvbmZpZy54ODYKaW5kZXggOTM0ODU0YS4uOTNh
OTIzMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL0tjb25maWcueDg2CisrKyBiL2RyaXZl
cnMvY3B1ZnJlcS9LY29uZmlnLng4NgpAQCAtMzQsNyArMzQsNyBAQCBjb25maWcgWDg2X0FDUElf
Q1BVRlJFUQogCSAgSWYgaW4gZG91YnQsIHNheSBOLgogCiBjb25maWcgWDg2X0FDUElfQ1BVRlJF
UV9DUEIKLQlkZWZhdWx0IHkKKwlkZWZhdWx0IG4KIAlib29sICJMZWdhY3kgY3BiIHN5c2ZzIGtu
b2Igc3VwcG9ydCBmb3IgQU1EIENQVXMiCiAJZGVwZW5kcyBvbiBYODZfQUNQSV9DUFVGUkVRICYm
IENQVV9TVVBfQU1ECiAJaGVscAotLSAKMS43LjkuNQoK
--f46d0408d7ef2da39404c9089118--
