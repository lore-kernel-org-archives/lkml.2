Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab1JFRS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:18:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52275 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413Ab1JFRS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:18:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without native PM support
Date: Thu, 6 Oct 2011 19:20:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4E8C40A8.6080205@oracle.com> <201110052141.37618.rjw@sisk.pl> <CAE9FiQUjsa5CtpiqgMgHpt7av+v5NZFFOtuKC0a10Hwgwtm0Jg@mail.gmail.com>
In-Reply-To: <CAE9FiQUjsa5CtpiqgMgHpt7av+v5NZFFOtuKC0a10Hwgwtm0Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110061920.42557.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 06, 2011, Yinghai Lu wrote:
> On Wed, Oct 5, 2011 at 12:41 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >>   drivers/pci/pci.c |    3 +++
> >>   1 files changed, 3 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> >> index e9651f0..ca8c82d 100644
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
> >> @@ -664,6 +664,9 @@ static int pci_platform_power_transition(struct pci_dev *dev, pci_power_t state)
> >>                  error = platform_pci_set_power_state(dev, state);
> >>                  if (!error)
> >>                          pci_update_current_state(dev, state);
> >> +               /* Fall back to PCI_D0 if native PM is not supported */
> >> +               else if (!dev->pm_cap)
> >> +                       dev->current_state = PCI_D0;
> >>          } else {
> >>                  error = -ENODEV;
> >>                  /* Fall back to PCI_D0 if native PM is not supported */
> >>
> >
> > I have some vague memories that we tried that and it broke something.
> 
> Do have any hint for us to dig out the configuration for failing?
> 
> >
> > How thoroughly has it been tested?
> 
> tested in setups with intel cpus from Nehalem.

Can you test it on older hardware too, please?

Rafael
