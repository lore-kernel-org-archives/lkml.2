Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab0FRUo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:44:56 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:54605 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751063Ab0FRUoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:44:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OKjxuNVifpohuHPPRhYIoh8VlpnDGdfJD+uMJwtD6FMpM+2g9a7udhHSRMZwdk2kAzxUoxJz/0polHpIRYJ/paesmkMAE1rCnwKe8Guy63UFLaXNatoAMyByFwfBRYbo;
Date: Fri, 18 Jun 2010 13:43:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Brian Bloniarz <bmb@athenacr.com>
Cc: David Miller <davem@davemloft.net>, rjw@sisk.pl, mikpe@it.uu.se,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       maciej.rutecki@gmail.com, achiang@canonical.com
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create
 duplicate filename ... XVR-600 related?
Message-ID: <20100618134316.408cf922@virtuousgeek.org>
In-Reply-To: <4C1BD9CC.5060300@athenacr.com>
References: <19475.45707.157935.788004@pilspetsen.it.uu.se>
	<201006122052.25204.rjw@sisk.pl>
	<20100618131049.462ca7ce@virtuousgeek.org>
	<20100618.132655.260090086.davem@davemloft.net>
	<4C1BD9CC.5060300@athenacr.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 16:40:44 -0400
Brian Bloniarz <bmb@athenacr.com> wrote:

> On 06/18/2010 04:26 PM, David Miller wrote:
> > From: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Date: Fri, 18 Jun 2010 13:10:49 -0700
> > 
> >> I reverted the symlink patch that was causing the trouble.  The root
> >> cause is elsewhere though; it seems some firmwares report duplicate PCI
> >> slot numbers...
> > 
> > Instead of postulating, you can confirm or deny such a theory
> > by taking a look at the repository of sparc openfirmware tree
> > dumps maintained at:
> > 
> > 	master.kernel.org:/pub/scm/linux/kernel/git/davem/prtconfs.git
> 
> (Adding Alex Chiang to the cc list)
> 
> I was actually under the impression that it was just an 
> issue with the reverted patch, not an actual problem with
> hardware.

Yeah, I think you're right.  I reverted it at Alex's request and
assumed it was a firmware or configuration problem.  Looking at the
thread again I see that was a bad assumption.

> In the patch, 2 individual code paths were trying to
> create the same symlinks:
> pci-sysfs.c:pci_create_slot_links(struct pci_dev *dev)
> and
> slot.c:create_sysfs_files(struct pci_slot *slot).
> I think some archs managed to call those both during
> initialization, and some not.

Well that would explain it too.  I'm happy to take a fixed up patch if
there's demand.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
