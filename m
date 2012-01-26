Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2AZVsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:48:11 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:29805 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2AZVsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:48:09 -0500
X-Authority-Analysis: v=2.0 cv=ffgvOjsF c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=seg9fo12g4kA:10 a=LNmbJxpDd3oA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=CRqTrgFaUOwqIbQ1F-4A:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4F21CA16.3020002@ubuntu.com>
Date: Thu, 26 Jan 2012 16:48:06 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Maxim Patlasov <maxim.patlasov@gmail.com>, joe@perches.com,
        kzak@redhat.com, linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <CA+X1aCQRpJ_NwJBSBp+vDN37p+oipJNz=6T5LdJdqzxTiSWWWA@mail.gmail.com> <4EFD012D.7040602@cfl.rr.com> <20120126190114.GG1891@redhat.com> <4F21B91E.90106@ubuntu.com> <20120126210456.GC11297@redhat.com>
In-Reply-To: <20120126210456.GC11297@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/26/2012 4:04 PM, Vivek Goyal wrote:
>> Another idea that I had but have not yet checked to see if it is
>>  actually feasible is to copy the struct genhd, change the size
>> of the copy, and replace the existing one since updating the
>> pointer will be atomic.
> 
> You will run into issues if somebody has a pointer stored to 
> genhd.

They are already kept in an RCU list which has the same problem.
Doesn't that deal with it by using reference counters, so the reader
can keep and use the pointer to the old structure just fine, and it
will be cleaned up when they release the reference.

> I think simpler thing would be to stick with sequence counter 
> approach which keeps read side lockless. We can fix other writers 
> of nr_sects over a period of time. If nobody has complained so
> far, that means we don't run into issues frequently and it is not a
> huge concern.

So you think the patch is fine the way it is?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPIcoWAAoJEJrBOlT6nu75SfYIALuzdfVKVKBdXa16nrKj4XtU
T2PHkbNRRJhFjRbtxfyLkAWL//yEz4S1z08z+RCpP8YcuQ47bKa8WnoamTYSkzuV
SLjKjjec5a2v/SpEBl6QSHUxg73kBXi0pvsQDEm1+j0ZinZk7Sy+x2uZ8fKwYYYp
Z8dOShzSR5toIdpi42SbgmtO/qrdqbRcxANvCVwtybeAyVqmIiOY4DTdBm4YhTp5
GeVTUYTsfjuS3P+i1JJaVmUPMtMzOegXLKI775gWTn+x90TIMnoI+lXa2h1QeZOL
ZCsk6x7BF9t3lAkk60E8BePFFGoYpz3rHrAsco2qizrXz4Z0WVlh6KGIad0xDF4=
=SifF
-----END PGP SIGNATURE-----
