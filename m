Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab1HQRoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:44:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33715 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1HQRoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <201108171914.52257.oliver@neukum.org>
References: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
	<201108171914.52257.oliver@neukum.org>
Date: Wed, 17 Aug 2011 19:44:16 +0200
Message-ID: <CA+O4pCK3vZjZwM0D7Q0gzsTZRJC1PfzYvoVmq-g2jJQ=uP_6ug@mail.gmail.com>
Subject: Re: [PATCH] Increase usbfs bulk buffer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 17, 2011 at 7:14 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Mittwoch, 17. August 2011, 19:07:01 schrieb Markus Rechberger:
>> Hi,
>>
>> this patch increases the maximum buffersize for bulk transfers, our
>> devices support at least up to 46k bytes for bulk transfers.
>> This patch allows us to lower the iterations between kernel and
>> userspace and lower the system pressure.
>
> You must not do this. It increases memory pressure too much
> by forcing very high order allocations. If your problem is really
> the number of syscalls, you must implement scatter/gather.
>

I understand that USBFS is not 100% optimized, although we are already
using 3-4 times that much buffer with isochronous and it was working
fine for years so far as long as the system doesn't run out of memory
.. but even kerneldrivers would have issues with it in such a
situation.

An example analog video frames 170 mbit per second
~3000 bytes * 64 microframes = 192000

The bulk buffers we are asking for are for encoded videostreams, which
is much smaller than analog TV frames.
So for bulk we are just asking for around 1/4 of that buffersize.
Our application works fine with USBFS in Isochronous mode, however
some embedded systems don't support Isochronous so we are switching to
Bulk. I submitted the Isochronous patch for accepting bigger buffers
around 1-2 years ago the allocations and iterations went down from 600
to around 125 per second. For the enduser exerience since that time
it's possible to start heavy IO/memory applications without hurting
the video process.

BR,
Markus

>        Regards
>                Ôliver
>
