Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1ATLt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:49:59 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:41659 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941Ab1ATLty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:49:54 -0500
Date: Thu, 20 Jan 2011 17:18:56 +0530
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Govindraj <govindraj.ti@gmail.com>
Cc: Thomas Weber <weber@corscience.de>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Govindraj.R" <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrei Emeltchenko <andrei.emeltchenko@nokia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] OMAP: Enable Magic SysRq on serial console ttyOx
Message-ID: <20110120114855.GD1987@m-desktop>
References: <1295426461-12459-1-git-send-email-weber@corscience.de>
 <AANLkTin0-joNuqxqL79j0wqPk_A5mtAgzEY=X=PeH=+C@mail.gmail.com>
 <20110119130049.GB9365@m-desktop>
 <4D36E7CC.5090303@corscience.de>
 <AANLkTikjdukQ+kUUR7N11rZ5b=Xd=xLb0-chMrbp5BQ6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikjdukQ+kUUR7N11rZ5b=Xd=xLb0-chMrbp5BQ6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 07:28:20PM +0530, Govindraj wrote:
> On Wed, Jan 19, 2011 at 7:01 PM, Thomas Weber <weber@corscience.de> wrote:
> > Am 19.01.2011 14:00, schrieb G, Manjunath Kondaiah:
> >> On Wed, Jan 19, 2011 at 03:01:39PM +0530, Govindraj wrote:
> >>> On Wed, Jan 19, 2011 at 2:11 PM, Thomas Weber <weber@corscience.de> wrote:
> >>>> Magic SysRq key is not working for OMAP on new serial
> >>>> console ttyOx because SUPPORT_SYSRQ is not defined
> >>>> for omap-serial.
> >>>>
> >>>> This patch defines SUPPORT_SYSRQ in omap-serial and
> >>>> enables handling of Magic SysRq character.
> >>>>
> >>>> Signed-off-by: Thomas Weber <weber@corscience.de>
> >>>
> >>> Looks fine to me.
> >>>
> >>> Acked-by: Govindraj.R <govindraj.raja@ti.com>
> >> I tried to use SysRq key on minicom after applying this patch, it looks
> >> like it is not triggering sysrq event.
> >>
> >> Am I missing anything?
> >>
> >> -Manjunath
> >> --
> > Hello Manjunath,
> >
> > Do you have CONFIG_MAGIC_SYSRQ enabled?
> > Magic SysRq key in Kernel Hacking
> >
> > I tested it on Devkit8000 (beagle board clone).
> >
> 
> re-setting lsr_break_flag to 0 in receive chars is causing issues
> in getting sysrq key break sequence on omap-serial.c
> 
> Manju,
> 
> can you try this change on your environment.
> With below change works for me on 3430SDP/4430SDP.
> key sequence I checked.
> [alt + b + t]  => shows trace of tasks running.
> [alt + b + b] => system reboot.

With below patch, it works fine on TeraTerm. However, I am not able to
perform the same on minicom.

Tested-by: Manjunath G Kondaiah <manjugk@ti.com>

-Manjunath

> 
> 
> diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
> index 1201eff..6df623e 100644
> --- a/drivers/serial/omap-serial.c
> +++ b/drivers/serial/omap-serial.c
> @@ -20,6 +20,10 @@
>   * this driver as required for the omap-platform.
>   */
> 
> +#if defined(CONFIG_SERIAL_OMAP_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> +#define SUPPORT_SYSRQ
> +#endif
> +
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/console.h>
> @@ -190,7 +194,6 @@ static inline void receive_chars(struct
> uart_omap_port *up, int *status)
>                         if (up->port.line == up->port.cons->index) {
>                                 /* Recover the break flag from console xmit */
>                                 lsr |= up->lsr_break_flag;
> -                               up->lsr_break_flag = 0;
>                         }
>  #endif
>                         if (lsr & UART_LSR_BI)
> 
> 
> --
> Thanks,
> Govindraj.R
