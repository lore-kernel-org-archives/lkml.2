Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2CIS3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:29:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51378 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab2CIS3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:29:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo55k_pJP2X_9jp+oBGAT_1y9hS8QNs0SgomwR-NpvimNA@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-8-git-send-email-yinghai@kernel.org>
	<CAErSpo6jqr44JS4Cyfc0cR_TNbo_ETjPJUO=x2gj-Q_x4TckVA@mail.gmail.com>
	<CAE9FiQWPk-s5F5ofO=nU05tnRhmpav+f8Cs_mBG9A-MPuK9stw@mail.gmail.com>
	<CAErSpo5QGqW8OL10H_PajnWi0JT=UsfX4c6pXJ_hsqXPcd+NPw@mail.gmail.com>
	<CAE9FiQXMhEkMBTjnPJkB21ob9L9jNp_-8_h+xo6mOt3fFQ7xQQ@mail.gmail.com>
	<CAErSpo55k_pJP2X_9jp+oBGAT_1y9hS8QNs0SgomwR-NpvimNA@mail.gmail.com>
Date: Fri, 9 Mar 2012 10:29:40 -0800
X-Google-Sender-Auth: lCCQMiLCVGnEpr6Gj_QDsJAmsns
Message-ID: <CAE9FiQV=G0huaJYtTEacctzwHTKCS+xK54QWLn3P3e0kz_Dg2Q@mail.gmail.com>
Subject: Re: [PATCH 07/23] pci, dmar: Update dmar units devices list during hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 9:37 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Mar 9, 2012 at 10:32 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Fri, Mar 9, 2012 at 9:25 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>
>>> Well, it looks like you can change both save_dev_dmaru() *and*
>>> get_dev_dmaru() to take a struct pci_dev *.  I assumed that would be
>>> obvious.
>>
>> no.
>>
>> get_dev_dmaru() have to use bus/devfn to retrieve the dev pointer.
>
> I expected something like that, but all I see in the patch is this:
>
> +static void restore_dev_to_drhd(struct pci_dev *dev)
> +       drhd = get_dev_dmaru(pci_domain_nr(dev->bus), dev->bus->number,
> +                                dev->devfn, &i, &saved_dev_drhd_list);
>
> +static void restore_dev_to_atsr(struct pci_dev *dev)
> +       atsr = get_dev_dmaru(pci_domain_nr(dev->bus), dev->bus->number,
> +                                dev->devfn, &i, &saved_dev_atsr_list);
>
> In both those cases, you have the struct pci_dev *.

OK, i missed that. will update that accordingly.

Thanks

Yinghai
