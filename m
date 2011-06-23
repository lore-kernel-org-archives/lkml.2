Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab1FWUbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:31:48 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:50209 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933870Ab1FWUbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:31:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OcyRwLX0L2FMkwLDufsguK7yby6UwJeUuhbUAuk9X8oG04O2L8slJy/uMg2GuBsm0MoHn1yhXoKf4JVQp16EkWA9YUo72U7qphHlgu4yYDjQGJKqrVTcKJxBVsTnTHpA;
Date: Thu, 23 Jun 2011 13:31:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        svenkatr@ti.com, yinghai@kernel.org, cjb@laptop.org,
        linux-pci@vger.kernel.org, linux-net-drivers@solarflare.com,
        bhutchings@solarflare.com, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 4/4] PCI: make cardbus-bridge resources nice-to-have
Message-ID: <20110623133137.03c74ea4@jbarnes-desktop>
In-Reply-To: <20110622004816.GC22917@ram-laptop>
References: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
	<1308610037-6261-5-git-send-email-linuxram@us.ibm.com>
	<20110621075659.GA4620@comet.dominikbrodowski.net>
	<20110621162321.GB22917@ram-laptop>
	<20110621143622.1fae90b3@jbarnes-desktop>
	<20110621221301.GA1814@isilmar-3.linta.de>
	<20110622004816.GC22917@ram-laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011 17:48:16 -0700
Ram Pai <linuxram@us.ibm.com> wrote:
> I assume majority of the platforms will have enough resources to satisfy all
> the resource requests, and their BIOS would have done a decent job.
> 
> Even if the BIOS has not done a decent job, and there are enough resources
> available we should not see a regression.
> 
> The only platforms that would expose a regression is when resources are under
> contention and the BIOS has assigned enough resource to the cardbus bridge but
> not to some other device. It will be hard to find such a platform, but I am
> sure there is one out somewhere there.
> 
> I am sure we will see; some day, reports of regression because that platform
> would have the exact right characteristics to expose the issue. But then that
> platform is a highly constrained platform in the first place. Its debatable if
> that should be characterised as a regression, or a platform that was riding on
> good luck till now.
> 
> Even Oliver's platform is a highly constrained platform, and we probably can
> treat his platform as 'riding on good luck till now'.
> 
> We won't be able to satisfy all the platforms with resource constraints.  I
> think our probable choice is to select a solution that breaks least number of
> platforms and special case those broken platforms through kernel command line
> parameters.

Another option is to hide the new allocation behavior behind a kernel
parameter.  I know Bjorn has opposed this in the past because really
this sort of thing should "just work".  But so far it hasn't, and we've
had to revert both Bjorn's resource tracking changes as well as the
re-allocation code.

Hiding it behind a boot option would at least let us improve things
over time and potentially switch over to new resource code in the
future...

Thoughts?

-- 
Jesse Barnes, Intel Open Source Technology Center
