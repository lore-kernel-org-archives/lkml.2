Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991Ab3AIVPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:15:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38423 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645Ab3AIVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:15:08 -0500
MIME-Version: 1.0
In-Reply-To: <87d2xeul5v.fsf@xmission.com>
References: <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	<8762382z2c.fsf@xmission.com>
	<CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
	<87y5g4z7rp.fsf@xmission.com>
	<CAE9FiQVVtfxZs7E9Q=VbNHNbYJg_9TGCTetkZMYT0tgt0JLNZw@mail.gmail.com>
	<CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
	<20130109004340.GA12234@konrad-lan.dumpdata.com>
	<87txqruq8p.fsf@xmission.com>
	<CAE9FiQVgMK=CK5BvfOkGF3Pp4kOqBEg2mxX2zDuhW8zZXSVXzg@mail.gmail.com>
	<CAE9FiQVomDtc0P9B7aTDBrm7kC+i=GYokBmT54w-VBwZsafb5g@mail.gmail.com>
	<20130109132409.GB18395@phenom.dumpdata.com>
	<CAE9FiQUznCR6i56AW6jhiCCK-pQxnAquzxUoWWQamoSC8YAZKA@mail.gmail.com>
	<87d2xeul5v.fsf@xmission.com>
Date: Wed, 9 Jan 2013 13:15:06 -0800
X-Google-Sender-Auth: knCxZBYZ7UPOVeMW5qNuDApJU2k
Message-ID: <CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 1:00 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
>> please check updated attached. It should address all your request.
>
> There is one significant bug that I can see.
>
> swiotlb_print_info tests no_iotlb_memory but no_iotlb_memory is set
> after swiotlb_init_with_tlb returns.

there is another swiotlb_print_info calling from
pci_swiotlb_late_init

void __init pci_swiotlb_late_init(void)
{
        /* An IOMMU turned us off. */
        if (!swiotlb)
                swiotlb_free();
        else {
                printk(KERN_INFO "PCI-DMA: "
                       "Using software bounce buffering for IO (SWIOTLB)\n");
                swiotlb_print_info();
        }
}

so we need that checking when swiotlb == 1, but actually we can not
allocate that before.

Thanks

Yinghai
