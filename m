Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2BMVe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:34:58 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:2115 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2BMVe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:34:57 -0500
X-Authority-Analysis: v=2.0 cv=Vv2h8pKn c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=ODbK2BMGt0IA:10 a=2WZXf8VwxVAA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=xLUpYxVHuZlO2GdA4ZMA:9 a=vA2V4egk_aer34GrxWMA:7 a=wPNLvfGTeEIA:10 a=Vr2me_0u0IgR2hMj:21 a=pS6XBza8hWrK9D69:21 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4F3981FE.7090601@ubuntu.com>
Date: Mon, 13 Feb 2012 16:34:54 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        Karel Zak <kzak@redhat.com>, maxim.patlasov@gmail.com
Subject: Re: [PATCH 0/2] block: online resize of disk partitions
References: <1329161438-12602-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1329161438-12602-1-git-send-email-vgoyal@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/13/2012 2:30 PM, Vivek Goyal wrote:
> Hi,
> 
> Following patch adds support for online resizing of a partition.
> This patch is based on previously posted patches by Phillip Susi.
> 
> There are two patches. Out of which one is kernel patch and other
> one is util-linux patch to add support of a user space utility
> "resizepart" to allow resizing the partition.
> 
> This ioctl only resizes the partition size in kenrel and does not
> change the size on disk. A user needs to make sure that
> corresponding changes are made to disk data structures also using
> fdisk(or partx), if changes are to be retained across reboot.
> 
> I made some changes according to the feedback received last time.
> Following are changes since the version Phillip posted.
> 
> - RESIZE ioctl ignores the partition "start" and does not expect
> user to specify one. Caller needs to just specify "device",
> "partition number" and "size" of new partition.

I would prefer that the start argument not be left undefined.  I
checked it to make sure it was unchanged as a simple sanity check to
guard against user space being goofy, as well as to allow for the
possibility of extending the interface in the future to allow changing
the start as well as the length.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPOYH+AAoJEJrBOlT6nu75rvwIALjEMrUZPEvwYzH9MI9wHmGg
lZzeBTSalqEOWL/hM0Ge6o1Of1adjeEyB7riXi7Fbb4Z8U55oBkAyKcRD/fdm0EA
8SyfMnGnMqZjh6VthIZMw43HbNwHojXeu2ri4ygeUORMIrX8tmZLAePw6iuOWcX6
qxOZsJOz3CdoGy2yc362AuIQACKH6IfFimP81NH5uUA01DIawWpes3EuN+KcxOQP
hlIeixVPzlNrXuDY/m35xlXNaXcTUqTYFJ30vvVn0/MHylAbfCXKx6P19jvPHTt9
j0OyBNVnsb/BCKsbSW89lfHoVPMeYC6Kz2u8d1AX5byCxcYcznqclA6S93/UUms=
=ZABC
-----END PGP SIGNATURE-----
