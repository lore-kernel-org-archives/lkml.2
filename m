Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab0LTRLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:11:05 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:62281 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab0LTRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:11:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UpaiQOfMXDoVcSNnd2i5GMvJ6FFX8BkIXSMJ+V01GK5wMTDlyQ2mreQ6sPqHaSD/A1
         Clqnd2JN99+OfEGiOr3wCuvPwJnnl6SAl+geSNNGPRwTJR/QbKoixcNGEV2LIplFK1dK
         TAGpKYy7qLw1dy1lDxE/zaGW9J3Kk6pcMRUT8=
MIME-Version: 1.0
In-Reply-To: <1292855134-14374-1-git-send-email-felipe.contreras@nokia.com>
References: <1292855134-14374-1-git-send-email-felipe.contreras@nokia.com>
Date: Mon, 20 Dec 2010 19:11:01 +0200
Message-ID: <AANLkTikZN8rPcusHrOR3eCyQWXmzd=fMc4riRvKpzQ_O@mail.gmail.com>
Subject: Re: [PATCH 0/2] staging: tidspbridge: fix dma race condition
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 4:25 PM, Felipe Contreras
<felipe.contreras@nokia.com> wrote:
> I found a race condition that triggers a kernel panic. It's explained in the
> following patches, but basically the map_obj that contains the user pages is
> being destroyed while doing a DMA operation (which requires that map_obj).
>
> My solution is to convert the spinlock to a semaphore, and exten the area
> protected (which might sleep).
>
> I have not tested these specific patches; they have been forward ported. But in
> a similar branch, they solve the issue.

Please disregard this patch series, I'll send a simpler single patch
that does the trick.

-- 
Felipe Contreras
