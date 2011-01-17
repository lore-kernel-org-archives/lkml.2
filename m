Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab1AQAWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 19:22:13 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54578 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1AQAWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 19:22:11 -0500
Message-ID: <4D338ABC.7020600@ce.jp.nec.com>
Date: Mon, 17 Jan 2011 09:18:04 +0900
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
Subject: Re: [PATCH UPDATED] block: restore multiple bd_link_disk_holder()
 support
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113172133.GE14096@htj.dyndns.org> <4D2F4799.5030901@redhat.com> <4D2FFBED.6010406@ce.jp.nec.com> <20110114161043.GB978@htj.dyndns.org> <4D30BB78.5020101@redhat.com>
In-Reply-To: <4D30BB78.5020101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/11 06:09, Milan Broz wrote:
> On 01/14/2011 05:10 PM, Tejun Heo wrote:
>> Commit e09b457b (block: simplify holder symlink handling) incorrectly
>> assumed that there is only one link at maximum.  dm may use multiple
>> links and expects block layer to track reference count for each link,
>> which is different from and unrelated to the exclusive device holder
>> identified by @holder when the device is opened.
>>
>> Remove the single holder assumption and automatic removal of the link
>> and revive the per-link reference count tracking.  The code
>> essentially behaves the same as before commit e09b457b sans the
>> unnecessary kobject reference count dancing.
>>
>> While at it, note that this facility should not be used by anyone else
>> than the current ones.  Sysfs symlinks shouldn't be abused like this
>> and the whole thing doesn't belong in the block layer at all.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: Milan Broz <mbroz@redhat.com>
>> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>> Cc: Neil Brown <neilb@suse.de>
>> Cc: linux-raid@vger.kernel.org
>> Cc: Kay Sievers <kay.sievers@vrfy.org>
>> ---
>> Thanks for the test commands.  They were very helpful.  Can you please
>> test this one?
> 
> Hi,
> 
> yes, this one works for me. I run full lvm2 testsuite and no warnings.
> Thanks!
> 
> Tested-by: Milan Broz <mbroz@redhat.com>

Thanks Tejun, Milan!
If it passed my quick test and the lvm2 testsuite,
I have nothing to add here.
And the code looks ok, too.

-- 
Jun'ichi Nomura, NEC Corporation
