Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1ANHjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:39:33 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42343 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab1ANHj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:39:26 -0500
Message-ID: <4D2FFBED.6010406@ce.jp.nec.com>
Date: Fri, 14 Jan 2011 16:31:57 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>, Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Valdis.Kletnieks@vt.edu,
        Alexander Viro <viro@zeniv.linux.org.uk>, Neil Brown <neilb@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] block: restore multiple bd_link_disk_holder() support
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113172133.GE14096@htj.dyndns.org> <4D2F4799.5030901@redhat.com>
In-Reply-To: <4D2F4799.5030901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/14/11 03:42, Milan Broz wrote:
>> Milan, Jun, can you guys please verify this works correctly for the
>> multi holder dm case?  Thank you.
> 
> Hi,
> 
> unfortunately not. And the problem is much worse,
> it breaks lvm resize operation completely.

For quick testing, try this:
("/dev/sdf" can be other block device.
 "testA" and "testB" can be other dm names which aren't used in
 your machine.)

# echo "0 10 linear /dev/sdf 0" | dmsetup create testA
# echo "0 10 linear /dev/sdf 10" | dmsetup create testB
(at this point, /dev/sdf has multiple holders)
# echo "0 20 linear /dev/sdf 10" | dmsetup load testB
(at this point, /dev/mapper/testB has 2 claims on /dev/sdf)
# dmsetup resume testB
(/dev/mapper/testB has 1 claim on /dev/sdf)
# dmsetup remove testA
# dmsetup remove testB


Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
