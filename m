Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab1DTITb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:19:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1DTIT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:19:28 -0400
Message-ID: <4DAE970A.50603@redhat.com>
Date: Wed, 20 Apr 2011 11:19:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        jbarnes@virtuousgeek.org
Subject: Re: [PATCH v2 0/2] Store and load PCI device saved state across function
 resets
References: <20110419200912.3739.22895.stgit@s20.home>
In-Reply-To: <20110419200912.3739.22895.stgit@s20.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 11:12 PM, Alex Williamson wrote:
> v1 ->  v2:
>    Make the pointer passed around less opaque for type safety.
>
> Bug https://bugs.launchpad.net/qemu/+bug/754591 is caused because
> the KVM module attempts to do a pci_save_state() before assigning
> the device to a VM, expecting that the saved state will remain
> valid until we release the device.  This is in conflict with our
> need to reset devices using PCI sysfs during a VM reset to
> quiesce the device.  Any calls to pci_reset_function() will
> overwrite the device saved stated prior to reset, and reload and
> invalidate the state after.  KVM then ends up trying to restore
> the state, but it's already invalid, so the device ends up with
> reset values.
>
> This series adds a mechanism to pull the saved state off the
> struct pci_dev and reload it later.  Thanks,

Based on the sizes of the patches, this should go in via the pci tree.

-- 
error compiling committee.c: too many arguments to function

