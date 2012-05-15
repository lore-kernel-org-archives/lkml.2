Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab2EORDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:03:13 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41549 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab2EORDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:03:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAGTjWtB-aD+yajy6UaQ=zh2RNydCmdPF6GMr6_24xkVmAsFzwA@mail.gmail.com>
References: <4FB262940200007800083CAC@nat28.tlf.novell.com>
 <20120515125542.GA14357@emperor.us.dell.com> <CAGTjWtB-aD+yajy6UaQ=zh2RNydCmdPF6GMr6_24xkVmAsFzwA@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 15 May 2012 10:02:46 -0700
Message-ID: <CAGTjWtCZqfaxQDB6pCp_twh5fJFJ86Ez3mbxQ8avCzoiywK5mA@mail.gmail.com>
Subject: Re: [PATCH, resend] efivars: remove stray exports
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "matt.fleming@linux.intel.com" <matt.fleming@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 10:01 AM, Mike Waychison <mikew@google.com> wrote:
> On Tue, May 15, 2012 at 5:55 AM, Matt Domsch <Matt_Domsch@dell.com> wrote:
>> On Tue, May 15, 2012 at 07:05:08AM -0500, Jan Beulich wrote:
>>> There's no in-tree consumer, and the way they are currently prototyped
>>> it doesn't look like they're really usable from anywhere but the base
>>> EFI implementation.
>>
>> Seems reasonable, copying Mike who created the code paths being
>> modified here.
>
> I'm using these in drivers/google/firmware/gsmi.c
>

drivers/firmware/google/gsmi.c even (sorry, just starting my day...)

>>
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>
>>> ---
>>>  drivers/firmware/efivars.c |   13 ++++++-------
>>>  include/linux/efi.h        |    5 -----
>>>  2 files changed, 6 insertions(+), 12 deletions(-)
>>>
>>> --- 3.4-rc7/drivers/firmware/efivars.c
>>> +++ 3.4-rc7-efivars/drivers/firmware/efivars.c
>>> @@ -1039,7 +1039,7 @@ efivar_create_sysfs_entry(struct efivars
>>>       return 0;
>>>  }
>>>
>>> -static int
>>> +static int __init
>>>  create_efivars_bin_attributes(struct efivars *efivars)
>>>  {
>>>       struct bin_attribute *attr;
>>> @@ -1098,7 +1098,7 @@ out_free:
>>>       return error;
>>>  }
>>>
>>> -void unregister_efivars(struct efivars *efivars)
>>> +static void unregister_efivars(struct efivars *efivars)
>>>  {
>>>       struct efivar_entry *entry, *n;
>>>
>>> @@ -1116,11 +1116,11 @@ void unregister_efivars(struct efivars *
>>>       kfree(efivars->del_var);
>>>       kset_unregister(efivars->kset);
>>>  }
>>> -EXPORT_SYMBOL_GPL(unregister_efivars);
>>>
>>> -int register_efivars(struct efivars *efivars,
>>> -                  const struct efivar_operations *ops,
>>> -                  struct kobject *parent_kobj)
>>> +static int __init
>>> +register_efivars(struct efivars *efivars,
>>> +              const struct efivar_operations *ops,
>>> +              struct kobject *parent_kobj)
>>>  {
>>>       efi_status_t status = EFI_NOT_FOUND;
>>>       efi_guid_t vendor_guid;
>>> @@ -1192,7 +1192,6 @@ out:
>>>
>>>       return error;
>>>  }
>>> -EXPORT_SYMBOL_GPL(register_efivars);
>>>
>>>  static struct efivars __efivars;
>>>  static struct efivar_operations ops;
>>> --- 3.4-rc7/include/linux/efi.h
>>> +++ 3.4-rc7-efivars/include/linux/efi.h
>>> @@ -655,11 +655,6 @@ struct efivars {
>>>       struct pstore_info efi_pstore_info;
>>>  };
>>>
>>> -int register_efivars(struct efivars *efivars,
>>> -                  const struct efivar_operations *ops,
>>> -                  struct kobject *parent_kobj);
>>> -void unregister_efivars(struct efivars *efivars);
>>> -
>>>  #endif /* CONFIG_EFI_VARS */
>>>
>>>  #endif /* _LINUX_EFI_H */
>>>
>>>
>>>
>>
>> --
>> Matt Domsch
>> Technology Strategist
>> Dell | Office of the CTO
