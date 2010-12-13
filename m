Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0LMPUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:20:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab0LMPUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:20:23 -0500
Message-ID: <4D0639B2.4060903@suse.com>
Date: Mon, 13 Dec 2010 10:20:18 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
        brian@xyzw.org
Subject: Re: delayacct: alignment changes break iotop
References: <20101213113745.GE1620@bicker> <20101213125709.GB14178@balbir.in.ibm.com>
In-Reply-To: <20101213125709.GB14178@balbir.in.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/13/2010 07:57 AM, Balbir Singh wrote:
> * Dan Carpenter <error27@gmail.com> [2010-12-13 14:37:45]:
> 
>> Iotop uses hardcoded offsets to find the taskstats struct members.
>> This got changed in 2.6.37 so it now iotop doesn't work on amd64.  The
>> offending commit is:
>>
>> commit 85893120699f8bae8caa12a8ee18ab5fceac978e
>> Author: Jeff Mahoney <jeffm@suse.com>
>> Date:   Wed Oct 27 15:34:43 2010 -0700
>>
>>     delayacct: align to 8 byte boundary on 64-bit systems
>>
>> Brian Rogers gets the reported-by tag.  The bugzilla entry is:
>> https://bugzilla.kernel.org/show_bug.cgi?id=24272
>>
> 
> Thanks for the report, looks like the change did not even bump the
> version field. Sorry, its my fault, I should have caught it earlier.
> iotop hard coding member offsets is not bad as long as we don't break
> ABI (expected from us). Any chance you could dump the offsets before
> and after the change?

In your February response and again in September, you did suggest a
version bump. I'm not sure why that didn't get integrated but I still
don't see how it's necessary for code that actually follows the interface.

iotop doesn't. It's broken. It doesn't even honor that version field and
worse yet, it doesn't even honor the packet format which specifically
doesn't define hard offsets. Rather it defines a protocol that tags
fields and supplies the offsets in the packet.

The getdelays.c code that ships with the kernel even demonstrates this,
so there's no excuse for half-assing it like this.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0GObEACgkQLPWxlyuTD7IziQCfYMylgEurblaMRGYXEbWzcYag
K9oAmQGeHsXKjcSs++Kx31UFS02ZEEUf
=2v7T
-----END PGP SIGNATURE-----
