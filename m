Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1EIP3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:29:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54027 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272Ab1EIP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:29:45 -0400
X-Sasl-enc: hVO4Q3Y2ou4PRuqdj6kYDWe/3JdNkdLC7X+JDqF1buUw 1304954983
Date: Mon, 9 May 2011 12:29:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Lutomirski <luto@mit.edu>
Cc: ibm-acpi-devel@lists.sourceforge.net, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [RFC] Controlling the ThinkPad battery charger
Message-ID: <20110509152941.GD13275@khazad-dum.debian.net>
References: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com>
 <20110509144546.GB13275@khazad-dum.debian.net>
 <BANLkTikB2TFF12vdwLqV9NRw4meEyDjvdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikB2TFF12vdwLqV9NRw4meEyDjvdA@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 May 2011, Andrew Lutomirski wrote:
> > The SBS interface exposes more data about the battery, including
> > per-cell-group voltage and pack microcontroller aging counters, alarms, and
> > the "needs to get through the fuel-gaugue reset procedure" semasphore.
> 
> If I'm feeling really motivated, I'll look at that.  I'm currently
> more interested in the charging thresholds, though, which I think is
> independent of the choice of SBS vs ACPI to access the battery state.
> (From a quick glance at the SBS spec, you can inhibit charging
> entirely but you can't ask for thresholds.  I assume that the EC takes
> care of that.  If I'm wrong, please tell me, but SMAPI seems like a
> fine way to access the thresholds.)

Yeah, SMAPI is the safest way to deal with all this.  It is an interface
layer that Lenovo is not fond of breaking (or touches very rarely.  Amounts
to the same in the end).

SBS does not take care of thresholds, indeed.  The EC does (and I know how
to program the threshold in a few models, if you do want to test it in your
X220, I can send you the information.  It is safe to test if you use it
together with SMAPI to cross-check).

The SBS ACPI interface would be useful to provide a single driver that can
replace the ACPI battery one to deliver full functionality in one place.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
