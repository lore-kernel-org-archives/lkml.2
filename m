Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2GIAjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 20:39:51 -0400
Received: from ozlabs.org ([203.10.76.45]:42995 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab2GIAjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 20:39:47 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Jason Vas Dias <jason.vas.dias@gmail.com>, linux-kernel@vger.kernel.org
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Comrade DOS <suloevdmitry@gmail.com>
Subject: Re: [PATCH: 1/1] ACPI: make evaluation of thermal trip points before temperature or vice versa dependant on new "temp_b4_trip" module parameter to support older AMD x86_64s
In-Reply-To: <CALyZvKyEiTaU4CDh3F-fYkSjyyFkmhjitaWmXs_PORVEeOnirw@mail.gmail.com>
References: <CALyZvKyEiTaU4CDh3F-fYkSjyyFkmhjitaWmXs_PORVEeOnirw@mail.gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 09 Jul 2012 10:00:27 +0930
Message-ID: <87bojp3hek.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2012 19:50:54 +0100, Jason Vas Dias <jason.vas.dias@gmail.com> wrote:
> This patch adds a new acpi.thermal.temp_b4_trip = 1 settting, which
> causes the temperature
> to be set before evaluation of thermal trip points (the old default) ;
>  this mode should
> be selected automatically by DMI match if the system identifies as "HP
> Compaq 6715b" .
> 
> Please consider applying a patch like that attached to fix the issue reported
> in lkml thread "Re: PROBLEM: Performance drop" recently,  whereby
> it was found that HP 6715b laptops ( which have 2.2Ghz dual-core  AMD
> x86_64 k8 CPUs)
> get stuck running the CPU at 800Khz and cannot switch frequency. I have verified
> that this still the case with v3.4.4 tagged "stable" kernel.


> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 7dbebea..de2b164 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -96,6 +96,10 @@ static int psv;
>  module_param(psv, int, 0644);
>  MODULE_PARM_DESC(psv, "Disable or override all passive trip points.");
> 
> +static int temp_b4_trip;
> +module_param(temp_b4_trip, int, 0);
> +MODULE_PARM_DESC(temp_b4_trip, "Get the temperature before
> initializing trip points.");
> +

Hi Jason,

        Two points: this is a bool, why not make it one?  I know, the
rest of the code is old-school, but this is a new parameter.  Also, why
not 0644 so it can be read and set at runtime?

Cheers,
Rusty.
