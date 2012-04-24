Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2DXPhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:37:04 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53677 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab2DXPhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:37:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAC83ZvK630=6B-k2TfV3XBg8w7ZosLVDNE4ezjDYnn=hcXA48Q@mail.gmail.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
	<1328203851-20435-12-git-send-email-tarun.kanti@ti.com>
	<13629551.hP3ZV1ajDo@vclass>
	<CAC83ZvK630=6B-k2TfV3XBg8w7ZosLVDNE4ezjDYnn=hcXA48Q@mail.gmail.com>
Date: Tue, 24 Apr 2012 21:06:59 +0530
Message-ID: <CAC83ZvJDDvCu8NKTOYh75USA3fvSAKEGaXXi9PtCM955K_keSA@mail.gmail.com>
Subject: Re: [PATCH v9 11/25] gpio/omap: cleanup omap_gpio_mod_init function
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Content-Type: multipart/mixed; boundary=00248c6a851e93d77d04be6e8646
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00248c6a851e93d77d04be6e8646
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Janusz,

On Tue, Apr 24, 2012 at 12:24 AM, DebBarma, Tarun Kanti
<tarun.kanti@ti.com> wrote:
> On Sat, Apr 21, 2012 at 7:33 PM, Janusz Krzysztofik
> <jkrzyszt@tis.icnet.pl> wrote:
>> On Thursday 02 of February 2012 23:00:37 Tarun Kanti DebBarma wrote:
>>> With register offsets now defined for respective OMAP versions we can g=
et rid
>>> of cpu_class_* checks. This function now has common initialization code=
 for
