Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1AFPCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:02:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34552 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab1AFPCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:02:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iXgnJ1UC03qcf7+fMeSMCCOKmi6l6fVziPNQk4MKg5Apm+kxZo69lcEddooe3QYI+h
         8R1EYTQzJOEIiZ0Z+Cvh2DjUD9nIo7+7N5uZAYpAX7/4jFj770VUkqmuzz2H8JifcwGy
         7ysr6E+7mft2wETL6HZP8Josi15n2bYn7jHdU=
MIME-Version: 1.0
In-Reply-To: <4D139517.3010608@ti.com>
References: <20101223171859.f6842045.sfr@canb.auug.org.au>
	<4D139517.3010608@ti.com>
Date: Thu, 6 Jan 2011 23:02:00 +0800
Message-ID: <AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
From: Ming Lei <tom.leiming@gmail.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <greg@kroah.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gadiyar, Anand" <gadiyar@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/12/24 Cousson, Benoit <b-cousson@ti.com>:
> + Paul "the omap clock guru".
>
> At first glance, that seems almost good.
> Except for a couple of nodes that seems to lose their 3630 support.
>
> I'm just wondering why the original usb clock node is
> kept after the introduction of the "ehci-omap.0" clock
> node. But this is anyway harmless.
>
> What commits are generating this conflict?
>
> On 12/23/2010 7:18 AM, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> Today's linux-next merge of the usb tree got a conflict in
>> arch/arm/mach-omap2/clock3xxx_data.c and
>> arch/arm/mach-omap2/clock44xx_data.c between various commits from the omap
>> tree and various commits from the usb tree.
>>
>> I did a quick fix (which may be completely wrong - see below).
>
>> diff --cc arch/arm/mach-omap2/clock3xxx_data.c
>> index 9ab817e,0579604..0000000
>> --- a/arch/arm/mach-omap2/clock3xxx_data.c
>> +++ b/arch/arm/mach-omap2/clock3xxx_data.c
>> @@@ -3275,17 -3267,18 +3275,18 @@@ static struct omap_clk omap3xxx_clks[]
>>       CLK(NULL,       "gfx_l3_ick",   &gfx_l3_ick,    CK_3430ES1),
>>       CLK(NULL,       "gfx_cg1_ck",   &gfx_cg1_ck,    CK_3430ES1),
>>       CLK(NULL,       "gfx_cg2_ck",   &gfx_cg2_ck,    CK_3430ES1),
>>  -    CLK(NULL,       "sgx_fck",      &sgx_fck,       CK_3430ES2 | CK_3517),
>>  -    CLK(NULL,       "sgx_ick",      &sgx_ick,       CK_3430ES2 | CK_3517),
>>  +    CLK(NULL,       "sgx_fck",      &sgx_fck,       CK_3430ES2PLUS | CK_3517 | CK_36XX),
>>  +    CLK(NULL,       "sgx_ick",      &sgx_ick,       CK_3430ES2PLUS | CK_3517 | CK_36XX),
>>       CLK(NULL,       "d2d_26m_fck",  &d2d_26m_fck,   CK_3430ES1),
>>  -    CLK(NULL,       "modem_fck",    &modem_fck,     CK_343X),
>>  -    CLK(NULL,       "sad2d_ick",    &sad2d_ick,     CK_343X),
>>  -    CLK(NULL,       "mad2d_ick",    &mad2d_ick,     CK_343X),
>>  +    CLK(NULL,       "modem_fck",    &modem_fck,     CK_34XX | CK_36XX),
>>  +    CLK(NULL,       "sad2d_ick",    &sad2d_ick,     CK_34XX | CK_36XX),
>>  +    CLK(NULL,       "mad2d_ick",    &mad2d_ick,     CK_34XX | CK_36XX),
>>       CLK(NULL,       "gpt10_fck",    &gpt10_fck,     CK_3XXX),
>>       CLK(NULL,       "gpt11_fck",    &gpt11_fck,     CK_3XXX),
>>  -    CLK(NULL,       "cpefuse_fck",  &cpefuse_fck,   CK_3430ES2 | CK_AM35XX),
>>  -    CLK(NULL,       "ts_fck",       &ts_fck,        CK_3430ES2 | CK_AM35XX),
>>  -    CLK(NULL,       "usbtll_fck",   &usbtll_fck,    CK_3430ES2 | CK_AM35XX),
>>  +    CLK(NULL,       "cpefuse_fck",  &cpefuse_fck,   CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>>  +    CLK(NULL,       "ts_fck",       &ts_fck,        CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>>  +    CLK(NULL,       "usbtll_fck",   &usbtll_fck,    CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>
> That one could be removed after the introduction of the following one if the
> clk_get(dev, "usbtll_fck") API is used.
>
>> +     CLK("ehci-omap.0",      "usbtll_fck",   &usbtll_fck,    CK_3430ES2 | CK_AM35XX),
>
> If only that one is kept it should be:
> +       CLK("ehci-omap.0",      "usbtll_fck",   &usbtll_fck,    CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>
> Assuming that one of the conflicting commits was trying to add the 3630 support.
>
>>       CLK("omap-mcbsp.1",     "prcm_fck",     &core_96m_fck,  CK_3XXX),
>>       CLK("omap-mcbsp.5",     "prcm_fck",     &core_96m_fck,  CK_3XXX),
>>       CLK(NULL,       "core_96m_fck", &core_96m_fck,  CK_3XXX),
>> @@@ -3309,26 -3302,27 +3310,27 @@@
>>       CLK(NULL,       "core_12m_fck", &core_12m_fck,  CK_3XXX),
>>       CLK("omap_hdq.0", "fck",        &hdq_fck,       CK_3XXX),
>>       CLK(NULL,       "ssi_ssr_fck",  &ssi_ssr_fck_3430es1,   CK_3430ES1),
>>  -    CLK(NULL,       "ssi_ssr_fck",  &ssi_ssr_fck_3430es2,   CK_3430ES2),
>>  +    CLK(NULL,       "ssi_ssr_fck",  &ssi_ssr_fck_3430es2,   CK_3430ES2PLUS | CK_36XX),
>>       CLK(NULL,       "ssi_sst_fck",  &ssi_sst_fck_3430es1,   CK_3430ES1),
>>  -    CLK(NULL,       "ssi_sst_fck",  &ssi_sst_fck_3430es2,   CK_3430ES2),
>>  +    CLK(NULL,       "ssi_sst_fck",  &ssi_sst_fck_3430es2,   CK_3430ES2PLUS | CK_36XX),
>>       CLK(NULL,       "core_l3_ick",  &core_l3_ick,   CK_3XXX),
>> -     CLK("musb_hdrc",        "ick",  &hsotgusb_ick_3430es1,  CK_3430ES1),
>> -     CLK("musb_hdrc",        "ick",  &hsotgusb_ick_3430es2,  CK_3430ES2PLUS | CK_36XX),
>> +     CLK("musb-omap2430",    "ick",  &hsotgusb_ick_3430es1,  CK_3430ES1),
>>  -    CLK("musb-omap2430",    "ick",  &hsotgusb_ick_3430es2,  CK_3430ES2),
>> ++    CLK("musb-omap2430",    "ick",  &hsotgusb_ick_3430es2,  CK_3430ES2PLUS | CK_36XX),
>>       CLK(NULL,       "sdrc_ick",     &sdrc_ick,      CK_3XXX),
>>       CLK(NULL,       "gpmc_fck",     &gpmc_fck,      CK_3XXX),
>>  -    CLK(NULL,       "security_l3_ick", &security_l3_ick, CK_343X),
>>  -    CLK(NULL,       "pka_ick",      &pka_ick,       CK_343X),
>>  +    CLK(NULL,       "security_l3_ick", &security_l3_ick, CK_34XX | CK_36XX),
>>  +    CLK(NULL,       "pka_ick",      &pka_ick,       CK_34XX | CK_36XX),
>>       CLK(NULL,       "core_l4_ick",  &core_l4_ick,   CK_3XXX),
>>  -    CLK(NULL,       "usbtll_ick",   &usbtll_ick,    CK_3430ES2 | CK_AM35XX),
>>  +    CLK(NULL,       "usbtll_ick",   &usbtll_ick,    CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>> +     CLK("ehci-omap.0",      "usbtll_ick",   &usbtll_ick,    CK_3430ES2 | CK_AM35XX),
>
> ditto, should probably be:
>  +      CLK("ehci-omap.0",      "usbtll_ick",   &usbtll_ick,    CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>
>>  -    CLK("mmci-omap-hs.2",   "ick",  &mmchs3_ick,    CK_3430ES2 | CK_AM35XX),
>>  -    CLK(NULL,       "icr_ick",      &icr_ick,       CK_343X),
>>  -    CLK("omap-aes", "ick",  &aes2_ick,      CK_343X),
>>  -    CLK("omap-sham",        "ick",  &sha12_ick,     CK_343X),
>>  -    CLK(NULL,       "des2_ick",     &des2_ick,      CK_343X),
>>  +    CLK("mmci-omap-hs.2",   "ick",  &mmchs3_ick,    CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>>  +    CLK(NULL,       "icr_ick",      &icr_ick,       CK_34XX | CK_36XX),
>>  +    CLK("omap-aes", "ick",  &aes2_ick,      CK_34XX | CK_36XX),
>>  +    CLK("omap-sham",        "ick",  &sha12_ick,     CK_34XX | CK_36XX),
>>  +    CLK(NULL,       "des2_ick",     &des2_ick,      CK_34XX | CK_36XX),
>>       CLK("mmci-omap-hs.1",   "ick",  &mmchs2_ick,    CK_3XXX),
>>       CLK("mmci-omap-hs.0",   "ick",  &mmchs1_ick,    CK_3XXX),
>>  -    CLK(NULL,       "mspro_ick",    &mspro_ick,     CK_343X),
>>  +    CLK(NULL,       "mspro_ick",    &mspro_ick,     CK_34XX | CK_36XX),
>>       CLK("omap_hdq.0", "ick",        &hdq_ick,       CK_3XXX),
>>       CLK("omap2_mcspi.4", "ick",     &mcspi4_ick,    CK_3XXX),
>>       CLK("omap2_mcspi.3", "ick",     &mcspi3_ick,    CK_3XXX),
>> @@@ -3361,14 -3355,17 +3363,17 @@@
>>       CLK("omapdss",  "video_fck",    &dss_96m_fck,   CK_3XXX),
>>       CLK("omapdss",  "dss2_fck",     &dss2_alwon_fck, CK_3XXX),
>>       CLK("omapdss",  "ick",          &dss_ick_3430es1,       CK_3430ES1),
>>  -    CLK("omapdss",  "ick",          &dss_ick_3430es2,       CK_3430ES2 | CK_AM35XX),
>>  -    CLK(NULL,       "cam_mclk",     &cam_mclk,      CK_343X),
>>  -    CLK(NULL,       "cam_ick",      &cam_ick,       CK_343X),
>>  -    CLK(NULL,       "csi2_96m_fck", &csi2_96m_fck,  CK_343X),
>>  -    CLK(NULL,       "usbhost_120m_fck", &usbhost_120m_fck, CK_3430ES2 | CK_AM35XX),
>>  +    CLK("omapdss",  "ick",          &dss_ick_3430es2,       CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>>  +    CLK(NULL,       "cam_mclk",     &cam_mclk,      CK_34XX | CK_36XX),
>>  +    CLK(NULL,       "cam_ick",      &cam_ick,       CK_34XX | CK_36XX),
>>  +    CLK(NULL,       "csi2_96m_fck", &csi2_96m_fck,  CK_34XX | CK_36XX),
>>  +    CLK(NULL,       "usbhost_120m_fck", &usbhost_120m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>> +     CLK("ehci-omap.0",      "hs_fck", &usbhost_120m_fck, CK_3430ES2 | CK_AM35XX),
>
> ditto
>
>>  -    CLK(NULL,       "usbhost_48m_fck", &usbhost_48m_fck, CK_3430ES2 | CK_AM35XX),
>>  +    CLK(NULL,       "usbhost_48m_fck", &usbhost_48m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>> +     CLK("ehci-omap.0",      "fs_fck", &usbhost_48m_fck, CK_3430ES2 | CK_AM35XX),
>
> ditto
>
>>  -    CLK(NULL,       "usbhost_ick",  &usbhost_ick,   CK_3430ES2 | CK_AM35XX),
>>  +    CLK(NULL,       "usbhost_ick",  &usbhost_ick,   CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>> +     CLK("ehci-omap.0",      "usbhost_ick",  &usbhost_ick,   CK_3430ES2 | CK_AM35XX),
>
> ditto
>
>>  -    CLK(NULL,       "usim_fck",     &usim_fck,      CK_3430ES2),
>>  +    CLK(NULL,       "usim_fck",     &usim_fck,      CK_3430ES2PLUS | CK_36XX),
>>       CLK(NULL,       "gpt1_fck",     &gpt1_fck,      CK_3XXX),
>>       CLK(NULL,       "wkup_32k_fck", &wkup_32k_fck,  CK_3XXX),
>>       CLK(NULL,       "gpio1_dbck",   &gpio1_dbck,    CK_3XXX),
>> diff --cc arch/arm/mach-omap2/clock44xx_data.c
>> index c426adc,bfcd19f..0000000
>> --- a/arch/arm/mach-omap2/clock44xx_data.c
>> +++ b/arch/arm/mach-omap2/clock44xx_data.c
>> @@@ -3198,6 -2937,10 +3198,7 @@@ static struct omap_clk omap44xx_clks[]
>>       CLK(NULL,       "uart3_fck",                    &uart3_fck,     CK_443X),
>>       CLK(NULL,       "uart4_fck",                    &uart4_fck,     CK_443X),
>>       CLK(NULL,       "usb_host_fs_fck",              &usb_host_fs_fck,       CK_443X),
>> +     CLK("ehci-omap.0",      "fs_fck",               &usb_host_fs_fck,       CK_443X),
>>  -    CLK(NULL,       "usb_host_hs_utmi_p3_clk",      &usb_host_hs_utmi_p3_clk,       CK_443X),
>>  -    CLK(NULL,       "usb_host_hs_hsic60m_p1_clk",   &usb_host_hs_hsic60m_p1_clk,    CK_443X),
>>  -    CLK(NULL,       "usb_host_hs_hsic60m_p2_clk",   &usb_host_hs_hsic60m_p2_clk,    CK_443X),
>
> I'm not sure these 3 nodes should be removed. AFAIR, they were just slightly moved in lo branch.

Even with the fixes above, ehci on my beagle xM/Panda still doesn't work
with 2.6.37-next-20110106+, follows the failure messages:

[   57.918182] bus: 'platform': really_probe: probing driver ehci-omap
with device ehci-omap.0
[   57.918243] ehci-omap ehci-omap.0: failed to get ehci port0 regulator
[   57.918273] ehci-omap ehci-omap.0: failed to get ehci port1 regulator
[   57.918304] ehci-omap ehci-omap.0: starting TI EHCI USB Controller
[   57.918457] ehci-omap ehci-omap.0: OMAP UHH_REVISION 0x10
[   57.918487] ehci-omap ehci-omap.0: TLL RESET DONE
[   57.918487] ehci-omap ehci-omap.0: OMAP3 ES version > ES2.1
[   57.918518] ehci-omap ehci-omap.0: UHH setup done, uhh_hostconfig=31c
[   58.922302] ehci-omap ehci-omap.0: phy reset operation timed out
[   59.930114] ehci-omap ehci-omap.0: phy reset operation timed out
[   59.930145] ehci-omap ehci-omap.0: reset hcs_params 0x1313 dbg=0
cc=1 pcc=3 ordered ports=3
[   59.930175] ehci-omap ehci-omap.0: reset hcc_params 0016 thresh 1
uframes 256/512/1024 park
[   59.930206] ehci-omap ehci-omap.0: OMAP-EHCI Host Controller
[   59.936218] drivers/usb/core/inode.c: creating file 'devices'
[   59.936279] drivers/usb/core/inode.c: creating file '001'

Any ideas?

thanks,
-- 
Lei Ming
