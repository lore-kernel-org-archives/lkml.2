Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974Ab1J3Ljh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 07:39:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58168 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab1J3Ljg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 07:39:36 -0400
Message-ID: <4EAD360D.6010004@gmail.com>
Date: Sun, 30 Oct 2011 12:33:33 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, sergiu@chromium.org,
        akpm@linux-foundation.org, msb@chromium.org, seiji.aguchi@hds.com
Subject: Re: [PATCH] ramoops appears geared to not support ARM
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org>	<4EAC0C18.5090602@gmail.com> <CAEYUcX1PUgniJLqYXKM5pf_9T06OPFg4q0ZUCFc8Deu1J_R9-A@mail.gmail.com>
In-Reply-To: <CAEYUcX1PUgniJLqYXKM5pf_9T06OPFg4q0ZUCFc8Deu1J_R9-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/10/2011 03:07, Bryan Freed ha scritto:
> Right, and that is what I do to get ARM working.  The reserve() function
> calls memblock_reserve() to reserve the memory for RAMOOPS.  Keeping it
> part of main memory (by not using memblock_remove()) gets the memory
> properly mapped.
>

According to Russell, it needs to use memblock_remove to exclude that 
piece of memory.

> The problem I think we need to resolve is that this makes the ramoops
> driver messy.

I agree. Indeed I think we don't need to do anything in the driver. The 
problem is only how to exclude a piece of memory from kernel main memory 
view. For x86 it's trivial, for ARM it doesn't, but it's still possible.

Marco
