Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1K2QeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 11:34:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1K2QeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 11:34:19 -0500
Message-ID: <4ED5096A.8060706@redhat.com>
Date: Tue, 29 Nov 2011 10:33:46 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Surbhi Palande <csurbhi@gmail.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
References: <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com> <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com> <20111129101901.GA5635@quack.suse.cz> <20111129102156.GA7463@quack.suse.cz> <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com> <20111129111136.GC5635@quack.suse.cz> <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com> <20111129130913.GE5635@quack.suse.cz> <20111129131811.GS7595@agk-dp.fab.redhat.com> <20111129133239.GA9926@quack.suse.cz>
In-Reply-To: <20111129133239.GA9926@quack.suse.cz>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/29/11 7:32 AM, Jan Kara wrote:
> On Tue 29-11-11 13:18:11, Alasdair G Kergon wrote:
>> On Tue, Nov 29, 2011 at 02:09:13PM +0100, Jan Kara wrote:
>>>   Hmm, then why do these operations suspend the filesystem if they
>>> apparently don't need it? Sorry for my ignorance, I never seriously worked
>>> with LVM code...
>>
>> They don't suspend it if they don't need to.
>>
>> dm-ioctl.h:
>> /*
>>  * Set this to avoid attempting to freeze any filesystem when suspending.
>>  */
>> #define DM_SKIP_LOCKFS_FLAG     (1 << 10) /* In */
>   Thanks. I was now checking in detail and indeed FIFREEZE fails if
> ->freeze_fs is not set. And only xfs, ext3, ext4, reiserfs, jfs, nilfs2,
> and gfs2 provide this function. So I was correct in assuming that when
> filesystem supports FIFREEZE it must make sure no modifications happen to
> the filesystem. So I believe that my original plan for sync to skip frozen
> filesystem is correct.

Jan, FWIW I agree with this as well.

- -Eric
 
> 								Honza

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO1QlpAAoJECCuFpLhPd7g3wEP/1C7T280LLZHubBMolF1dEp0
qJPQAcMUCcwMn+ewMZF5Pg/Li5WxveLNydzUWURrmnXolHddkvmoUESeJt6ugraT
i0bgb3ICRKpYi/1GEsW8UZQMXWIjdg5qyEvagDou/oy7qPXeND+JTvSYdqoti0Fn
pKv9ZUuU2arPrdDqCHP0lmiU1mF85/h/liB09GdFll3nLvSahJK5N9Cr6d0jG4VL
9faJSKI4EgVvyDPWx+L4mA5aIbPveQY0LbzpS+QSGswkd4ylVvLCV76oYj4jEH7R
hbv8OjgWTEKV8wgqmFFF/HXwzmJqzfT0rFCgbe4ZCJdnNujRe2h/wg5Gpkbj3lWc
htwUZfKKg9Vm9PheqMVxbRYEbWXB+g2Seiv/5fHNNG3WeFuPo15ftcu3Kjj7z/gS
zY1PnkHJj7/fF9tyZyTGb/AXicJyLJN7gWvf8pWNETXd4PfuDHgD70iQfWbZdKfe
0a+G4AGhXJ9zrjImM1vnsq09AMTQApL+Lm+VxdPfUbFBZd9pSC+xbBDKvOl8qy3A
Gllbjtbwi/3hV2S8t4vSLLowRTZqkLC+VHphnyLlwVeHAUsqZXQ58ZrFNx2NaYdL
UGkEty8zHGL08Yglwfd2iSlzDb/0OmCurXSZcAAXH47AAzPxZgN80KFbwc2PsGG7
DC9hxrb1bGZojdDTsuku
=UWkJ
-----END PGP SIGNATURE-----
