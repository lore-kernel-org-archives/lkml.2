Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab1CAUGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:06:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55992 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab1CAUGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ixEQtoBQcR4LJmi57haIBM2xKyXFd/03vQvO+Rm8rjgIm/Wq6YgXP2CcoypH1seQg+
         SP2bR7QkUgSVDoOKhRazPgGZJOSsrmjKBInxETRHkPdCBH8nMmcCW1Bbk69kHCc7hhXF
         BB4mXO9ZlMDrEn9gWA+wOzJCLjj9VFUNybnhk=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1103011454250.2034-100000@iolanthe.rowland.org>
References: <AANLkTi=ogThxB_2bxANV4hUsLGZs04gzHSCyH90Bm87U@mail.gmail.com>
	<Pine.LNX.4.44L0.1103011454250.2034-100000@iolanthe.rowland.org>
Date: Tue, 1 Mar 2011 21:06:09 +0100
Message-ID: <AANLkTik5HVxoOCH1ZVj50nUsCA5E04Y0J0RaWw7_KyKw@mail.gmail.com>
Subject: Re: [linux-pm] [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
From: Pierre Tardy <tardyp@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 8:57 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 1 Mar 2011, Pierre Tardy wrote:
>
>> On Tue, Mar 1, 2011 at 8:33 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Tue, 1 Mar 2011, Pierre Tardy wrote:
>> >
>> >> Please find sdhci runtime_pm implementation.
>> >>
>> >> It uses clock gating fw as a tip to know when our chip is idle.
>> >> It implements wake up from card insertion/removal.
>> >>
>> >> This is RFC, please dont merge yet. I really would like to have deep review
>> >> from PCI linux-pm guys.
>> >>
>> >> Opens are:
>> >>
>> >> 1/ Not sure if the pci configs in the driver in rpm_suspend/resume flow
>> >>  are not duplicate from what the core is doing.
>> >
>> > There may be one or two small errors.
>> >
>> >> 2/ Wakeup from D3hot: I cannot find any driver that is implementing it in current upstream,
>> >
>> > Other drivers do it, but they use PCI PME# instead of interrupts.
>> Could you please elaborate?
>> My understanding is that PCI PME will generate MSI, which translate in
>> interrupt.
>
> It depends on the platform.  On systems with ACPI, PCI PME generates an
> ACPI I/O event, which is handled by the ACPI and PM cores.  It does not
> invoke the device driver's interrupt handler.
So, let's say, in the ACPI case, if the interrupt handler dont get
called, how would the driver know that he got a sdcard insert event,
and trigger a mmc_rescan() ?

Regards,
Pierre
