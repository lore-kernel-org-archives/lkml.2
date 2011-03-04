Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342Ab1CDJCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:02:49 -0500
Received: from lo.gmane.org ([80.91.229.12]:57083 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab1CDJCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:02:45 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el.es.cr@gmail.com>
Subject: Re: [REVIEW] NVM Express driver
Date: Fri, 4 Mar 2011 09:02:33 +0000 (UTC)
Message-ID: <loom.20110304T095238-128@post.gmane.org>
References: <20110303204749.GY3663@linux.intel.com> <20110303211336.GA32645@kroah.com> <20110303214104.GZ3663@linux.intel.com> <20110303215155.GA30451@kroah.com> <20110303220735.GA3663@linux.intel.com> <20110303222226.GA30966@kroah.com> <4D704DAB.9080100@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 217.36.116.108 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.14) Gecko/20110218 Firefox/3.6.14 ( .NET CLR 3.5.30729))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto <at> MIT.EDU> writes:

> 

> > I didn't even realize we had a firmware README file...
> >
> > Anyway, just use request_firmware_nowait(), you will be fine.
> >
> 
> Unless I'm misunderstanding the spec, this is for *nonvolatile* firmware 
> updates.  So if I have two of these devices and I stick a firmware file 
> into /lib/firmware, should it update both devices?
> 
> Shouldn't reflashing the device firmware be something that the users 
> asks for by something a little more specific than just creating a file? 
>   (In any case, creating /lib/firmware/nvmhci-3 to flash slot 3 seems 
> rather silly.)
> 

_lame user warning on_

if module is built-in, maybe something like /sys/class/nvm/driveX/fw_path could
receive the _path_ to firmware, so that writing to it (either/or writing to
hypothetical /sys/class/nvm/driveX/fw_do_update) would trigger the flashing
procedure, and reading it would provide _human readable_ flashing progress
information ?

If module is complied, well, as a module, could be invoked with the fw_path
parameter and the fw_do_update parameter as the safety flag.

With appropriate safety measures, like making sure drive is unmounted, queue is
empty and so on, ensured in userspace?

> --Andy
> 

el es


