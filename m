Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab1AMUmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:42:14 -0500
Received: from thunk.org ([69.25.196.29]:34791 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933807Ab1AMUmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:42:03 -0500
Date: Thu, 13 Jan 2011 15:41:45 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Milan Broz <mbroz@redhat.com>,
        Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110113204145.GC31800@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
	Tejun Heo <tj@kernel.org>, Milan Broz <mbroz@redhat.com>,
	Karel Zak <kzak@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <20110113122701.GG16523@nb.net.home>
 <20110113131216.GF30719@htj.dyndns.org>
 <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org>
 <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org>
 <4D2F0B6A.6010201@redhat.com>
 <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
 <656A2F9B-4E1C-44AA-80CB-9E3428E26CDE@mit.edu>
 <20110114071858.7eee145c@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114071858.7eee145c@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 07:18:58AM +1100, NeilBrown wrote:
> 
> open(O_EXCL) will fail on a block device if it is being used by anything else
> - a filesystem or a dm target or an md array or ....
> 
> So if the *only* thing you want is "is this currently an active part of
> something else", then O_EXCL works since 2.6.0 (I think).

Unfortunately, that won't distinguish between a currently active file
system, and a device which is being used by a dm target, which is what
we want to do.

						- Ted
