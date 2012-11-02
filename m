Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab2KBPbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:31:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab2KBPbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:31:00 -0400
Date: Fri, 2 Nov 2012 11:30:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121102153047.GF3300@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <20121031150201.GA12394@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031150201.GA12394@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 03:02:01PM +0000, Matthew Garrett wrote:
> On Wed, Oct 31, 2012 at 03:50:00PM +0100, Jiri Kosina wrote:
> 
> > Reading stored memory image (potentially tampered before reboot) from disk 
> > is basically DMA-ing arbitrary data over the whole RAM. I am currently not 
> > able to imagine a scenario how this could be made "secure" (without 
> > storing private keys to sign the hibernation image on the machine itself 
> > which, well, doesn't sound secure either).
> 
> shim generates a public and private key. It hands the kernel the private 
> key in a boot parameter and stores the public key in a boot variable. On 
> suspend, the kernel signs the suspend image with that private key and 
> discards it. On the next boot, shim generates a new key pair and hands 
> the new private key to the kernel along with the old public key. The 
> kernel verifies the suspend image before resuming it. The only way to 
> subvert this would be to be able to access kernel memory directly, which 
> means the attacker has already won.

"crash" utility has module which allows reading kernel memory. So leaking
this private key will be easier then you are thinking it to be.

Thanks
Vivek
