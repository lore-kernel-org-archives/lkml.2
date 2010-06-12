Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0FLRvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 13:51:50 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57573 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0FLRvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 13:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=SudmZLhep1a48y221k2ZtrmnR48siz7mgF630qzfNCr6Ygb8qrqlUqUSC1d0wdey3w
         78dDhjUUQMA7LEzI3Kq0fQfk6GqSDoGQhrRVcaTEuwKdlMxEPLosiPP7GnBF0Eb0Nx1u
         u7omIdTfVP+8QX0CKSbZ9ZKjzHYj/9YgLY7pQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTimYYAD3hKRi9IXPSn428YqeGnR1Ig02FpVIbVgL@mail.gmail.com>
References: <AANLkTil6GGSoc8TpzRacr1LZBZS3ee3H1ejYDSqfdul4@mail.gmail.com>
	<20100529202253.0bd18bbd.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1006091821060.1402@localhost.localdomain>
	<AANLkTilrLYu6H3GtAcP-cHpFvrm3v22uCw2EUeW_ZK0k@mail.gmail.com>
	<alpine.LFD.2.00.1006111258430.6282@localhost.localdomain>
	<AANLkTimYYAD3hKRi9IXPSn428YqeGnR1Ig02FpVIbVgL@mail.gmail.com>
Date: Sat, 12 Jun 2010 11:51:47 -0600
Message-ID: <AANLkTiliyQD2D--mDw_FREq3dqJO-WRDCMsKVixSqvMQ@mail.gmail.com>
Subject: Re: Linux 2.6.34 causes system lockup on Compaq Presario 2200 Laptop
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not Reliably Reproducable.  Looks like a firmware/hardware problem
with an old laptop.

Jeff

On Fri, Jun 11, 2010 at 3:19 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
> On Fri, Jun 11, 2010 at 11:07 AM, Len Brown <lenb@kernel.org> wrote:
>> On Fri, 11 Jun 2010, Jeffrey Merkey wrote:
>>
>>> Len,
>>>
>>> I am having trouble getting a trace of this because its down hard to
>>> reproduce.  The reason is the lockup happens before I log into the
>>> laptop.  i.e. I boot 2.6.34 and if I let the laptop just sit there is
>>> happens.  If I log in and start doing work on it, it does not seem to
>>> happen.  It's related to using the laptop on battery mode with the
>>> charger removed.  I have a 2U appliance setup I am working on today
>>> and this frees up the laptop to try to reproduce this.  The flaky
>>> battery power misreporting was in fact accurate.  The battery in that
>>> laptop is 6 years old and does have low power.  I am certain the
>>> lockup if related though.  I will try to reproduce today and setup the
>>> trace to run after boot.  I have had it sitting there for an  hour and
>>> it has not reoccurred.  Let me try through today and if I cannot
>>> reproduce, close the bug.
>>
>> Good to know, Jeff.
>>
>> One possibility is that the old battery is confusing
>> the embedded controller -- possibly exposing a firmware bug.
>> The EC, in turn, is fully capable of hanging the OS.
>>
>> If you *can* reproduce it, it may be interesting to bisect
>> recent changes to drivers/acpi/ec.c
>>
>> Also, if you can reproduce it, it would be good to verify
>> that the problem occurs only when the battery driver is loaded.
>>
>> thanks,
>> -Len
>>
>>> > Please attach the output of acpidump here:
>>> >
>>> > https://bugzilla.kernel.org/show_bug.cgi?id=16136
>>
>> We could still use this output -- note that you can
>> capture it at any time, independent of the failure,
>> and independent of the kernel -- as it is simply
>> a copy of the tables that the BIOS is exporting to Linux.
>>
>> thanks,
>> -Len Brown, Intel Open Source Technology Center
>>
>
> I can tell you for certain it does only happen when the battery driver
> is loaded.  Still has not ocurred.  Just rebooted it 15 minutes ago --
> trying again.
>
> Jeff
>
