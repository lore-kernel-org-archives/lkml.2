Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1LCRiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 12:38:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61588 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab1LCRiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 12:38:13 -0500
Message-ID: <4EDA5E7F.30508@redhat.com>
Date: Sat, 03 Dec 2011 18:38:07 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
References: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>  <1322661299-28855-2-git-send-email-pbonzini@redhat.com> <1322867228.11728.19.camel@pasglop>
In-Reply-To: <1322867228.11728.19.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 12:07 AM, Benjamin Herrenschmidt wrote:
> This is typically the one thing you should -really- obtain from the
> other side. This is the number one reason why we cannot today reliably
> emulate a SCSI controller in qemu -and- pass-through the SCSI commands
> to the host /dev/sg or equivalent (only full device emulation is
> reliable).
>
> This is also typically what something like virtio-scsi allows us to fix,
> so let's fix it. IE. we have the ability to query the "limits" of the
> real HBA /  transport on the host side and to pass them along to the
> guest, which enables us to do real pass-through.

You can fix this in QEMU; READ and WRITE commands can be split in 
multiple parts.  The scsi-block device I added recently does this.

However, it seems like a simple change, so I'll do it.  I'll add 
max_sectors and cmd_per_lun to the config space.

Paolo
