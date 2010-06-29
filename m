Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab0F2C4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:56:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48903 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0F2C4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:56:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Cc: kosaki.motohiro@jp.fujitsu.com, Greg KH <gregkh@suse.de>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <1277769867.8354.531.camel@nimitz>
References: <20100628154455.GA13918@suse.de> <1277769867.8354.531.camel@nimitz>
Message-Id: <20100629115232.38BC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 29 Jun 2010 11:56:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2010-06-28 at 08:44 -0700, Greg KH wrote:
> > > The directories being created are the standard directories, one for each of the memory
> > > sections present at boot.  I think the most used files in each of these directories
> > > is the state and removable file used to do memory hotplug.
> > 
> > And perhaps we shouldn't really be creating so many directories?  Why
> > not work with the memory hotplug developers to change their interface to
> > not abuse sysfs in such a manner? 
> 
> Heh, it wasn't abuse until we got this much memory.  But, I think this
> one is pretty much 100% my fault.
> 
> Nathan, I think the right fix here is probably to untie sysfs from the
> sections a bit.  We should be able to have sysfs dirs that represent
> more than one contiguous SECTION_SIZE area of memory.

Why do we need abi breakage? Yourself talked about we guess ppc don't
actually need 16MB section. I think IBM folks have to confirm it.
If our guessing is correct, the firmware fixing is only necessary.

Thats said, I don't 100% refuse your idea. it's interesting. but, 
In generical I hate _unncessary_ abi change.


> It will mean re-teaching some of the tools how things work.  They'll
> have to know that you can split mem sections, and we'll have to come up
> with a way to do the splitting.  
> 
> Does ppc *really* remove 16MB sections of RAM these days?  It's probably
> worth checking with the firmware folks to see what the limits are in
> practice.
> 
> -- Dave
> 



