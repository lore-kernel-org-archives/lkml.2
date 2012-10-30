Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab2J3U5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab2J3U5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:57:07 -0400
Message-ID: <50903F18.10004@draigBrady.com>
Date: Tue, 30 Oct 2012 20:56:56 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <ljkarkk2@cc.hut.fi>,
        linux-kernel@vger.kernel.org
Subject: Re: urandom is too slow
References: <508FEA5A.7010406@cc.hut.fi> <20121030185403.GA5044@thunk.org>
In-Reply-To: <20121030185403.GA5044@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 06:54 PM, Theodore Ts'o wrote:
> On Tue, Oct 30, 2012 at 04:55:22PM +0200, Lasse Kärkkäinen wrote:
>> Apparently there has been little or no development on urandom even
>> though the device is in widespread use for disk shredding and such
>> use. The device emits data at rather slow rate of 19 MB/s even on
>> modern hardware where other software-based PRNGs could do far
>> better. An even better option seems to be utilizing AES for
>> encrypting zeroes, using a random key, allowing for rates up to 500
>> MB/s with hardware that has AES-NI instructions.
>>
>> Why is urandom so slow and why isn't AES hardware acceleration utilized?
>
> If you can use a software-based PRNG, you should use one in userspace.
> The intended use of urandom is for cryptographic purposes (i.e.,
> generating random session keys, long-term public keys, etc.).  If you
> just want to wipe a disk, you shouldn't be using /dev/urandom for that
> purpose.

For the record, shred uses a user space PRNG for speed
for the last 3 years or so, rather than using /dev/urandom:
http://git.sv.gnu.org/gitweb/?p=coreutils.git;a=commit;h=af5723c7

$ shred-old -v -n3 t
shred-old: t: pass 1/3 (random)...
shred-old: t: pass 1/3 (random)...8.3MiB/1000MiB 0%
shred-old: t: pass 1/3 (random)...17MiB/1000MiB 1%
shred-old: t: pass 1/3 (random)...32MiB/1000MiB 3%
...

$ time shred-new -v t
shred-new: t: pass 1/3 (random)...
shred-new: t: pass 1/3 (random)...116MiB/1000MiB 11%
shred-new: t: pass 1/3 (random)...216MiB/1000MiB 21%
shred-new: t: pass 1/3 (random)...340MiB/1000MiB 34%
...

cheers,
Pádraig.
