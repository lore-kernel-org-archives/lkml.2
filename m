Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab0F2AEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:04:32 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37888 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab0F2AEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:04:31 -0400
Subject: Re: [PATCH] memory hotplug disable boot option
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20100628154455.GA13918@suse.de>
References: <87d3vfeage.fsf@basil.nowhere.org>
	 <4C24C279.3050206@austin.ibm.com>
	 <20100628110658.387B.A69D9226@jp.fujitsu.com>
	 <20100628150246.GA13192@suse.de> <4C28C1A8.8010904@austin.ibm.com>
	 <20100628154455.GA13918@suse.de>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Mon, 28 Jun 2010 17:04:27 -0700
Message-ID: <1277769867.8354.531.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 08:44 -0700, Greg KH wrote:
> > The directories being created are the standard directories, one for each of the memory
> > sections present at boot.  I think the most used files in each of these directories
> > is the state and removable file used to do memory hotplug.
> 
> And perhaps we shouldn't really be creating so many directories?  Why
> not work with the memory hotplug developers to change their interface to
> not abuse sysfs in such a manner? 

Heh, it wasn't abuse until we got this much memory.  But, I think this
one is pretty much 100% my fault.

Nathan, I think the right fix here is probably to untie sysfs from the
sections a bit.  We should be able to have sysfs dirs that represent
more than one contiguous SECTION_SIZE area of memory.

It will mean re-teaching some of the tools how things work.  They'll
have to know that you can split mem sections, and we'll have to come up
with a way to do the splitting.  

Does ppc *really* remove 16MB sections of RAM these days?  It's probably
worth checking with the firmware folks to see what the limits are in
practice.

-- Dave

