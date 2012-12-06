Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2LFAV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:21:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41463 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab2LFAVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:21:55 -0500
Message-ID: <50BFE50C.8030008@zytor.com>
Date: Wed, 05 Dec 2012 16:21:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Use PCI ROMs from EFI boot services
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com> <20121206001819.GA30527@srcf.ucam.org>
In-Reply-To: <20121206001819.GA30527@srcf.ucam.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 04:18 PM, Matthew Garrett wrote:
> On Wed, Dec 05, 2012 at 04:15:56PM -0800, Yinghai Lu wrote:
> 
>> at the same time we should export setup_data into /sys, so kexec could
>> append this pointer to command of
>> second kernel, just like kexec append acpi_rsdp.
>> That should address DavidW's concern.
> 
> Why should the kernel export data to userspace just so that that data 
> can be passed back into the kernel?
> 

Because it also needs to modify it.  Right now kexec userspace
synthesizes struct boot_params from scratch, and does so incorrectly to
boot.  I think we have setup_data exported via debugfs but IIRC we never
got a strong enough use case for sysfs.

	-hpa

