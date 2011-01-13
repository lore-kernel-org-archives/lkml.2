Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1AMOq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:46:28 -0500
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:54354 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab1AMOq1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:46:27 -0500
X-AuditID: 12074425-b7c98ae000000a04-94-4d2f10423adf
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
Date: Thu, 13 Jan 2011 09:45:54 -0500
Cc: Milan Broz <mbroz@redhat.com>, Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <656A2F9B-4E1C-44AA-80CB-9E3428E26CDE@mit.edu>
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org> <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home> <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home> <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com> <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com> <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
To: Tejun Heo <tj@kernel.org>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAARcg5EE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 13, 2011, at 9:30 AM, Tejun Heo wrote:
>> 
> 
> Yeah, that's the most bothering part for me.  The biggest customers of
> bd_claim are filesystems and all these custom symlinkeries don't do
> nothing for them.  It just doesn't make a whole lot of sense to me.
> 

Well, if there's better way to do things, we can send patches to libblkid to switch away from using sysfs, assuming it's using a new enough kernel.

The primary problem that we're trying to solve is to know whether a particular device contains a file system that should potentially mounted (or fsck'ed, or used as a external journal device, etc.)

If the file system is located on a raid 0 device created using devicemapper, the first physical block device could look like a file system.  So what we want is a very easy way of determining, "is this device being used by the device mapper layer"?   If it is, then it's probably not the droids we are looking for.   We'll keep looking at the rest of the block devices in the system, and when we find the dm-concatenated devices, we can properly identify it.

Can you suggest a better way doing what it is we need to do?

-- Ted

