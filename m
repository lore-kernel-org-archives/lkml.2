Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab1KIU1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:27:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53202 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1KIU1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:27:08 -0500
Subject: Re: [PATCHv2 RFC] virtio-spec: flexible configuration layout
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@kernel.org
In-Reply-To: <20111109195901.GA28155@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>
	 <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com>
	 <20111109195901.GA28155@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 09 Nov 2011 22:24:47 +0200
Message-ID: <1320870287.3730.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 21:59 +0200, Michael S. Tsirkin wrote:

[snip]

> +\begin_layout Enumerate
> +Reset the device.
> + This is not required on initial start up.
> +\end_layout
> +
> +\begin_layout Enumerate
> +The ACKNOWLEDGE status bit is set: we have noticed the device.
> +\end_layout
> +
> +\begin_layout Enumerate
> +The DRIVER status bit is set: we know how to drive the device.
> +\end_layout
> +
> +\begin_layout Enumerate
> +
> +\change_inserted 1986246365 1320838089
> +PCI capability list scan, detecting virtio configuration layout using Virtio
> + Structure PCI capabilities.

Does the legacy space always gets mapped from BAR0?

If yes, It'll be a bit harder deprecating it in the future.

If not, this should actually be #1. Previous 3 bullets here were already
setting the status byte in the device config.

[snip]

> +<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
> +\begin_inset Text
> +
> +\begin_layout Plain Layout
> +
> +\change_inserted 1986246365 1320786225
> +28 bytes

This is the new virtio header min size, shouldn't it be 32? (20 + 4
(msi-x) + 4 (guest feature) + 4 (device features)).

-- 

Sasha.

