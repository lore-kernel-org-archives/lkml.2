Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab2C2Vtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:49:39 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61078 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933924Ab2C2Vtd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:49:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120329135956.7034cd9d.akpm@linux-foundation.org>
References: <1332857861-11562-1-git-send-email-mjg@redhat.com>
 <20120329163206.GA3480@burratino> <20120329134614.438e8aaf.akpm@linux-foundation.org>
 <20120329205635.GA2072@srcf.ucam.org> <20120329135956.7034cd9d.akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 29 Mar 2012 15:49:12 -0600
Message-ID: <CAErSpo5yuOkPNjc+OXwjNtO1eJU3OVc9rStjoNZK+5vL_0VjOQ@mail.gmail.com>
Subject: Re: [PATCH resend] ASPM: Fix pcie devices with non-pcie children
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Romain Francoise <romain@orebokech.com>,
        Chris Holland <bandidoirlandes@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Hatem Masmoudi <hatem.masmoudi@gmail.com>, janek <jan0x6c@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 2:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 29 Mar 2012 21:56:35 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
>> On Thu, Mar 29, 2012 at 01:46:14PM -0700, Andrew Morton wrote:
>>
>> > Just about the only person who wasn't copied on this email is, umm, the
>> > PCI maintainer!
>>
>> Jesse just handed that off to Bjorn…
>
> Oh.  So he did.   My search of MAINTAINERS turned up the probably wrong
>
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci.git

Yep, I'll update MAINTAINERS as soon as I set up a kernel.org tree.

The patch itself looks fine to me, so in case anybody wants to pick it
up earlier:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I do think that ASPM path is disappointingly hard to follow, which
likely contributed to the bug in the first place.
pcie_aspm_sanity_check() is a terrible name for something that returns
0/errno (which is treated as a bool meaning something like "do ASPM on
this device").  And the idea that we save this blacklist information
in the form of "link->aspm_enabled = ASPM_STATE_ALL" is weird.

But obviously, I'm ignorant of ASPM in general.

Bjorn
