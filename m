Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2CCLJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:09:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:59385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2CCLIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:08:23 -0500
Message-ID: <4F51FB9D.1020206@kernel.dk>
Date: Sat, 03 Mar 2012 12:08:13 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] block, sx8: fix pointer math issue getting fw version
References: <20120302190042.GB3951@elgon.mountain> <4F51C103.507@kernel.dk> <4F51C18C.5080903@kernel.dk> <20120303080449.GK22598@mwanda>
In-Reply-To: <20120303080449.GK22598@mwanda>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2012-03-03 09:04, Dan Carpenter wrote:
> On Sat, Mar 03, 2012 at 08:00:28AM +0100, Jens Axboe wrote:
>> On 2012-03-03 07:58, Jens Axboe wrote:
>>> On 2012-03-02 20:00, Dan Carpenter wrote:
>>>> "mem" is type u8.  We need parenthesis here or it screws up the pointer
>>>> math probably leading to an oops.
>>>
>>> Applied, thanks Dan. I have marked it stable, too.
>>
>> Hmm wait Dan, seems to me that u8 pointer math should be equiv to char *
>> pointer math and hence it'd work just fine. Are you sure this is a bug?
> 
> It's the cast on the line before is what breaks it.  We need the
> parentheses so we add first then cast the result.

Ah indeed, missed that. Thanks!

- -- 
Jens Axboe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPUfuYAAoJEPfTWPspceCm05AQAKfdxDDY2roFrTcOE5u0wKgL
UHXWmliwZAZLKbX939KdXHtnIhT3ylymRlRGAevGvp76GkjjRD1uaXywa3RPCG50
Ri3lOfUmXwQj5GJSmreFApvErMd2hKKTV3ARMtspd5HsAoABNHq+lrhXMsW90/hT
fa4IPjvKXP64FKKXmfr/MQ8d1bAVcYwvkfZsps2KS8Uj8EUr42AZt6bKMa0EOxxs
swgc3lQ2cwV+BmdjHTApkhH9lTzlot9bchPXYcPGDfWAtFO/MdrZ6ZNsR0Ak3LAN
0OOATReL5uupRgiHiHEJtym2jLSKc0RfJnU5qpgp5S9+Qbc5/j2Lt6M2yHysnTsW
POprT18pOm7lIPhdOCcSy55gW+UxVIWbqAr/5KuZNa1fAZxtghpPRQUOjkJhCdZV
vaFgoQCwDKZ5bjfWZ3NJxY5Di87M9JKyYrgh1XmmLInRqC4iBi5IdLdi54TmMJBo
pqLTFnDy1NaCf4E4xQqxuRTKcJyHt8QToMb2infP2Mz++jGZpygkiCUtIZwiDmq/
/J8MS9y2pNJDIZn71pyBIEQkgSXjerLqc5gEbUsszXo5w22r/VtR3PzVWGIK59Wq
RXhShLaLD7fPVpnlIVcoivv7O9EDXaEwFlqRI4mt68PGndmFcqWLFeV/8mbHP5ce
VZg3X+JY9CNxL4xvqGhb
=ORht
-----END PGP SIGNATURE-----
