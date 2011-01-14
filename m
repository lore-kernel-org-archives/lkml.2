Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab1ANPHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:07:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1ANPHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:07:47 -0500
Date: Fri, 14 Jan 2011 16:07:36 +0100
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
Message-ID: <20110114150736.GJ16523@nb.net.home>
References: <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home> <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com> <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com> <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com> <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com> <20110113155955.GI16523@nb.net.home> <AANLkTimXkF-JNaU12wLecdszMLZkfTh405tNabzEF4L_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimXkF-JNaU12wLecdszMLZkfTh405tNabzEF4L_@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 05:10:02PM +0100, Kay Sievers wrote:
> On Thu, Jan 13, 2011 at 16:59, Karel Zak <kzak@redhat.com> wrote:
> > On Thu, Jan 13, 2011 at 03:43:38PM +0100, Kay Sievers wrote:
> >> On Thu, Jan 13, 2011 at 15:30, Tejun Heo <tj@kernel.org> wrote:
> >> > On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> wrote:
> >> >> Maybe, but this was not invented in DM/MD camp:-)
> >> >> Probably Kay or Greg can answer why it was done this way?
> >>
> >> It's not from Greg or Kay. It just appeared some day in the context of dm. :)
> >>
> >> And yes, symlinks *look* nice and simple for the outside, but they are
> >> not, and have all sorts of problems like non-atomic updates, make it
> >
> >  Sounds like sysfs implementation problem, right?
> 
> It's a normal multi-file problem. It can by-definition not be atomic
> without doing really weird locking things.

 BTW, lsblk(8) and libblkid don't depend on the fact that slaves/holders 
 files are symlinks.
 
 The important thing is the filename (/sys/block/.../slaves/<name>) 
 only. We don't follow the symlinks and we don't use readlink() there.
 
 It means that you can replace the symlinks with regular files where
 in the file contents is for example maj:min, etc.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
