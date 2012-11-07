Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2KGXbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:31:55 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58023 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2KGXbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:31:53 -0500
Message-ID: <509AEF68.5060004@zankel.net>
Date: Wed, 07 Nov 2012 15:31:52 -0800
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [digsig:dmi 20/35] WARNING: security/integrity/built-in.o(.text+0x1d8):
 Section mismatch in reference from the function integrity_inode_free() to
 the variable .init.data:ima_use_tcb
References: <50913fa5.uJnC6BQdkN/Xw1h0%fengguang.wu@intel.com> <CALLzPKZdh9a0nT52GOZEO7dgxtLqU_VwD27Qs_gBe-bSk=J87g@mail.gmail.com> <20121106114108.GB19965@localhost> <CALLzPKb-9uHdbqUujbcQ2z38Lv5sqBKtmYmjYDdVhgVs4WF6cg@mail.gmail.com> <20121106115716.GA21889@localhost>
In-Reply-To: <20121106115716.GA21889@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking a bit into it, I think modpost is broken. I'm working on a fix.

Cheers!
-Chris

On 11/06/2012 03:57 AM, Fengguang Wu wrote:
> Perhaps we should CC more people..
>
> On Tue, Nov 06, 2012 at 01:47:18PM +0200, Kasatkin, Dmitry wrote:
>> On Tue, Nov 6, 2012 at 1:41 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>>> On Tue, Nov 06, 2012 at 01:16:16PM +0200, Kasatkin, Dmitry wrote:
>>>> Hi,
>>>>
>>>> I do not see that integrity_inode_free() uses ima_use_tcb.
>>>>
>>>> I think it is false positive.
>>> Interestingly, when trying to reproduce the problem, I got this
>>> slightly different message:
> Now after make clean, I get both the warnings on ima_use_tcb and
> chosen_lsm.
>
>>> WARNING: security/built-in.o(.text+0x2b68c): Section mismatch in reference from the function integrity_inode_free() to the variable .init.d
>>> ata:chosen_lsm
>>> The function integrity_inode_free() references
>>> the variable __initdata chosen_lsm.
>>> This is often because integrity_inode_free lacks a __initdata
>>> annotation or the annotation of chosen_lsm is wrong.
>>>
>> Hello,
>>
>> chosen_lsm has nothing to do with integrity subsystem, though
>> integrity_inode_free() is called from security_inode_free(),
>> which is part of security subsystem files which uses chosen_lsm...
>>
>> That is very strange.
>>
>> - Dmitry
>>
>>
>>> Thanks,
>>> Fengguang
>>>
>>>> On Wed, Oct 31, 2012 at 5:11 PM, kbuild test robot
>>>> <fengguang.wu@intel.com> wrote:
>>>>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/kasatkin/linux-digsig.git dmi
>>>>> head:   2309bb884f94d84ecb1a6a176d3e8199de7d6dad
>>>>> commit: 13ba29dcf6f0021a14a04f6f3a4560a399c02b34 [20/35] integrity: create and inititialize a keyring with builtin public key
>>>>> config: make ARCH=xtensa allyesconfig
>>>>>
>>>>> All warnings:
>>>>>
>>>>> WARNING: security/integrity/built-in.o(.text+0x1d8): Section mismatch in reference from the function integrity_inode_free() to the variable .init.data:ima_use_tcb
>>>>> The function integrity_inode_free() references
>>>>> the variable __initdata ima_use_tcb.
>>>>> This is often because integrity_inode_free lacks a __initdata
>>>>> annotation or the annotation of ima_use_tcb is wrong.
>>>>>
>>>>> ---
>>>>> 0-DAY kernel build testing backend         Open Source Technology Center
>>>>> Fengguang Wu, Yuanhan Liu                              Intel Corporation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

