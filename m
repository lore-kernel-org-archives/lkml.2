Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0LJPnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:43:45 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36905 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab0LJPno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:43:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LNQ+GLe5oqRJiFJKyw+jPkuEPLI5moGtNgVdCPdU/S92BZA6m69dZ8ep7zWjCzoW1z
         Fs/OVHI14al1FryGh1MVWYyQQUvP18Clf3JZFollDt//jD+wRgGRCr86evr660MCp0O4
         GdVqa+jpqt6zqLzNuUyQVSgpat/x6qsQU7mrI=
MIME-Version: 1.0
In-Reply-To: <1291953342-4905-4-git-send-email-fernando.lugo@ti.com>
References: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
	<1291953342-4905-4-git-send-email-fernando.lugo@ti.com>
Date: Fri, 10 Dec 2010 17:43:42 +0200
Message-ID: <AANLkTimOoL6OL4ft1c=U4p7HzvoSNg7n3BT0TJQdFL63@mail.gmail.com>
Subject: Re: [PATCHv2 3/4] staging: tidspbridge - remove disabling twl when
 printing DSP stack
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: omar.ramirez@ti.com, linux-kernel@vger.kernel.org, nm@ti.com,
        ohad@wizery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 5:55 AM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:
> Now the SHM segments are not in lock tlbs, instead
> they are in translation tables. So we cannot disable
> twl in order to get the DSP stack dump. Also add a check
> for __get_free_page allocation.

Why?

This means there's a possibility that there will be lingering entries
in the translation tables, and that the DSP side would be able to
corrupt kernel memory.

-- 
Felipe Contreras
