Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2JCUlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:41:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38687 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab2JCUle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:41:34 -0400
MIME-Version: 1.0
In-Reply-To: <506C8A35.8010100@redhat.com>
References: <506C3B11.9010009@redhat.com>
	<1349286695-26713-1-git-send-email-yinghai@kernel.org>
	<1349286695-26713-4-git-send-email-yinghai@kernel.org>
	<506C8A35.8010100@redhat.com>
Date: Wed, 3 Oct 2012 13:41:33 -0700
X-Google-Sender-Auth: XKckmTCuxczvHpFCSnID4hPX_yQ
Message-ID: <CAE9FiQUq_AJUs04-UKYc+VbsXNihMh5cS_Xf4qW5=tSgU66kUQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] PCI: add set_max_vfs in pci_driver ops
From: Yinghai Lu <yinghai@kernel.org>
To: Don Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuvalmin@broadcom.com, bhutchings@solarflare.com,
        gregory.v.rose@intel.com, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 11:55 AM, Don Dutile <ddutile@redhat.com> wrote:
> On 10/03/2012 01:51 PM, Yinghai Lu wrote:
>>
>> Will use it enable sriov for pci devices.
>>
>> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
>> ---
>>   include/linux/pci.h |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index be1de01..7d70a5e 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -590,6 +590,7 @@ struct pci_driver {
>>         const struct pci_device_id *id_table;   /* must be non-NULL for
>> probe to be called */
>>         int  (*probe)  (struct pci_dev *dev, const struct pci_device_id
>> *id);   /* New device inserted */
>>         void (*remove) (struct pci_dev *dev);   /* Device removed (NULL if
>> not a hot-plug capable driver) */
>> +       void (*set_max_vfs) (struct pci_dev *dev); /* enable sriov */
>>         int  (*suspend) (struct pci_dev *dev, pm_message_t state);      /*
>> Device suspended */
>>         int  (*suspend_late) (struct pci_dev *dev, pm_message_t state);
>>         int  (*resume_early) (struct pci_dev *dev);
>
>
> I thought I stated the following in your earlier patch set....
>
> (a) don't use 'set_max_vfs' ;  it is not changing the max; the max
>     is whatever the device supports. This kind of terminology confuses
>     what is being done, and not descripting what is being done.
> (b) this is equiv to the sriov_enable_vfs in the RFC set I sent.
>     -- in this set, it prevents the user trying to do more than one enable,
>        and that check should be done, and reject the request, which solves
> one
>        of the complaints Alexander had.
>
> I'll try to mind-meld your sysfs attr creation patches to mind later today
> and post a new series tonight or tomorrow.  Sorry, stuck in mtgs today (and
> right now!),
> thus the delay.

Sure. please update 3, 4 as your like, and ask greg.rose work on patch 5.

Thanks

Yinghai
