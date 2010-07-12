Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0GLHJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 03:09:14 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:33885 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab0GLHJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 03:09:13 -0400
Message-ID: <4C3ABF96.9070405@msgid.tls.msk.ru>
Date: Mon, 12 Jul 2010 11:09:10 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
CC: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
In-Reply-To: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12.07.2010 09:24, Giangiacomo Mariotti wrote:
> Hi, is it a known problem how much slow is Btrfs with kvm/qemu(meaning
> that the image kvm/qemu uses as the hd is on a partition formatted
> with Btrfs, not that the fs used by the hd inside the kvm environment
> is Btrfs, in fact inside kvm the / partition is formatted with ext3)?
> I haven't written down the exact numbers, because I forgot, but while
> I was trying to make it work, after I noticed how much longer than
> usual it was taking to just install the system, I took a look at iotop
> and it was reporting a write speed of the kvm process of approximately
> 3M/s, while the Btrfs kernel thread had an approximately write speed
> of 7K/s! Just formatting the partitions during the debian installation
> took minutes. When the actual installation of the distro started I had
> to stop it, because it was taking hours! The iotop results made me
> think that the problem could be Btrfs, but, to be sure that it wasn't
> instead a kvm/qemu problem, I cut/pasted the same virtual hd on an
> ext3 fs and started kvm with the same parameters as before. The
> installation of debian inside kvm this time went smoothly and fast,
> like normally it does. I've been using Btrfs for some time now and
> while it has never been a speed champion(and I guess it's not supposed
> to be one and I don't even really care that much about it), I've never
> had any noticeable performance problem before and it has always been
> quite stable. In this test case though, it seems to be doing very bad.

This looks quite similar to a problem with ext4 and O_SYNC which I
reported earlier but no one cared to answer (or read?) - there:
http://permalink.gmane.org/gmane.linux.file-systems/42758
(sent to qemu-devel and linux-fsdevel lists - Cc'd too).  You can
try a few other options, esp. cache=none and re-writing some guest
files to verify.

/mjt
