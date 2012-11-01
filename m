Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab2KAJFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:05:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab2KAJFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:05:45 -0400
Message-ID: <50923B65.4060304@gmail.com>
Date: Thu, 01 Nov 2012 10:05:41 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, maillist@superlative.org
Subject: Re: [alsa-devel] Idea: dynamic loading of USB quirks
References: <2390628.MpxcLPPhM0@kamdesktop>
In-Reply-To: <2390628.MpxcLPPhM0@kamdesktop>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc lkml as this might be of broader interest]

On 01.11.2012 00:32, maillist@superlative.org wrote:
> Dear Alsa community,
> I've some minor contributions in the form of patches for USB quirks for 
> devices in the past. It occurred to me that having these USB quirks hardcoded 
> into the driver maybe isn't the best thing.
> 
> Looking at the current quirks file, the majority of them are relatively trivial 
> and are really just there to give the USB driver a nudge in the right 
> direction.
> 
> Having to have these hardcoded into the driver creates a number of issues:
> 
> 1. It needs someone with the expertise and will, and access the specific device 
> for testing, to build the quirk. To hardened ALSA hackers this seems trivial, 
> but to an average end user who has a device they want to get supported, this 
> can be pretty inpenatrable. The complexity of just getting the alsa source 
> installed and set up for compilation is enough to put off the vast majority of 
> users.
> 
> 2. It makes the process of getting the driver "to market" lengthy as these 
> changes have to go through all of the normal release schedules, and these are 
> pretty opaque.
> 
> 3. It makes getting changing a driver (because of a bug, or a new release of 
> hardware) difficult as the revisions need to go through the whole process of 
> creating a patch, getting it accepted, and then the long kernel release 
> process, as well as the various distribution release processes.
> 
> It occured to me that there might be a better way where quirks like this could 
> be dynamically loaded into the driver after it has loaded. This would a 
> structured text file describing the quirk to be created and pushed into the 
> driver. Ultimately this could be wrapped into a framework where quirk files 
> could be put into a common directory (similar to modprobe.d) with a startup 
> script which pushed these into the driver.

The idea is interesting, but we would need to find a way to not only
cover the entries in quirks-list.h but the other hard-coded details as well.

I fear that if quirk fixups are done on both the kernel level and loaded
from userspace, it actually makes debugging and maintainance harder.

Then again, if a versatile and clean solution to this problem is found,
there would be tons of other drivers in Linux to benefit from it, just
think about the hda driver to begin with. But not only in the ALSA area.


Daniel

