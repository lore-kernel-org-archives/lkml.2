Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2DRJEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:04:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab2DRJEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:04:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/6] ACPI: D3cold state is always valid
Date: Wed, 18 Apr 2012 11:09:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>, Aaron Lu <aaron.lu@amd.com>
References: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com> <1334715327.11188.144.camel@minggr> <1334716348.11188.148.camel@minggr>
In-Reply-To: <1334716348.11188.148.camel@minggr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204181109.29355.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 18, 2012, Lin Ming wrote:
> On Wed, 2012-04-18 at 10:15 +0800, Lin Ming wrote:
> > (fix Len's address)
> > 
> > On Tue, 2012-04-17 at 22:29 +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, April 17, 2012, Lin Ming wrote:
> > > > ACPI_STATE_D3 actually means ACPI D3hot which is not always valid.
> > > > Instead, ACPI D3cold is always valid.
> > > > 
> > > > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > 
> > > Can you just introduce ACPI_STATE_D3_HOT and redefine D3_COLD so that
> > > it's the same as D3, as I said?
> > 
> > Do you mean below?
> 
> Or you mean below?

This one, with a minor nit.

> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
> index eba6604..5852b8a 100644
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -499,8 +499,9 @@ typedef u64 acpi_integer;
>  #define ACPI_STATE_D0                   (u8) 0
>  #define ACPI_STATE_D1                   (u8) 1
>  #define ACPI_STATE_D2                   (u8) 2
> -#define ACPI_STATE_D3                   (u8) 3
> -#define ACPI_STATE_D3_COLD              (u8) 4
> +#define ACPI_STATE_D3_HOT               (u8) 3
> +#define ACPI_STATE_D3                   (u8) 4
> +#define ACPI_STATE_D3_COLD              ACPI_STATE_D3
>  #define ACPI_D_STATES_MAX               ACPI_STATE_D3_COLD

I'd say

  #define ACPI_D_STATES_MAX               ACPI_STATE_D3

>  #define ACPI_D_STATE_COUNT              5

Thanks,
Rafael
