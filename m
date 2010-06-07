Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0FGKPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 06:15:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60297 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0FGKPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 06:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sn1VPuyOFlsH3UVSwSC3o7t15/lA+lBTCoCsNTmoOdBeQU7XLkSg+sBLxX+ho8nqyc
         k9YgdNi4CdQ40QdQTu5E4WhHduukUR1ch8geMPWxMMyzkIpKyGsfMMaPrDslYatDFD0A
         R6GPlVS+9Yfzw2Uf90GwBJp6inwdNGoYSoYtU=
MIME-Version: 1.0
In-Reply-To: <201006071129.32159.rjw@sisk.pl>
References: <201006071129.32159.rjw@sisk.pl>
Date: Mon, 7 Jun 2010 20:15:31 +1000
Message-ID: <AANLkTinx-5-jjtnYnUAsl-DvFtbL6wtyPnALdri0d-d2@mail.gmail.com>
Subject: Re: [Regression, post-rc1] Multiple issues after enabling SetVoltage 
	on rs780m
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 7:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi Alex,
>
> Your commit 9349d5cc920c10845693f906ebd67f394f1d0d04
> (drm/radeon/kms/pm: enable SetVoltage on r7xx/evergreen) has caused my test-bed
> Acer Ferrari One to behave quite unreliably.  The symptoms are:
>
> - the system hangs hard (~ 50% of the time) when starting Xorg
> - the system hangs hard (~ 50% of the time) when stopping Xorg during system
>  reboot
> - the system sometimes hangs hard during suspend to RAM
>
> These problems are not reproducible with the commit above reverted.
>
> Below is the information about the graphics adapter from lspci.

Reverting that commit on master fixes it?

that commit touches code paths in rv770 and evergreen that in no way
should affect that chipset which is an rs780, so takes the r600 paths.

are you sure its not 7ac9aa5a1f1b87adb69bcbec2b89e228f074103a?

Dave.
