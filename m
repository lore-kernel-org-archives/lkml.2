Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1CGSCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:02:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51367 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1CGSCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:02:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TbaTJlL1MwMgvn013hbFf0KWCuJlX6uUJ0oo6I3o/5VG16f31Ch/0peXck0QgsnbNy
         ZMT5nNpS+8Msq84O8+1pwVC6dFHUhVvlP0ROJkfRaYx+eHzKTtmBcFld/wiyoZrf8bmf
         Jvxl6f34J19u0xMwGE4ZX39rjEcPEh5FTqo/U=
MIME-Version: 1.0
In-Reply-To: <1292865120-24020-1-git-send-email-felipe.contreras@nokia.com>
References: <1292865120-24020-1-git-send-email-felipe.contreras@nokia.com>
Date: Mon, 7 Mar 2011 20:02:44 +0200
Message-ID: <AANLkTi=w=5L8tbjGDCgoRpjRXYrNxsfWaE2SL4XG9+pY@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
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

On Mon, Dec 20, 2010 at 7:12 PM, Felipe Contreras
<felipe.contreras@nokia.com> wrote:
> We need to protect not only the dmm_map list, but the individual
> map_obj's, otherwise, we might be building the scatter-gather list with
> garbage. So, use the existing proc_lock for that.
>
> I observed race conditions which caused kernel panics while running
> stress tests. This patch fixes those.

I just heard that Tuomas Kulve is getting a lot of panics on Gumstix
Overo. I propose we apply this patch on the stable tree ASAP, and if
there's no better proposals, also on .38.

-- 
Felipe Contreras
