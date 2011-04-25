Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab1DYQWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:22:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34675 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab1DYQWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LoGj+GZK6fVCLqpTWU1E9X79nWua/iOYSTRy/axngCwapEryIH1mApQ+ogdEUc7uAQ
         lKEu7i4/dwuegDnHptI4C0LSNGQPPG4jYPqJHYVb8bMJx6ZsMUBv6cQ2SutOpKliyZpS
         abWLqo9Yev31UhQCIzFff7/JonHC0RSutl3jQ=
Date: Mon, 25 Apr 2011 18:22:42 +0200
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110425162242.GB30828@mtj.dyndns.org>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA45CA7.9040102@teksavvy.com>
 <4DA467FB.6020905@teksavvy.com>
 <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I haven't followed the trace but,

> > __ata_port_freeze: ata4 port frozen
> > ata_port_schedule_eh: port EH scheduled
> > ata_eh_thaw_port: ata4 port thawed
> > ata_std_postreset: ENTER
> > ata4: SATA link down (SStatus 0 SControl 310)
> > ata_std_postreset: EXIT
> > ata_eh_revalidate_and_attach: ENTER
> > ata_eh_revalidate_and_attach: EXIT rc=-5
> > ata4.00: disabled
> > ata_eh_revalidate_and_attach: ENTER
> > ata_eh_recover: EXIT, rc=0
> > ata4: EH complete
> > ata_scsi_error: EXIT
> > ata_scsi_hotplug: ENTER
> > ata4.00: detaching (SCSI 3:0:0:0)
> > ata_scsi_hotplug: EXIT
> 
> Okay, so the ata_eh_thaw_port has raced (and won) against whatever was in the
> process of masking off the irq (the __ata_port_freeze?), which then completes
> leaving libata/sata_mv thinking the port is thawed while no further irqs get
> generated.
> 
> Could ata_port_freeze or __ata_port_freeze (which don't claim the ap's lock)
> have been invoked and then slept while ata_eh_thaw_port runs?

ata4 is reporting link down and the device is detached and port
disabled afterwards.  Doesn't seem to have much to do with
freezing/thawing?

-- 
tejun
