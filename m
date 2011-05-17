Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1EQMhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:37:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33028 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab1EQMhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mLS7jxpe4xW1uvWRkHYlRfgB5C8Rn6gVryWmHrOdSTIEHKGcdLRPzKU/2mL3ez+MPR
         QINrMKn7RHl4YIpY5kahbiK069bQhrhagph81oeinIMHeqqWfLaA6G2amGmnIcDGIRfY
         gdx49WGQ1qI32wJnDTVtPknu3h3XJOYLW47QU=
MIME-Version: 1.0
In-Reply-To: <1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com>
Date: Tue, 17 May 2011 13:37:19 +0100
X-Google-Sender-Auth: L1pjnCBWT-suD177BkWfB8jQXOo
Message-ID: <BANLkTikPxfq4hcSLB+xkk-oJAtouNxEoyA@mail.gmail.com>
Subject: Re: [RFC 1/5] platform-drivers-x86: add support for Technologic
 Systems TS-5xxx detection
From: Sean Young <sean@mess.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel@vger.kernel.org,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2011 23:21, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:
> From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
>
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>  Documentation/ts5xxx-sbcinfo.txt      |   47 ++++++
>  MAINTAINERS                           |    6 +
>  drivers/platform/x86/Kconfig          |   11 ++
>  drivers/platform/x86/Makefile         |    1 +
>  drivers/platform/x86/ts5xxx-sbcinfo.c |  254 +++++++++++++++++++++++++++++++++
>  include/linux/ts5xxx-sbcinfo.h        |   42 ++++++
>  6 files changed, 361 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ts5xxx-sbcinfo.txt
>  create mode 100644 drivers/platform/x86/ts5xxx-sbcinfo.c
>  create mode 100644 include/linux/ts5xxx-sbcinfo.h

Please note that the 2MiB on board flash is not supported by your
platform driver, which is handled by drivers/mtd/maps/ts5500_flash.c. I
guess it would be best to either merge that file into
drivers/platform/x86/ts5xxx-sbcinfo.c or select CONFIG_MTD_TS5500 in the
Kconfig.

In addition, the flash is used by the BIOS as RFD FTL, so possibly
CONFIG_RFD_FTL should be selected too.

Thanks,
Sean
