Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab0I0Xzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:55:52 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:36700 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab0I0Xzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:55:51 -0400
Message-ID: <4CA12F01.2@cesarb.net>
Date: Mon, 27 Sep 2010 20:55:45 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?TWljaGHFgiBQaW90cm93c2tp?= <mkkp4x4@gmail.com>,
        Chuck Ebbert <cebbert@redhat.com>, kernel@lists.fedoraproject.org
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
References: <4C9AA546.6050201@cesarb.net> <20100923123849.8975fe47.akpm@linux-foundation.org> <20100927222548.GG3610@quack.suse.cz>
In-Reply-To: <20100927222548.GG3610@quack.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-09-2010 19:25, Jan Kara escreveu:
> [Added CCs for similar ecryptfs warning]
> On Thu 23-09-10 12:38:49, Andrew Morton wrote:
>>> [...]
>>> device fsid 44d595920ddedfa-3ece6b56e80f689e devid 1 transid 22342
>>> /dev/mapper/vg_cesarbinspiro-lv_home
>>> SELinux: initialized (dev dm-3, type btrfs), uses xattr
>>> ------------[ cut here ]------------
>>> WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
>>> Hardware name: Inspiron N4010
>>> Dirtiable inode bdi default != sb bdi btrfs
>    That suggests that we should probably handle such cases in a more generic
> way by changing the code in inode_init_always(). The patch below makes at
> least btrfs happy for me... Could you maybe test it? Thanks.

Applied on top of v2.6.36-rc5-151-g32163f4, running it right now. The 
warning messages no longer happen, and everything seems to be working fine.

Tested-by: Cesar Eduardo Barros <cesarb@cesarb.net>

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
