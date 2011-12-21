Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1LUBx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:53:56 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:6103 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1LUBxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:53:54 -0500
X-Authority-Analysis: v=2.0 cv=ePqRfQV1 c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=acFpV6Ajmw0A:10 a=LNmbJxpDd3oA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=lQWq1fzGOqTovcLxVWYA:9 a=wPNLvfGTeEIA:10 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4EF13C30.4050307@cfl.rr.com>
Date: Tue, 20 Dec 2011 20:53:52 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: joe@perches.com, kzak@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <4EE6990A.9010202@cfl.rr.com> <1323735382-5972-1-git-send-email-psusi@cfl.rr.com> <20111219202527.GF7175@redhat.com>
In-Reply-To: <20111219202527.GF7175@redhat.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/19/2011 03:25 PM, Vivek Goyal wrote:
> Are there any restrictions on order of partition bdev and disk bdev
> locking.

Good point, yes, it seems you need to take the partition first.  Now that I think about it though, I don't think we need the disk mutex at all.  I thought you needed to hold it in order to iterate over the partitions, but it looks like you don't since that uses an RCU, right?

I guess we'll go for another try.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJO8TwsAAoJEJrBOlT6nu75PIwIAJiPhnaRKJokVxzgzg3UQLb+
jPLgzl3a/lD9PcDdg50ol8rYSwqTXUgWjncFwV752nIEsTV/3kGRGfvgkmO25PsS
vjkPjL3rubGmYk2n3QPCU5SNIm1iH7CtyTxHcU2e/qUdfccF5jwo38mPd3xYw/IY
GEngNnXwmDDoVttHFK+WDuHpxltZb60quIeVtBhdJQxff6npY78G3dNdKnbvwAb6
v97ZNPDMt5vXOCqA7vWYMLZbJMW5FzDCEr3ehTUOaegT3HgXyRa3tpWDnih3/nyT
WI1ngR9qou2qpu13FxS4h8GI4zWyPxgd4EOVqD7JlAE5Z6hTne5Z0fo2VJkVK3A=
=ZC+O
-----END PGP SIGNATURE-----
