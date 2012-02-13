Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab2BMWSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:18:36 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:13865 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2BMWSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:18:35 -0500
X-Authority-Analysis: v=2.0 cv=XsF4yC59 c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=ODbK2BMGt0IA:10 a=2WZXf8VwxVAA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=VJC23yv4v7J3gei8j-IA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4F398C39.6010901@ubuntu.com>
Date: Mon, 13 Feb 2012 17:18:33 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        Karel Zak <kzak@redhat.com>, maxim.patlasov@gmail.com
Subject: Re: [PATCH 0/2] block: online resize of disk partitions
References: <1329161438-12602-1-git-send-email-vgoyal@redhat.com> <4F3981FE.7090601@ubuntu.com> <20120213215039.GD3130@redhat.com>
In-Reply-To: <20120213215039.GD3130@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/13/2012 4:50 PM, Vivek Goyal wrote:
> So if a user anyway does not specify the start of sector, then 
> tools shall have to first read it and then call the ioctl. If 
> anyway tools are specifying, there is no much scope of screwing up 
> the things?

Tools certainly should know where the partition starts.  I already
have patched parted and partx to pass the current size, which they
had trivially available.  Making sure of that is a good sanity check
to guard against, for instance, resizing the wrong partition.

> Even if we allow changing start at some point of time, then IOCTL 
> can remain the same and just the implementation will change in a 
> backward compatible manner. Old tools still will continue to work 
> as they have always been, and new ones can start passing "start" 
> too.
> 
> So I really did not find passing and checking "start" of partition
>  very appealing.

That is exactly why passing and checking start is required.  If it is
entirely ignored, then the interface can not start using it in the
future in a backward compatible way, because user mode tools will have
grown used to passing in any kind of garbage, so if the kernel starts
using it to alter the start position of the partition, older tools
would randomly and accidentally be shifting the the start of
partitions they just mean to change the length of.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPOYw5AAoJEJrBOlT6nu75CV4H/2vyZwujRqb+mqTAfQ+/XJE7
E850b+MOFZEQEoKQy+XAeu15pmm/TIa8NTk83kBeoQb30P2sU814+rJjbMKpZ9x/
xc8DZVC+DdnLLJ8a9aQw5feV0nmy102QrL0CWS+Wi6vS3DLlLCQQ+nv7AZ1jPV0Z
NPzqtmI/zBopf/F2IrL+5DLD9TAi7mf+Yv5IBb7w2JQSiU9LoBo9TTMJhPAhaqtC
ihqSJ0Q/t0DG3WacK+8fwh6Jyta1Bx+YsoUzYijtsaH6GQ1zbe+3c44T1JMI+Zvq
30M8V7y1BsLhp+lfZSUlC5YvPpu7gCJ1lg2fpMz56q2DENURj3L1HkdFwPwfLcw=
=TTAk
-----END PGP SIGNATURE-----
