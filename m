Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2HAS3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 14:29:07 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60194 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2HAS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:29:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com>
References: <20120801133835.GH5470@ics.muni.cz>
	<CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com>
Date: Wed, 1 Aug 2012 11:29:02 -0700
X-Google-Sender-Auth: mJt3zBY8i-Dqepg-vxjgMeQTwVo
Message-ID: <CAE9FiQUSFeBpGaFByOfENUa8qg7t89WTiUann8=4ezT7s2qmzw@mail.gmail.com>
Subject: Re: mellanox mlx4_core and SR-IOV
From: Yinghai Lu <yinghai@kernel.org>
To: Roland Dreier <roland@kernel.org>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 10:37 AM, Roland Dreier <roland@kernel.org> wrote:
> On Wed, Aug 1, 2012 at 6:38 AM, Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
>> [    3.558296] mlx4_core 0000:02:00.0: not enough MMIO resources for SR-IOV (nres: 0, iov->nres: 1)
>
> This comes from the core sriov_enable() function, not anything in mlx4.
> (although my kernel doesn't have the print of nres in that message)
>
> Not sure what it means.



On Wed, Aug 1, 2012 at 10:37 AM, Roland Dreier <roland@kernel.org> wrote:
> On Wed, Aug 1, 2012 at 6:38 AM, Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
>> [    3.558296] mlx4_core 0000:02:00.0: not enough MMIO resources for SR-IOV (nres: 0, iov->nres: 1)
>
> This comes from the core sriov_enable() function, not anything in mlx4.
> (although my kernel doesn't have the print of nres in that message)
>
> Not sure what it means.

iov bar is not assigned by BIOS, and kernel can not find range for it too.

Lukas, can you post whole boot log with PCI_DEBUG enabled? That will
tell exact why kernel does not assign them.

Recent kernel from 3.4... should enable realloc when SRIOV bar is not assigned.

Thanks

Yinghai
