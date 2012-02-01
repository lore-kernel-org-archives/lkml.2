Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2BAHbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:31:15 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58026 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115Ab2BAHbN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:31:13 -0500
MIME-Version: 1.0
In-Reply-To: <4F26596B.6030703@redhat.com>
References: <1327077939-7084-1-git-send-email-pbonzini@redhat.com>
	<4F26596B.6030703@redhat.com>
Date: Wed, 1 Feb 2012 09:31:12 +0200
X-Google-Sender-Auth: dXAZLIDj-Qpjjuwa0RHPc3rsHQo
Message-ID: <CAOJsxLHwT0o=mS2nCSxjtwdfOif7oZkT_ZED3UOybFACVG6WvQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] virtio-scsi driver
From: Pekka Enberg <penberg@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paolo,

On Mon, Jan 30, 2012 at 10:48 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 01/20/2012 05:45 PM, Paolo Bonzini wrote:
>>
>> This is the first implementation of the virtio-scsi driver, a virtual
>> HBA that will be supported by KVM.  It implements a subset of the spec,
>> in particular it does not implement asynchronous notifications for either
>> LUN reset/removal/addition or CD-ROM media events, but it is already
>> functional and usable.
>>
>> Other matching bits:
>>
>> - spec at http://people.redhat.com/pbonzini/virtio-spec.pdf
>>
>> - QEMU implementation at git://github.com/bonzini/qemu.git,
>>   branch virtio-scsi
>>
>> Please review.  I would like this to be included in 3.3, since the
>> possibility of regressions is obviously zero.
>>
>> Paolo Bonzini (3):
>>   virtio-scsi: first version
>>   virtio-scsi: add error handling
>>   virtio-scsi: add power management support
>>
>> v3->v4: renamed VIRTIO_SCSI_S_UNDERRUN to VIRTIO_SCSI_S_OVERRUN;
>>     fixed 32-bit compilation; added power management support;
>>     adjusted calls to virtqueue_add_buf
>>
>>  drivers/scsi/Kconfig        |    8 +
>>  drivers/scsi/Makefile       |    1 +
>>  drivers/scsi/virtio_scsi.c  |  594
>> +++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/virtio_ids.h  |    1 +
>>  include/linux/virtio_scsi.h |  114 +++++++++
>>  5 files changed, 718 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/scsi/virtio_scsi.c
>>  create mode 100644 include/linux/virtio_scsi.h
>
> Ping?

What's the benefit of virtio-scsi over virtio-blk? Are we going to
support both or eventually phase out virtio-blk?

Have the virtio specification changes been reviewed? Can we guarantee
stable ABI for the virtio-scsi driver?

                        Pekka
