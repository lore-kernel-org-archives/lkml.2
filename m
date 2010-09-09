Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0IISfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:35:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57045 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab0IISfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZX+T85pV0V2A4qDPVndjlV4qmY8yjK9AjQb83nExhhdE1WyyzFI8rZy8oI/kNNF6CH
         TenCgAQrUNlM1jbsgNYvkB2DtnvSM5+2+wqDAuSGI+xu4UhCmjzf172Rd08kPIaqDavf
         7zcYtz9u072am5hzeUuKZlL4X/osaVEANA/6g=
MIME-Version: 1.0
In-Reply-To: <20100909173426.GA14371@alpha.franken.de>
References: <064bb0722da5d8c271c2bd9fe0a521cc@localhost>
	<99a0868bdbcfa8785a92b4af4f6d9b99@localhost>
	<4C8914E8.5030002@caviumnetworks.com>
	<20100909173426.GA14371@alpha.franken.de>
Date: Thu, 9 Sep 2010 11:35:08 -0700
Message-ID: <AANLkTikXd9Hf6nX2X0CSi__t5nm60XFcWLAgFtJ+sZZh@mail.gmail.com>
Subject: Re: [PATCH 3/3] MIPS: DMA: Add plat_extra_sync_for_cpu()
From: Kevin Cernekee <cernekee@gmail.com>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 10:34 AM, Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
> looks like this is doing what the non_coherent_r10000 case does. So IMHO

My code is not currently in the tree, but I have 3 different hooks for
3 different processor types.  The generic __dma_sync() workaround used
on R10K is not sufficient.

> either which make non_coheren check more generic or could use the new
> plat_sync thingie for IP28 and other non coherent r10k boxes.

That is a good idea.  One thing I'd like to do is continue sharing the
same R10K code for IP27 / IP28 / IP32 / SNI_RM, and move all of it out
of dma-default.c .  Do you have any suggestions on how to define the
plat_* handlers on a per-cpu-type basis instead of making 4 identical
copies of the R10K workaround?
