Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0GLFZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 01:25:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53626 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab0GLFZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 01:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=nXqkTsLDY+X+R6Zr44GloIA+Bm0ak+9w3B5OW9qwP8Qh9VTzo7nvCnld8tiPuQwx3S
         TzJ6Cwrw1WxAu+vbVK8qN8IRz2McSed9KV9MbrtYYoubAPyuwo49s7vL1AyW6sJfg6IL
         ZJHSlGivjTQjSRpqgyoCA00oJZPfRbt+xpFXU=
MIME-Version: 1.0
Date: Mon, 12 Jul 2010 07:24:59 +0200
Message-ID: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
Subject: BTRFS: Unbelievably slow with kvm/qemu
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, is it a known problem how much slow is Btrfs with kvm/qemu(meaning
that the image kvm/qemu uses as the hd is on a partition formatted
with Btrfs, not that the fs used by the hd inside the kvm environment
is Btrfs, in fact inside kvm the / partition is formatted with ext3)?
I haven't written down the exact numbers, because I forgot, but while
I was trying to make it work, after I noticed how much longer than
usual it was taking to just install the system, I took a look at iotop
and it was reporting a write speed of the kvm process of approximately
3M/s, while the Btrfs kernel thread had an approximately write speed
of 7K/s! Just formatting the partitions during the debian installation
took minutes. When the actual installation of the distro started I had
to stop it, because it was taking hours! The iotop results made me
think that the problem could be Btrfs, but, to be sure that it wasn't
instead a kvm/qemu problem, I cut/pasted the same virtual hd on an
ext3 fs and started kvm with the same parameters as before. The
installation of debian inside kvm this time went smoothly and fast,
like normally it does. I've been using Btrfs for some time now and
while it has never been a speed champion(and I guess it's not supposed
to be one and I don't even really care that much about it), I've never
had any noticeable performance problem before and it has always been
quite stable. In this test case though, it seems to be doing very bad.

cheers

-- 
Giangiacomo
