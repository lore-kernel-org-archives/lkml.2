Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1F1MPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:15:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43047 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab1F1MOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimGyAN2MvPsTAYqCo2LcWQO2xjXtA@mail.gmail.com>
References: <BLU158-w332CD7657F92343D3D2D1C876A0@phx.gbl>
	<BANLkTinr-5k3grHM-gfjVi2PA67VvvTiNg@mail.gmail.com>
	<BANLkTinJHNztwaR44qdOpZyWg7ASrVG7vQ@mail.gmail.com>
	<BANLkTimGyAN2MvPsTAYqCo2LcWQO2xjXtA@mail.gmail.com>
Date: Tue, 28 Jun 2011 08:14:30 -0400
Message-ID: <BANLkTimBVMm34qBWv7bxKwRL17UnLHcazA@mail.gmail.com>
Subject: Re: [ath9k-devel] Patching ath9k/mac80211 to change MAC layer features
From: Daniel Smith <viscous.liquid@gmail.com>
To: Fred Matthews <fredmm@hotmail.co.uk>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>, ath9k-devel@venema.h4ckr.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath9k-devel@lists.ath9k
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 3:00 AM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Mon, Jun 27, 2011 at 11:07 PM, Fred Matthews <fredmm@hotmail.co.uk> wrote:
>> Hi all,
>>
>> Much appreciated Mohammed Shafi, disabling aggregation works when
>> replacing those lines with
>>  sc->sc_flags &= ~SC_OP_TXAGGR;
>>  sc->sc_flags &= ~SC_OP_RXAGGR;
>> only issue is I must always recompile compat-wireless to
>> re-enable/disable it again. I tried to port it using debugfs to be
>> able to enable and disable at runtime but ath9k kept rebooting.
>
> I am not sure we can enable/disable aggregation via debugfs, these
> flags seem are set at initialization and based on this lot of things
> happen in tx-path, initializing TID structure, ampdu action, rate
> control  etc.
>

The project I am on we have to deal with a situation where we change
the hardware environment and thus have to change some of the
initialization parameters. Obviously the environment is a little
unique, but I believe this should work for you. Before the changes are
made we do a

                if (sc->nvifs > 0) {
                        printk(KERN_INFO "ath9k:card has an open interface\n");
                        return -EBUSY;
                }

                pdev = to_pci_dev(sc->dev);
                pdev->driver->remove(pdev);

then we make our hardware change and  then do a

                pci_id = pci_match_id(pdev->driver->id_table, pdev);
                err = pdev->driver->probe(pdev, pci_id);

which gives us a re-initialized instance of ath_hw and ath_softc for the radio

Hope this helps!

V/r,
Daniel P. Smith
