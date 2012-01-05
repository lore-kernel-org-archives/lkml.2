Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2AEL1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:27:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab2AEL1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:27:13 -0500
Date: Thu, 5 Jan 2012 12:26:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 didn't survive after s2ram failure
Message-ID: <20120105112648.GB2222@redhat.com>
References: <20111227105340.GD5344@tiehlicka.suse.cz>
 <20120103103457.GA3391@redhat.com>
 <20120103122311.GC3391@redhat.com>
 <20120103130733.GB3891@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103130733.GB3891@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 02:07:33PM +0100, Michal Hocko wrote:
> On Tue 03-01-12 13:23:12, Stanislaw Gruszka wrote:
> > On Tue, Jan 03, 2012 at 11:34:58AM +0100, Stanislaw Gruszka wrote:
> [...]
> > > If anything other will not help, is possible to rewrite eeprom, I don't
> > > know how to do this, but I know that tool for that exist:
> > > http://code.google.com/p/iwleeprom/
> > Actually I do not think we overwrite eeprom, seems problem is at pci-e
> > bus level. Simply we can not communicate with device through pci-e bus.
> > That is kind a silly, but you can check if removing cart from slot
> > and put it back again (assuring it correctly connected) helps.
> 
> I am not sure whether the wireless is integrated (this is a laptop) and
> I am little bit reluctant to open it as the warranty seems to be still
> valid and I would break it if I get inside.
Wow, laptop with so old wifi adapter has still a warranty. That good news,
you can ask vendor for fixing the problem :-)

> I have just realized that I haven't provided lspci output so just in
> case it is helpful:
I tried to reproduce on my laptop by suspend and removing power sources,
device initialize properly during boot.

I'm still wondering why we can break anything by power off during
suspend. Maybe there is some BIOS facility that power off PCIe device
or bridge during suspend, and now it in powered off state. Hard to tell,
except mentioned in other email pci* boot parameter try to change PCIe
related BIOS settings if there are any. 

Stanislaw
