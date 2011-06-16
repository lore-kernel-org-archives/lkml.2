Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1FPAos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:44:48 -0400
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:49739 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab1FPAop convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:44:45 -0400
X-ASG-Debug-ID: 1308185076-01c65a06b02452a0001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
X-Barracuda-BWL-IP: 12.201.122.242
X-Barracuda-Apparent-Source-IP: 12.201.122.242
X-Barracuda-BBL-IP: 12.201.122.242
X-Barracuda-RBL-IP: 12.201.122.242
Mime-Version: 1.0 (Apple Message framework v1084)
X-ASG-Orig-Subj: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Content-Type: text/plain; charset=windows-1252
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <803fd88dc28748428861b75afdee3575@HUBCAS1.cs.stonybrook.edu>
Date: Wed, 15 Jun 2011 17:44:33 -0700
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "nbd@openwrt.org" <nbd@openwrt.org>,
        "hramrach@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp@gmail.com" <jordipujolp@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B723B526-D658-4D22-A9CE-598444148B07@fsl.cs.sunysb.edu>
References: <20110609125114.8dff08da.akpm@linux-foundation.org> <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk> <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl> <803fd88dc28748428861b75afdee3575@HUBCAS1.cs.stonybrook.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.1084)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1308185076
X-Barracuda-URL: http://130.245.126.20:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66193
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2011, at 8:49 AM, Miklos Szeredi wrote:

> It's not to make sure that modifications of underlying filesystems will
> have sane semantics.

Miklos, I agree with you. I think it makes perfect sense for overlayfs at this point not to bother with users who modify lower files directly, and expect sane semantics at the upper layer.  Most unioning users do NOT do that anyway, but the few who do cause unioning code to be much more complex.

That said, if users do go and add/del files below overlayfs, it shouldn't oops...

I've often been bothered by people who suggested that stackable file systems must solve the "cache coherency" problem and must perfectly detect lower-level changes consistently.  A lot of code in Unionfs is spent on cache coherency.

Ecryptfs has been around for several years, and I've yet to see the masses scream for upper/lower layer consistency.  NFS works just fine for years and no one expects changes to server-side disk-based file system to be reflected immediately and correctly on al clients.  Asking overlayfs or other stackable file systems to solve this multi-layer coherency perfectly is somewhat ridiculous: we don't expect file systems like ext3 to detect and correctly handle changes to lower devices — i.e., if someone hand-edited direct blocks in /dev/sda1, do we?

The union mount team also tried to handle this issue (the so-called "really really NFS readonly" idea).  And it's really hard — and unnecessary for v1 of a unioning solution.

Skip this can of worms, Miklos.  And you'll be happier for it. :-)  I think your approach of keeping Overlayfs small for now is absolutely the right way.

Cheers,
Erez.

