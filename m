Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2KIP1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:27:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38299 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KIP1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:27:21 -0500
MIME-Version: 1.0
In-Reply-To: <CANmqhJDJXcbUxyt6YD6ktxZCDJ=VqiwhGXP+fLMukQr0o-XwxQ@mail.gmail.com>
References: <201211081915083774239@gmail.com> <509B962C.6070002@gmail.com>
 <C5551D9AAB213A418B7FD5E4A6F30A072D565E76@ORSMSX106.amr.corp.intel.com> <CANmqhJDJXcbUxyt6YD6ktxZCDJ=VqiwhGXP+fLMukQr0o-XwxQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 9 Nov 2012 08:26:59 -0700
Message-ID: <CAErSpo4xn9t=4yXGLdPQMtUJF=n38tYrMutAoj7NCsLUzQEbcg@mail.gmail.com>
Subject: Re: SR-IOV problem with Intel 82599EB (not enough MMIO resources for SR-IOV)
To: Jason Gao <pkill.2012@gmail.com>
Cc: "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+ linux-pci, Yinghai]

On Thu, Nov 8, 2012 at 8:59 PM, Jason Gao <pkill.2012@gmail.com> wrote:
>> The BIOS in your machine doesn't support SR-IOV.  You'll need to ask the manufacturer for a BIOS upgrade, if in fact one is available.  Sometimes they're not.
>
> very thanks Greg,my server Dell R710 with latest BIOS version and
> option for SR-IOV(SR-IOV Global Enable->Enabled)  opened,I'm confused
> that Does R710 provide full support for SR-IOV, kernel or  ixgbe
> driver's bug? but I'm not sure where the problem lies,anyone has any
> experience about this?   .

Linux normally uses the resource assignments done by the BIOS, but it
is possible for the kernel to reassign those.  We don't have good
automatic support for that yet, but on a recent upstream kernel, you
can try "pci=realloc".  I doubt this option is in CentOS 6.3, though.

If an upstream kernel with "pci=realloc" still doesn't work, please
post the entire dmesg log.