>>> all OMAP versions...
>>>
>>> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
>>> Signed-off-by: Charulatha V <charu@ti.com>
>>> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> Acked-by: Tony Lindgren <tony@atomide.com>
>>
>> Sorry for being so late with my comment for chanes already present in
>> mainline, but this patch breaks GPIO on Amstrad Delta at least, and I
>> have neither enough spare time nor enough experience with non OMAP1
>> machines to provide a solution myself.
> Yes, I looked at the omap_gpio_mod_init() and OMAP1 configurations are
> overwritten.
> Also looks like there is issue in making distinction between omap15xx
> and omap16xx.
> I will post a patch and you can help me testing it in OMAP1 platform.
> Thanks for pointing this out.
> --
> Tarun
>>
>>> ---
>>> =A0arch/arm/mach-omap1/gpio16xx.c | =A0 35 +++++++++++++++++-
>>> =A0drivers/gpio/gpio-omap.c =A0 =A0 =A0 | =A0 77 ++++++++++++----------=
------------------
>>> =A02 files changed, 57 insertions(+), 55 deletions(-)
>> ...
>>> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
>>> index f39d9e4..a948351 100644
>>> --- a/drivers/gpio/gpio-omap.c
>>> +++ b/drivers/gpio/gpio-omap.c
>> ...
>>> @@ -898,62 +896,30 @@ static void __init omap_gpio_show_rev(struct gpio=
_bank *bank)
>>> =A0 */
>>> =A0static struct lock_class_key gpio_lock_class;
>>>
>>> -/* TODO: Cleanup cpu_is_* checks */
>>> =A0static void omap_gpio_mod_init(struct gpio_bank *bank)
>>> =A0{
>>> - =A0 =A0 if (cpu_class_is_omap2()) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (cpu_is_omap44xx()) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(0xffffffff, bank=
->base +
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 OMAP4_GPIO_IRQSTATUSCLR0);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(0x00000000, bank=
->base +
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0OMAP4_GPIO_DEBOUNCENABLE);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Initialize interface clk u=
ngated, module enabled */
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(0, bank->base + =
OMAP4_GPIO_CTRL);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (cpu_is_omap34xx()) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(0x00000000, bank=
->base +
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 OMAP24XX_GPIO_IRQENABLE1);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(0xffffffff, bank=
->base +
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 OMAP24XX_GPIO_IRQSTATUS1);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(0x00000000, bank=
->base +
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 OMAP24XX_GPIO_DEBOUNCE_EN);
>>> -
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Initialize interface clk u=
ngated, module enabled */
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(0, bank->base + =
OMAP24XX_GPIO_CTRL);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>>> - =A0 =A0 } else if (cpu_class_is_omap1()) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (bank_is_mpuio(bank)) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writew(0xffff, bank->ba=
se +
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 OMAP_MPUIO_GP=
IO_MASKIT / bank->stride);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mpuio_init(bank);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (cpu_is_omap15xx() && bank->method =3D=3D =
METHOD_GPIO_1510) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writew(0xffff, bank->ba=
se
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 + OMAP1510_GPIO_INT_MASK);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writew(0x0000, bank->ba=
se
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 + OMAP1510_GPIO_INT_STATUS);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (cpu_is_omap16xx() && bank->method =3D=3D =
METHOD_GPIO_1610) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writew(0x0000, bank->ba=
se
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 + OMAP1610_GPIO_IRQENABLE1);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writew(0xffff, bank->ba=
se
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 + OMAP1610_GPIO_IRQSTATUS1);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writew(0x0014, bank->ba=
se
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 + OMAP1610_GPIO_SYSCONFIG);
>>> + =A0 =A0 void __iomem *base =3D bank->base;
>>> + =A0 =A0 u32 l =3D 0xffffffff;
>>>
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Enable system clock for =
GPIO module.
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The CAM_CLK_CTRL *is* re=
ally the right place.
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 omap_writel(omap_readl(ULPD_C=
AM_CLK_CTRL) | 0x04,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 ULPD_CAM_CLK_CTRL);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (cpu_is_omap7xx() && bank->method =3D=3D M=
ETHOD_GPIO_7XX) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(0xffffffff, bank=
->base
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 + OMAP7XX_GPIO_INT_MASK);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(0x00000000, bank=
->base
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 + OMAP7XX_GPIO_INT_STATUS);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>>> + =A0 =A0 if (bank->width =3D=3D 16)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 l =3D 0xffff;
>>> +
>>> + =A0 =A0 if (bank_is_mpuio(bank)) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 __raw_writel(l, bank->base + bank->regs->irqe=
nable);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>>> =A0 =A0 =A0 }
>>> +
>>> + =A0 =A0 _gpio_rmw(base, bank->regs->irqenable, l, bank->regs->irqenab=
le_inv);
>>> + =A0 =A0 _gpio_rmw(base, bank->regs->irqstatus, l,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 bank->regs->irqenable_inv =3D=3D false);
>>> + =A0 =A0 _gpio_rmw(base, bank->regs->irqenable, l, bank->regs->debounc=
e_en !=3D 0);
>>> + =A0 =A0 _gpio_rmw(base, bank->regs->irqenable, l, bank->regs->ctrl !=
=3D 0);
>>
>> bank->regs->irqenable trgister is manipulated 3 times in a row, each
>> time based on different criteria. This breaks GPIO on Amstrad Delta at
>> least, and generally looks wrong. I was only able to verify that
>> commenting out the above two lines fixes the issue with Amstrad Delta fo=
r
>> me.
>>
>>> + =A0 =A0 if (bank->regs->debounce_en)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 _gpio_rmw(base, bank->regs->debounce_en, 0, 1=
);
>>
>> This also looks suspicious, I guess the second line should rather be:
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_gpio_rmw(base, bank->regs->debounce, 0, =
1);
>>
>>> +
>>> + =A0 =A0 =A0/* Initialize interface clk ungated, module enabled */
>>> + =A0 =A0 if (bank->regs->ctrl)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 _gpio_rmw(base, bank->regs->ctrl, 0, 1);
>>
>> Is bank->regs->ctrl a flag, or a register offset? If the latter, is that
>> offset guaranteed to never take a valid value of 0?
>>
>> Thanks,
>> Janusz

