Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab1IGVdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:33:38 -0400
Received: from peace.netnation.com ([204.174.223.2]:47873 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab1IGVdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:33:37 -0400
Date: Wed, 7 Sep 2011 14:33:31 -0700
From: Simon Kirby <sim@hostway.ca>
To: Jon Mason <mason@myri.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Josh Boyer <jwboyer@gmail.com>,
        Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org,
        Jordan_Hargrave@dell.com
Subject: Re: [3.1-rc4] Bus Fatal Error caused by "PCI: Set PCI-E Max
	Payload Size on fabric"
Message-ID: <20110907213331.GB23443@hostway.ca>
References: <20110906173605.GA12577@hostway.ca> <87aaag9vb8.fsf@begreifnix.stackframe.org> <CA+5PVA5aEAgdKexWK_cg2zRJk5CFsg6rhp9Wx+80GjR7iaLkOA@mail.gmail.com> <20110907104432.2f9d8b0a@jbarnes-x220> <20110907191859.GB14950@hostway.ca> <20110907204754.GA21603@hostway.ca> <CAMaF-rOrA==mN-BaPVr8SB14XgXZWd0wMb0WP=-Xqzf7-w73Ag@mail.gmail.com> <20110907205856.GB21603@hostway.ca> <CAMaF-rOZ28UdUUMPjL_4v-_Tqk26otyhzVAmjvRXyE0tqc8odg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMaF-rOZ28UdUUMPjL_4v-_Tqk26otyhzVAmjvRXyE0tqc8odg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 02:10:59PM -0700, Jon Mason wrote:

> On Wed, Sep 7, 2011 at 1:58 PM, Simon Kirby <sim@hostway.ca> wrote:
> > On Wed, Sep 07, 2011 at 01:57:28PM -0700, Jon Mason wrote:
> >
> >> On Wed, Sep 7, 2011 at 1:47 PM, Simon Kirby <sim@hostway.ca> wrote:
> >> > On Wed, Sep 07, 2011 at 12:18:59PM -0700, Simon Kirby wrote:
> >> >
> >> >> On Wed, Sep 07, 2011 at 10:44:32AM -0700, Jesse Barnes wrote:
> >> >>
> >> >> > On Wed, 7 Sep 2011 12:52:25 -0400
> >> >> > Josh Boyer <jwboyer@gmail.com> wrote:
> >> >> >
> >> >> > > On Wed, Sep 7, 2011 at 12:22 PM, Sven Schnelle <svens@stackframe.org>
> >> >> > > wrote:
> >> >> > > > Simon Kirby <sim@hostway.ca> writes:
> >> >> > > >
> >> >> > > >> Hello!
> >> >> > > >>
> >> >> > > >> Since trying 3.1-rc4 on a few Dell servers, all of them have
> >> >> > > >> booted up with the amber error LED lit. "ipmitool sel list" shows:
> >> >> > > >>
> >> >> > > >> ?? ??1 | 09/06/2011 | 17:21:56 | Event Logging Disabled #0x72 | Log
> >> >> > > >> area reset/cleared | Asserted 2 | 09/06/2011 | 17:25:38 | Critical
> >> >> > > >> Interrupt #0x18 | Bus Fatal Error | Asserted 3 | 09/06/2011 |
> >> >> > > >> 17:25:38 | Unknown #0x1a | 4 | 09/06/2011 | 17:25:38 | Unknown
> >> >> > > >> #0x1a |
> >> >> > > >
> >> >> > > > I'm seeing exact the same issue on a Dell 1950 Server. If anyone
> >> >> > > > wants me to try additional debugging/patches, feel free to do
> >> >> > > > so. Unfortunately i don't have the time/knowledge to debug that by
> >> >> > > > myself.
> >> >> > >
> >> >> > > I thought Jesse or Jon had a revert or partial fix queued up to send
> >> >> > > to Linus, but I don't see anything in or post -rc5 yet. ?That was
> >> >> > > indicated in https://bugzilla.kernel.org/show_bug.cgi?id=42162
> >> >> > >
> >> >> > > Jesse, Jon?
> >> >> >
> >> >> > kernel.org is still down and I haven't pushed anything to github. ?I
> >> >> > asked Jon to send his patch directly to Linus today instead.
> >> >>
> >> >> FWIW, this patch didn't seem to fix it:
> >> >> https://bugzilla.kernel.org/attachment.cgi?id=71222
> >> >>
> >> >> dmesg used to say:
> >> >>
> >> >> pci 0000:00:02.0: Dev MPS 128 MPSS 256 MRRS 128
> >> >> pci 0000:00:02.0: Dev MPS 256 MPSS 256 MRRS 128
> >> >> pci 0000:06:00.0: Dev MPS 128 MPSS 256 MRRS 4096
> >> >> pci 0000:06:00.0: Dev MPS 256 MPSS 256 MRRS 128
> >> >> pci 0000:07:00.0: Dev MPS 128 MPSS 256 MRRS 4096
> >> >> pci 0000:07:00.0: Dev MPS 256 MPSS 256 MRRS 128
> >> >> pci 0000:08:00.0: Dev MPS 128 MPSS 128 MRRS 128
> >> >> pci 0000:08:00.0: MPS configured higher than maximum supported by the device. ?If a bus issue occurs, try running with pci=pcie_bus_safe.
> >> >> pci 0000:08:00.0: Dev MPS 256 MPSS 256 MRRS 128
> >> >> Uhhuh. NMI received for unknown reason 21 on CPU 0.
> >> >> Do you have a strange power saving mode enabled?
> >> >> Dazed and confused, but trying to continue
> >> >
> >> > Ok, I commented out the "pcie_write_mps(dev, mps);" line and the error
> >> > stopped, but this made me realize that the pci=pcie_bus_safe option must
> >> > have been missing. It turns out I had hacked a custom grub entry to load
> >> > the newest kernel into grub instead of the one with the highest version
> >> > number (grumble), so the default kopt didn't apply there.
> >> >
> >> > So, pci=pcie_bus_safe DOES fix this case, and I've confirmed that the
> >> > MRRS-dissabling patch makes no difference in this case.
> >> >
> >> > Can we just make pci=pcie_bus_safe (as in previous behavior) the default,
> >> > or make it not change where it would otherwise warn, or does that
> >> > basically make the thing useless?
> >>
> >> I have a patch that does does pcie_bus_safe as the default behavior
> >> and does not modify the MRRS. ?Would you be willing to test this patch
> >> for me?
> >
> > Sure, of course. (It compiles, ship it. :))
> 
> Great, thanks!  I've attached a patch file to this e-mail.
> 
> Thanks,
> Jon
> 
> >
> > Simon-
> >

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 0ce6742..4e84fd4 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -77,7 +77,7 @@ unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
>  unsigned long pci_hotplug_io_size  = DEFAULT_HOTPLUG_IO_SIZE;
>  unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;
>  
> -enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_PERFORMANCE;
> +enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_SAFE;
>  
>  /*
>   * The default CLS is used if arch didn't set CLS explicitly and not
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 8473727..847ee5d 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1396,34 +1396,37 @@ static void pcie_write_mps(struct pci_dev *dev, int mps)
>  
>  static void pcie_write_mrrs(struct pci_dev *dev, int mps)
>  {
> -	int rc, mrrs;
> +	int rc, mrrs, dev_mpss;
>  
> -	if (pcie_bus_config == PCIE_BUS_PERFORMANCE) {
> -		int dev_mpss = 128 << dev->pcie_mpss;
> +	/* In the "safe" case, do not configure the MRRS.  There appear to be
> +	 * issues with setting MRRS to 0 on a number of devices.
> +	 */
>  
> -		/* For Max performance, the MRRS must be set to the largest
> -		 * supported value.  However, it cannot be configured larger
> -		 * than the MPS the device or the bus can support.  This assumes
> -		 * that the largest MRRS available on the device cannot be
> -		 * smaller than the device MPSS.
> -		 */
> -		mrrs = mps < dev_mpss ? mps : dev_mpss;
> -	} else
> -		/* In the "safe" case, configure the MRRS for fairness on the
> -		 * bus by making all devices have the same size
> -		 */
> -		mrrs = mps;
> +	if (pcie_bus_config != PCIE_BUS_PERFORMANCE)
> +		return;
> +
> +	dev_mpss = 128 << dev->pcie_mpss;
>  
> +	/* For Max performance, the MRRS must be set to the largest supported
> +	 * value.  However, it cannot be configured larger than the MPS the
> +	 * device or the bus can support.  This assumes that the largest MRRS
> +	 * available on the device cannot be smaller than the device MPSS.
> +	 */
> +	mrrs = min(mps, dev_mpss);
>  
>  	/* MRRS is a R/W register.  Invalid values can be written, but a
> -	 * subsiquent read will verify if the value is acceptable or not.
> -	 * If the MRRS value provided is not acceptable (e.g., too large),
> -	 * shrink the value until it is acceptable to the HW.
> +	 * subsiquent read will verify if the value is acceptable or not.  If
> +	 * the MRRS value provided is not acceptable (eg, too large), shrink the
> +	 * value until it is acceptable to the HW.
>   	 */
>  	while (mrrs != pcie_get_readrq(dev) && mrrs >= 128) {
> +		dev_warn(&dev->dev, "Attempting to modify the PCI-E MRRS value"
> +			 " to %d.  If any issues are encountered, please try "
> +			 "running with pci=pcie_bus_safe\n", mrrs);
>  		rc = pcie_set_readrq(dev, mrrs);
>  		if (rc)
> -			dev_err(&dev->dev, "Failed attempting to set the MRRS\n");
> +			dev_err(&dev->dev,
> +				"Failed attempting to set the MRRS\n");
>  
>  		mrrs /= 2;
>  	}
> @@ -1436,13 +1439,13 @@ static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
>  	if (!pci_is_pcie(dev))
>  		return 0;
>  
> -	dev_info(&dev->dev, "Dev MPS %d MPSS %d MRRS %d\n",
> +	dev_dbg(&dev->dev, "Dev MPS %d MPSS %d MRRS %d\n",
>  		 pcie_get_mps(dev), 128<<dev->pcie_mpss, pcie_get_readrq(dev));
>  
>  	pcie_write_mps(dev, mps);
>  	pcie_write_mrrs(dev, mps);
>  
> -	dev_info(&dev->dev, "Dev MPS %d MPSS %d MRRS %d\n",
> +	dev_dbg(&dev->dev, "Dev MPS %d MPSS %d MRRS %d\n",
>  		 pcie_get_mps(dev), 128<<dev->pcie_mpss, pcie_get_readrq(dev));
>  
>  	return 0;

Works for me (with no special cmdline).

Suggest spelling fix: s/subsiquent/subsequent/

Tested-by: Simon Kirby <sim@hostway.ca>

Simon-
