Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab1AMQBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:01:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab1AMQBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:01:41 -0500
Date: Thu, 13 Jan 2011 16:59:55 +0100
From: Karel Zak <kzak@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, Milan Broz <mbroz@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
	bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110113155955.GI16523@nb.net.home>
References: <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home> <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home> <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com> <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com> <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com> <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 03:43:38PM +0100, Kay Sievers wrote:
> On Thu, Jan 13, 2011 at 15:30, Tejun Heo <tj@kernel.org> wrote:
> > On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> wrote:
> >> Maybe, but this was not invented in DM/MD camp:-)
> >> Probably Kay or Greg can answer why it was done this way?
> 
> It's not from Greg or Kay. It just appeared some day in the context of dm. :)
> 
> And yes, symlinks *look* nice and simple for the outside, but they are
> not, and have all sorts of problems like non-atomic updates, make it

 Sounds like sysfs implementation problem, right?

 If there is noway to fix sysfs then we can add a generic ioctl or
 /sys/block/<device>/{slave,holder}_list files with list of
 holders/slaves.
 
 But please, don't force userspace to use *claimer-specific*
 methods to answer *generic questions* like slave/holder dependencies
 between devices.
 
> impossible to ever rename a device (as long as they copy the device
> name), and and and .... we should not add more of this.
> 
> >> If btrfs internally creates some virtual _block_ device for its pool, it should
> >> present it here too with slaves/holders. If not, why it should create any links there?
> >
> > Yeah, that's the most bothering part for me.  The biggest customers of
> > bd_claim are filesystems and all these custom symlinkeries don't do
> > nothing for them.  It just doesn't make a whole lot of sense to me.
> 
> Btrfs does not use any blockdev as the master for good reason, and it
> can never map its slaves inside of /sys/block. 

 Yep, expected and correct response :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
