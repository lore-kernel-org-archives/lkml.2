Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2JPONA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:13:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56289 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2JPOM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:12:59 -0400
Message-ID: <507D6B67.2010009@numascale-asia.com>
Date: Tue, 16 Oct 2012 22:12:55 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Steffen Persvold <sp@numascale.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] x86, AMD, NB: Cleanup and improve NB descriptors handling
References: <1350396375-26896-1-git-send-email-bp@amd64.org>
In-Reply-To: <1350396375-26896-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/2012 22:06, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
>
> First of all, the double loop of first counting the northbridges on
> the system, then allocating them and then going over them again was
> bugging me for a long time now. Fix it by moving the allocation of the
> descriptors in the initial iteration path.
>
> Then, modify the enclosing _info structure to contain two NB descriptor
> structures: and array of 8 NB descs which contains the first 8 possible
> NB descriptors for all single-board AMD systems out there. This is no
> different from the current state of affairs and is done this way so that
> lookup of those descriptors remains fast.
>
> Then, there's a linked list of further NB descs which are for large,
> confederated systems like NumaScale where more than 8 nodes are present
> in the fabric and are visible to the single system Linux image. We keep
> those unique by introducing the PCI domain ID into the node ID used for
> descriptor lookup.
>
> Rest of the code is cleanup and readability improvements.
[...]

Looks good.

I recall there were some other areas that needed fixing, so I'll rebase
on top of this tomorrow and present my change so far.

Thanks,
Daniel

-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia

