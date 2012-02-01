Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab2BAINi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:13:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab2BAINh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:13:37 -0500
Message-ID: <4F28F42A.1050103@redhat.com>
Date: Wed, 01 Feb 2012 09:13:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v4 0/3] virtio-scsi driver
References: <1327077939-7084-1-git-send-email-pbonzini@redhat.com> <4F26596B.6030703@redhat.com> <CAOJsxLHwT0o=mS2nCSxjtwdfOif7oZkT_ZED3UOybFACVG6WvQ@mail.gmail.com>
In-Reply-To: <CAOJsxLHwT0o=mS2nCSxjtwdfOif7oZkT_ZED3UOybFACVG6WvQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 08:31 AM, Pekka Enberg wrote:
> What's the benefit of virtio-scsi over virtio-blk?

Most of this is in the spec or the KVM Forum 2011 presentation.

1) scalability limitations: virtio-blk-over-PCI puts a strong upper
limit on the number of devices that can be added to a guest. Common
configurations have a limit of ~30 devices. While this can be worked
around by implementing a PCI-to-PCI bridge, or by using multifunction
virtio-blk devices, these solutions either have not been implemented
yet, or introduce management restrictions.

2) limited flexibility: virtio-blk does not support all possible storage
scenarios.  For example, persistent reservations require you to pass a
whole LUN to the guest, they do not work with images.  In principle,
virtio-scsi provides anything that the underlying SCSI target supports.
The SCSI target can also be the in-kernel LIO target, which can
talk to virio-scsi via vhost.

3) limited extensibility: over the time, many features have been added
to virtio-blk. Each such change requires modifications to the virtio
specification, to the guest drivers, and to the device model in the
host. The virtio-scsi spec has been written to follow SAM conventions,
and exposing new features to the guest will only require changes to the
host's SCSI target implementation.

> Are we going to support both or eventually phase out virtio-blk?

Certainly older guests will have no virtio-scsi support, so it's going
to stay with us for a long time.

> Have the virtio specification changes been reviewed? Can we guarantee
> stable ABI for the virtio-scsi driver?

Of course.  I would have proposed it for staging otherwise.

Paolo