Here is the patch, with attachment as well. I have just tested on
OMAP4 platform.
Testing on other OMAP2+ platforms is pending. In the meantime can you pleas=
e
validate on OMAP1 platform and confirm? Thanks.
--
Tarun

From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Date: Tue, 24 Apr 2012 20:34:32 +0530
Subject: [PATCH] gpio/omap: fix omap1 register overwrite in omap_gpio_mod_i=
nit

Initialization of irqenable, irqstatus registers is the common
operation done in this function for all OMAP platforms, viz.
OMAP1, OMAP2+. The latter _gpio_rmw()'s to irqenable register
was overwriting the correctly programmed OMAP1 value at the
beginning. As a result, even though it worked on OMAP2+
platforms it was breaking OMAP1 functionality.

On closer observation it is found that the first _gpio_rmw()
which is supposedly done to take care of OMAP1 platform is
generic enough and takes care of OMAP2+ platform as well.
Therefore remove the latter _gpio_rmw() to irqenable as they
are redundant.

Also, changing the sequence and logic of initializing the
irqstatus.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
---
 drivers/gpio/gpio-omap.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 1adc2ec..b8f01c1 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -964,11 +964,8 @@ static void omap_gpio_mod_init(struct gpio_bank *bank)
                return;
        }

+       _gpio_rmw(base, bank->regs->irqstatus, l,
bank->regs->irqenable_inv =3D=3D 0 );
        _gpio_rmw(base, bank->regs->irqenable, l, bank->regs->irqenable_inv=
);
-       _gpio_rmw(base, bank->regs->irqstatus, l,
-                                       bank->regs->irqenable_inv =3D=3D fa=
lse);
-       _gpio_rmw(base, bank->regs->irqenable, l, bank->regs->debounce_en !=
=3D 0);
-       _gpio_rmw(base, bank->regs->irqenable, l, bank->regs->ctrl !=3D 0);
        if (bank->regs->debounce_en)
                _gpio_rmw(base, bank->regs->debounce_en, 0, 1);

--
1.7.0.4

--00248c6a851e93d77d04be6e8646
Content-Type: application/octet-stream; 
	name="0001-gpio-omap-fix-omap1-register-overwrite-in-omap_gpio_.patch"
Content-Disposition: attachment; 
	filename="0001-gpio-omap-fix-omap1-register-overwrite-in-omap_gpio_.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1f4976k0

