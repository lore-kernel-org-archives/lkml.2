Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab1EUFP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 01:15:56 -0400
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:50797 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229Ab1EUFPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 01:15:50 -0400
X-ASG-Debug-ID: 1305954948-01c65a06b01704f0001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
X-Barracuda-BWL-IP: 192.168.1.136
X-Barracuda-BBL-IP: 192.168.1.136
X-Barracuda-RBL-IP: 192.168.1.136
Mime-Version: 1.0 (Apple Message framework v1084)
X-ASG-Orig-Subj: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
Content-Type: text/plain; charset=us-ascii
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <efad20cd4c664cd78e153b0fda2de605@HUBCAS2.cs.stonybrook.edu>
Date: Sat, 21 May 2011 01:15:46 -0400
Cc: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "nbd@openwrt.org" <nbd@openwrt.org>, "neilb@suse.de" <neilb@suse.de>,
        "hramrach@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp@gmail.com" <jordipujolp@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <B61DE78E-D7DB-4EB3-B8B3-64912D8BB212@fsl.cs.sunysb.edu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu> <103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu> <D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu> <B0729E4C-D581-4EAB-A175-A6B8B34692B5@fsl.cs.sunysb.edu> <efad20cd4c664cd78e153b0fda2de605@HUBCAS2.cs.stonybrook.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.1084)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1305954948
X-Barracuda-URL: http://130.245.126.20:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64350
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 20, 2011, at 10:25 AM, Miklos Szeredi wrote:

> Erez Zadok <ezk@fsl.cs.sunysb.edu> writes:
>> Niklos, I forgot to mention that I had to apply a small fix to a VFS
>> bug in fs/namei.c:1362, where a mix of symlinks and renames, using
>> racer, triggers an BUG_ON at the VFS layer (very reproducible).
>> Without this fix, racer oopses in the VFS well before it gets to
>> trigger overlayfs bugs.  It's a pity 2.6.39 was released with this
>> very reproducible *VFS* level bug (doesn't anyone run racer+fsx+ltp
>> before releasing a new kernel?)
>> 
>> Anyway, here's the small patch here.  Clearly viro/hch need to review
>> this "fix" b/c I'm not sure it's really the right one
> 
> Patch looks good to me.
> 
> Acked-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> If you've got a patch fixing a serious bug, you'd better send it to
> Linus and Andrew (as well as the VFS maintainers), where it'll get more
> prompt evaluation.
> 
> You can still do that, also adding "CC: stable@kernel.org" to the SOB
> block in the patch so that the fix quickly makes it into the 2.6.39
> stable series.
> 
> Thanks,
> Miklos

Thanks.  I'll do that.

Erez.

