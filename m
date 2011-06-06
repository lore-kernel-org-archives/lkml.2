Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1FFXLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:11:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46644 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1FFXLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VZvsq+6YF+neVN6mDBQNg/45MJwkhKOYecmAHAvDksns+vuuNXzUUikNhspR112hWN
         +arHpmAFAlpOX9dBg2cQRAHVOAbuZ+V4K6AtMgh20/5Jg1OScGt/jzE0NbhPNwP6XsyI
         QHhHa2+fpbOkjFECHXB20NkPSRubnhp+nv3Ss=
MIME-Version: 1.0
In-Reply-To: <1307389135-8150-3-git-send-email-mjg@redhat.com>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
	<1307389135-8150-3-git-send-email-mjg@redhat.com>
Date: Mon, 6 Jun 2011 16:11:08 -0700
X-Google-Sender-Auth: dtqOCbxkr-s3Pz0I2b5RpfYhLHY
Message-ID: <BANLkTine644Jk5DmEozAZqKgEGTTYRe6Jg@mail.gmail.com>
Subject: Re: [PATCH 3/3] efi: Add support for using efivars as a pstore backend
From: Tony Luck <tony.luck@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Matt_Domsch@dell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 12:38 PM, Matthew Garrett <mjg@redhat.com> wrote:
> EFI provides an area of nonvolatile storage managed by the firmware. We
> can use this as a pstore backend to maintain copies of oopses, aiding
> diagnosis.

Most of the new lines you add to efivars.c should be inside

#ifdef CONFIG_PSTORE
  ...
#endif

so that they don't bloat the kernel if PSTORE isn't configured.

I may have made a poor decision having drivers/acpi/apei/Kconfig
do a "select PSTORE" for the ACPI_APEI option.
It should probably be a normal "def_bool n" sort of thing.

-Tony
