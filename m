Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab1AMO0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:26:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755Ab1AMO0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:26:00 -0500
Message-ID: <4D2F0B6A.6010201@redhat.com>
Date: Thu, 13 Jan 2011 15:25:46 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org> <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home> <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home> <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com> <20110113141107.GI30719@htj.dyndns.org>
In-Reply-To: <20110113141107.GI30719@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 03:11 PM, Tejun Heo wrote:

> So, as a general rule, when in doubt, just create an attribute.  Let's
> refrain from custom symlinkery in sysfs, please.  In this case too, a
> holder attribute containing strings like ext[3|4], md, dm or whatnot
> would have been _much_ simpler and actually more useful.

Maybe, but this was not invented in DM/MD camp:-)
Probably Kay or Greg can answer why it was done this way?

For DM it just added links to be proper user of it, see
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f165921df46a977e3561f1bd9f13a348441486d1

Anyway, it is /sys/block - so it represents block devices.

If btrfs internally creates some virtual _block_ device for its pool, it should
present it here too with slaves/holders. If not, why it should create any links there?

Milan
