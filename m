Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab1ANSXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:23:44 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36330 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab1ANSXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:23:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wPIvqrPV5bYlDDIPd7TgwXWCOAH0NfHJAxTOHzfrmHkQkNG95kqUGv/AkbXOevBxI+
         jHiv5eh/ozp7iDsIPRNn1bKryieyxyNfOfYThwUhqdCy+0AgoU1vwYCg9hIvzT7VaAm4
         Bn6GA0Ub0Vtq74K6lJ1s+OLfxUzDaqmKZEgtU=
MIME-Version: 1.0
In-Reply-To: <20110114175942.GK31800@thunk.org>
References: <20110113132637.GH16523@nb.net.home>
	<20110113133722.GG30719@htj.dyndns.org>
	<4D2F04FF.1070309@redhat.com>
	<20110113141107.GI30719@htj.dyndns.org>
	<4D2F0B6A.6010201@redhat.com>
	<AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
	<656A2F9B-4E1C-44AA-80CB-9E3428E26CDE@mit.edu>
	<20110114071858.7eee145c@notabene.brown>
	<20110113204145.GC31800@thunk.org>
	<20110114162022.GC978@htj.dyndns.org>
	<20110114175942.GK31800@thunk.org>
Date: Fri, 14 Jan 2011 19:23:40 +0100
X-Google-Sender-Auth: kvruyvV4Y-6N7pU8q6vBmDOKiok
Message-ID: <AANLkTinj49yFOhomPuAO-X5GU6wM0yi4jDZyer63RnjJ@mail.gmail.com>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
From: Tejun Heo <tj@kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
        NeilBrown <neilb@suse.de>, Milan Broz <mbroz@redhat.com>,
        Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ted.

On Fri, Jan 14, 2011 at 6:59 PM, Ted Ts'o <tytso@mit.edu> wrote:
> Yes, agreed.  My point was that if we have a better system, we could
> migrate blkid and other users to new interface, and maybe in a few
> years, we can deprecate that interface.  So we do have to maintain
> them for at least the medium term, but that shouldn't stop us from
> divising a better interface, and then gradually migrating systems to
> use that newer and better interface.

Oh yeah, fully agreed there and the implementation at the block layer
isn't even gonna be difficult.  Just a single attribute which contains
a string which can be specified at the time of claiming.  We probably
can introduce a new interface where the @holder is always a string the
content of which should uniquely identify the holder in human/machine
readable form and add a few helpers to format those strings so that
the same type of usages use consistently formatted strings.  For
nested devices, kdev should do.  For filesystems, the mount point
maybe (it should be something which identifies it absolutely)?  For
specific programs (cd burner, whatnot), pid and so on.

The only question is, would that be actually necessary?  By now, we
already have mostly working reverse mapping for most things which
matter through blkid, fs information, fd listing under proc and so on.
 They sure are ugly and probably unreliable at times but is it
pressing enough to introduce new interface and migrate things over or
would we be just creating churns?  I don't really know how these
things look from userland so am genuinely unsure what the answer is.

Thanks.

-- 
tejun
