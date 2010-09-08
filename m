Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab0IHJCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:02:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42860 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0IHJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p+k+Iix7NBXFcbxmBR/bnWImssaHUXPWXcv8o3GOzpsHJ8BjQIp53We2Lpi0pOsyeI
         mTu0QASrdddjZAqATU1uHFxQ3cNPVfgBpqWhhZ+QJh2d3IdAjEKEAEfVLvdg7kS7ReRu
         gvUgwGTngKKDXx9q+fVQP16LJAAOm4g9hQbjU=
Subject: Re: [PATCH 5/5] backing-dev: replace sync_supers_tsk/timer with a
 delayed_work
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@lst.de
In-Reply-To: <1283777182-11426-6-git-send-email-tj@kernel.org>
References: <1283777182-11426-1-git-send-email-tj@kernel.org>
	 <1283777182-11426-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 12:00:51 +0300
Message-ID: <1283936451.2979.65.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 14:46 +0200, Tejun Heo wrote:
> sync_supers_task/timer can trivially replaced with a delayed_work.  As
> it's not on the allocation path, run it on the system_wq.
> 
> NOTE: Both before and after this patch, sync_supers is not freezeable.
>       This might need to be changed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  mm/backing-dev.c |   49 ++++++++++++++-----------------------------------
>  1 files changed, 14 insertions(+), 35 deletions(-)

Actually what Al Viro wants is to make sync_supers() go away and make
every FS to take care of its own superblock. So I guess this change is
useful in a sense that it'll be then easier to push this down to FSes.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

