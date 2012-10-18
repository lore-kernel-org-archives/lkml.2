Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2JRXNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:13:15 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53642 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab2JRXNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:13:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/3] PM / Runtime: force memory allocation with no I/O during runtime_resume callbcack
Date: Fri, 19 Oct 2012 01:16:58 +0200
Message-ID: <11374134.vToUn932b7@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CACVXFVP-JerxiTU9Kr9Lrwe2XkKBU=EsZJUcEiPVCQWw6iiw2Q@mail.gmail.com>
References: <1350403183-12650-1-git-send-email-ming.lei@canonical.com> <6431373.tJcdR3m2Df@vostro.rjw.lan> <CACVXFVP-JerxiTU9Kr9Lrwe2XkKBU=EsZJUcEiPVCQWw6iiw2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 of October 2012 19:07:25 Ming Lei wrote:
> On Wed, Oct 17, 2012 at 1:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > This appears to be a bit too heavy handed.  First of all, it seems to affect
> > all memory allocations going in parallel with the resume callback.  Second,
> 
> No, the flag is per task, only memory allocation inside resume callback
> is effected.

OK

> > it affects all resume callbacks, not only those where the problem really
> 
> We can do it only on block device, block device's ancestor and network
> devices(iSCSI case), but that may introduce policy into PM core or add
> one flag of memalloc_noio_resume into 'dev_pm_info', could you agree
> on it?

Well, the question is how many runtime resume callbacks actually allocate
memory.  If they are not too many, we can just flag all of them.  Otherwise,
adding a flag may be a better approach.  I'm not sure ATM.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