RnJvbSAwMDE0ZWRkYmE2OTYwOTBlZjNiZWExMmZjYTliMjg5NGQ0YTcwYTFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUYXJ1biBLYW50aSBEZWJCYXJtYSA8dGFydW4ua2FudGlAdGku
Y29tPgpEYXRlOiBUdWUsIDI0IEFwciAyMDEyIDIwOjM0OjMyICswNTMwClN1YmplY3Q6IFtQQVRD
SF0gZ3Bpby9vbWFwOiBmaXggb21hcDEgcmVnaXN0ZXIgb3ZlcndyaXRlIGluIG9tYXBfZ3Bpb19t
b2RfaW5pdAoKSW5pdGlhbGl6YXRpb24gb2YgaXJxZW5hYmxlLCBpcnFzdGF0dXMgcmVnaXN0ZXJz
IGlzIHRoZSBjb21tb24Kb3BlcmF0aW9uIGRvbmUgaW4gdGhpcyBmdW5jdGlvbiBmb3IgYWxsIE9N
QVAgcGxhdGZvcm1zLCB2aXouCk9NQVAxLCBPTUFQMisuIFRoZSBsYXR0ZXIgX2dwaW9fcm13KCkn
cyB0byBpcnFlbmFibGUgcmVnaXN0ZXIKd2FzIG92ZXJ3cml0aW5nIHRoZSBjb3JyZWN0bHkgcHJv
Z3JhbW1lZCBPTUFQMSB2YWx1ZSBhdCB0aGUKYmVnaW5uaW5nLiBBcyBhIHJlc3VsdCwgZXZlbiB0
aG91Z2ggaXQgd29ya2VkIG9uIE9NQVAyKwpwbGF0Zm9ybXMgaXQgd2FzIGJyZWFraW5nIE9NQVAx
IGZ1bmN0aW9uYWxpdHkuCgpPbiBjbG9zZXIgb2JzZXJ2YXRpb24gaXQgaXMgZm91bmQgdGhhdCB0
aGUgZmlyc3QgX2dwaW9fcm13KCkKd2hpY2ggaXMgc3VwcG9zZWRseSBkb25lIHRvIHRha2UgY2Fy
ZSBvZiBPTUFQMSBwbGF0Zm9ybSBpcwpnZW5lcmljIGVub3VnaCBhbmQgdGFrZXMgY2FyZSBvZiBP
TUFQMisgcGxhdGZvcm0gYXMgd2VsbC4KVGhlcmVmb3JlIHJlbW92ZSB0aGUgbGF0dGVyIF9ncGlv
X3JtdygpIHRvIGlycWVuYWJsZSBhcyB0aGV5CmFyZSByZWR1bmRhbnQuCgpBbHNvLCBjaGFuZ2lu
ZyB0aGUgc2VxdWVuY2UgYW5kIGxvZ2ljIG9mIGluaXRpYWxpemluZyB0aGUKaXJxc3RhdHVzLgoK
U2lnbmVkLW9mZi1ieTogVGFydW4gS2FudGkgRGViQmFybWEgPHRhcnVuLmthbnRpQHRpLmNvbT4K
LS0tCiBkcml2ZXJzL2dwaW8vZ3Bpby1vbWFwLmMgfCAgICA1ICstLS0tCiAxIGZpbGVzIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2dwaW8vZ3Bpby1vbWFwLmMgYi9kcml2ZXJzL2dwaW8vZ3Bpby1vbWFwLmMKaW5kZXggMWFkYzJl
Yy4uYjhmMDFjMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncGlvL2dwaW8tb21hcC5jCisrKyBiL2Ry
aXZlcnMvZ3Bpby9ncGlvLW9tYXAuYwpAQCAtOTY0LDExICs5NjQsOCBAQCBzdGF0aWMgdm9pZCBv
bWFwX2dwaW9fbW9kX2luaXQoc3RydWN0IGdwaW9fYmFuayAqYmFuaykKIAkJcmV0dXJuOwogCX0K
IAorCV9ncGlvX3JtdyhiYXNlLCBiYW5rLT5yZWdzLT5pcnFzdGF0dXMsIGwsIGJhbmstPnJlZ3Mt
PmlycWVuYWJsZV9pbnYgPT0gMCApOwogCV9ncGlvX3JtdyhiYXNlLCBiYW5rLT5yZWdzLT5pcnFl
bmFibGUsIGwsIGJhbmstPnJlZ3MtPmlycWVuYWJsZV9pbnYpOwotCV9ncGlvX3JtdyhiYXNlLCBi
YW5rLT5yZWdzLT5pcnFzdGF0dXMsIGwsCi0JCQkJCWJhbmstPnJlZ3MtPmlycWVuYWJsZV9pbnYg
PT0gZmFsc2UpOwotCV9ncGlvX3JtdyhiYXNlLCBiYW5rLT5yZWdzLT5pcnFlbmFibGUsIGwsIGJh
bmstPnJlZ3MtPmRlYm91bmNlX2VuICE9IDApOwotCV9ncGlvX3JtdyhiYXNlLCBiYW5rLT5yZWdz
LT5pcnFlbmFibGUsIGwsIGJhbmstPnJlZ3MtPmN0cmwgIT0gMCk7CiAJaWYgKGJhbmstPnJlZ3Mt
PmRlYm91bmNlX2VuKQogCQlfZ3Bpb19ybXcoYmFzZSwgYmFuay0+cmVncy0+ZGVib3VuY2VfZW4s
IDAsIDEpOwogCi0tIAoxLjcuMC40Cgo=
--00248c6a851e93d77d04be6e8646--
