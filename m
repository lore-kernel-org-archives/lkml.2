Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab0D3Rzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:55:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758904Ab0D3Ryw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:54:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] acpi: Fall back to manually changing SCI_EN
Date: Thu, 29 Apr 2010 23:05:11 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <len.brown@intel.com>
References: <1271711614-15527-1-git-send-email-mjg@redhat.com> <201004282058.20910.rjw@sisk.pl> <alpine.LFD.2.00.1004282019240.2598@sony>
In-Reply-To: <alpine.LFD.2.00.1004282019240.2598@sony>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004292305.11493.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 April 2010, Len Brown wrote:
> 
> On Wed, 28 Apr 2010, Rafael J. Wysocki wrote:
> 
> > On Monday 19 April 2010, Matthew Garrett wrote:
> > > The ACPI spec tells us that the ACPI SCI_EN bit is under hardware control
> > > and shouldn't be touched by the OS. It seems that the Leading Other OS
> > > ignores this and some machines expect this behaviour. We have a blacklist
> > > for these, but given that we're able to detect the failure case and the
> > > alternative to breaking the spec is letting the machine crash and burn,
> > > let's try falling back when we know the alternative is a mostly-dead
> > > machine.
> > > 
> > > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > 
> > I guess we can try that, but I'd prefer it if that went into .35.
> > 
> > It _should_ be safe, but ...
> > 
> > Anyway, Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> 
> I'd like to push this patch in .34,
> and in .35 remove the DMI list and the boot option.
> 
> One thing that has bothered me about the boot option
> is that it writes SCI_EN instead of callin acpi_enable()
> as opposed to in-addition-to acpi_enable().
> If all acpi_enable() did was set SCI_EN, then it would
> not make a difference.  However, acpi_enable() writes
> SMI_CMD and we really have no idea what other stuff
> the BIOS may do in SMM on this transition.
> 
> So if we don't end up reverting this one,
> I'd really like to see the boot option gone in .35.

There are some suspend changes in .34 that may cause problems to happen for
people, so I'm not sure if it's actually a good idea to introduce one more of
them after -rc5.

Also removing the boot option can easily wait until .36 IMHO.

Rafael
