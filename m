Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030356Ab2CVAbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:31:24 -0400
Received: from mx2.netapp.com ([216.240.18.37]:47237 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab2CVAbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:31:21 -0400
X-IronPort-AV: E=Sophos;i="4.73,627,1325491200"; 
   d="scan'208";a="635324194"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "keyrings@linux-nfs.org" <keyrings@linux-nfs.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        NFS list <linux-nfs@vger.kernel.org>,
        "Bhamare, Sachin" <sbhamare@panasas.com>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, James Morris <jmorris@namei.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCHSET 0/4] kmod: Optional timeout on the wait in
 call_usermodehelper_exec
Thread-Topic: [PATCHSET 0/4] kmod: Optional timeout on the wait in
 call_usermodehelper_exec
Thread-Index: AQHNBu/isuSa5/nBCk2i8l4LhPQDU5Z1V+qAgACSCoCAAAO1gA==
Date: Thu, 22 Mar 2012 00:31:17 +0000
Message-ID: <1332376277.12332.22.camel@lade.trondhjem.org>
References: <4F691059.30405@panasas.com> <20120321153519.GB30250@kroah.com>
	 <4F6A6FB9.7010508@panasas.com>
In-Reply-To: <4F6A6FB9.7010508@panasas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <23EC75A11C17FD4D86711760AF5BA2C3@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2M0VUwq016206

On Wed, 2012-03-21 at 17:18 -0700, Boaz Harrosh wrote:
> On 03/21/2012 08:35 AM, Greg KH wrote:
> > On Tue, Mar 20, 2012 at 04:18:49PM -0700, Boaz Harrosh wrote:
> >> Andrew Hi
> >>
> >> I'm picking on you because I don't have any one else to pick on.
> >> The 3 first patches here, are just good for today. Please see if
> >> you would like to take them? or tell me who should take them?
> >>
> >> The 4th patch is an RFC, which got me looking into this.
> >>
> >> My motivation is that I added yet another Kernel dependency on the
> >> call_usermodehelper() function and am not completely happy with the
> >> error case of having the user-mode program stuck forever. In such
> >> case I would like the Kernel part to timeout and properly error recover
> >> and clean up. So therefor the proposed 4th patch.
> > 
> > What is this new use of call_usermodhelper that you are doing this work
> > for?  Ideally, you never want to make this call, as it's slow and messy,
> > as you have found out.  Is there an in-kernel user that you have
> > recently added?
> > 
> > thanks,
> > 
> > greg k-h
> 
> I agree hence my comment in the 4th patch:
> 	"In the blasphemous occasions that a the Kernel must call a user-mode program"
> 
> I have added a new caller, to the nfs/objectlayoutdriver.ko that uses this
> facility for auto-login into osd-targets (iscsi-targets) when new are requested
> by the filesystem. This auto-login facility is mandated by the pnfs-objects
> standard because in a large cluster filesystems for which pnfs was invented, storage
> devices break and changed everyday, and a manual login by every client is not
> feasible.
> 
> You can see this patch as posted to the mailing list here:
> 	http://article.gmane.org/gmane.linux.nfs/48024/match=login
> 	[title: pnfs-obj: autologin: Add support for protocol autologin]
> 
> It works very well and was heavily tested, with all error scenarios, but
> the theoretical possibility that the user-mode program can be stuck forever
> bothers me and I would like to do something about it. With this patch the
> Kernel can recover cleanly and continue. I have actually tested this part
> and it works as expected.

Hi Boaz,

As an alternative suggestion: since you are always calling the
same /sbin/osd_login userspace program, wouldn't it be easier to add the
timeout smarts into that program? If you can't modify the osd_login
program itself, then it should still be trivial to wrap it with a script
that adds the 'timeout' command prefix.

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
