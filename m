Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885Ab2BJSvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:51:43 -0500
Received: from plane.gmane.org ([80.91.229.3]:51179 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759724Ab2BJSvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:51:42 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Simon Farnsworth <simon@farnz.org.uk>
Subject: Re: Do the x86 kernel entry points need an xabort on TSX cpus?
Date: Fri, 10 Feb 2012 18:51:13 +0000
Message-ID: <jh3ovb$tsk$1@dough.gmane.org>
References: <CALCETrVWBdp2yyuZ54osq_QQ0a8NKUfOk8stxtuiFWq76FO7JQ@mail.gmail.com> <4F35517F.9070904@linux.intel.com> <CALCETrVHpfW5=paX8XjGNBg3Q7sjeLptMBG6bW=iQpXk0Uo+PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 110.100.155.90.in-addr.arpa
User-Agent: KNode/4.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andy Lutomirski wrote:

> On Fri, Feb 10, 2012 at 9:18 AM, H. Peter Anvin <hpa@linux.intel.com>
> wrote:
>> On 02/09/2012 11:40 PM, Andy Lutomirski wrote:
>>>
>>> [...]
>>>
>>> - Ring transitions: SYSENTER, SYSCALL, SYSEXIT, and SYSRET.
>>>
>>> I suspect that many bits of the kernel expect that things they do
>>> won't unhappen.  For example, it could be fun to do:
>>>
>>
>> That's why entering the kernel will cause an abort.  In other words, you
>> will ALWAYS abort when you do a read(), and you will never reach your
>> _xabort().
> 
> Is that architecturally guaranteed?  (My manual suggests that it's
> specifically *not* guaranteed, which is surprising.)
> 
> --Andy
My understanding of the architecture manual's wording (which is a bit 
clumsy) is that they want to leave themselves wiggle room just in case they 
work out a way to do any of these things without requiring an abort.

If, for example, Intel add an MSR for SYSENTER that's used to go to a 
different entrypoint if you're mid-transaction, you've suddenly broken all 
code that assumes that SYSENTER triggers an abort - instead, some SYSENTERs 
trigger an abort (as the kernel does the XABORT), while others don't.

Current implementations appear to always abort on ring transition, though.
- -- 
Simon Farnsworth
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPNWclAAoJEIKsye9/dtRWNoAH/j6H6mUzk+eS4yeZlcfd1DbG
cIicIJWGJNfm/TWAGb2ABrFgyDS+568ODFUogtAoLFcaxUieVVmuopjfgdjfiLdr
GoANhzyzohknQnHyiQetyTOzmkQVYCrMuRt/qplMO+k5DuvuN0FNxGW990B4jwQL
kFC2KSDMi2QKUnla2XbVsHR7xqe8gRJMEVB5DREkFiVhJGaf4Eyj0Rh4yLfSu9Ka
IngcU7Q6dmSlwCzmt/r+5BJeMvzfDa76+NxdStYDxe2FcZx7BdHeUwM9YyRPcrFp
Cgosn+C8Aiea15Ti/xYpd+M8LWGK8bq4XiV9a8D9WSagGngBrO1u1iCnx2hYKdI=
=hHwE
-----END PGP SIGNATURE-----


