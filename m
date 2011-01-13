Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1AML0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:26:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625Ab1AML03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:26:29 -0500
Message-ID: <4D2EE156.1050006@redhat.com>
Date: Thu, 13 Jan 2011 12:26:14 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Tejun Heo <tj@kernel.org>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com>	<4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org>
In-Reply-To: <20110113110640.GC30719@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 12:06 PM, Tejun Heo wrote:
> Urgh... gees, so there actually was a user using all that cruft.
> Sorry about the breakage, I'll see how multiple symlinks can be
> restored.  I'm curious why this was added at all tho.  What was the
> rationalization?  It's not like two subsystems can share the same
> block device so marking the currently owning subsystem should have
> been enough at the block layer.  There is no reason for block devices
> to present information which is of no use to itself.  All that's
> necessary is "this is taken by dm or md for more information, query
> those".  dm and md need their own conf/representation layer anyway.

I am not sure if I understand it correctly, but multiple holders/slaves
links are very useful in userspace to present device dependences.

We just implemented lsblk command in util-linux which simple prints
tree according to these links, so dependendes of DM/MD/whatever devices
can be printed without using any system specific callbacks, just using
sysfs. See http://karelzak.blogspot.com/2010/12/lsblk8.html

Whatever changes are needed, please keep this functionality, it can be useful.

Thanks,
Milan
