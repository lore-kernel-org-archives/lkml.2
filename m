Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0CQHeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 03:34:12 -0400
Received: from mx9.orcon.net.nz ([219.88.242.59]:52253 "EHLO mx9.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab0CQHeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 03:34:09 -0400
Message-ID: <4BA085EE.3060700@orcon.net.nz>
Date: Wed, 17 Mar 2010 20:34:06 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100121 Lightning/1.0b2pre Shredder/3.0.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ra=FAl_Porcel?= <armin76@gentoo.org>
CC: Matt Turner <mattst88@gmail.com>, Will L Givens <wlgivens@gmail.com>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: Will's kernel compilation error
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <4B9FDD4E.8080607@gentoo.org>
In-Reply-To: <4B9FDD4E.8080607@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-DSPAM-Check: by mx9.orcon.net.nz on Wed, 17 Mar 2010 20:34:07 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Mar 17 20:34:08 2010
X-DSPAM-Confidence: 0.7003
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/10 08:34, Raúl Porcel wrote:
> Have one.
>
> My error is as follows:
>
> net/built-in.o: In function `svc_auth_unregister':
> (.text+0xb822c): relocation truncated to fit: GPREL16 against `.sbss'

Right, I've confirmed that with the supplied config.  What's happening 
is that the small data area (where certain static data are stored) has 
exceeded 64kB which is the limit under the small data model.  As noted 
elsewhere on this thread it can be solved by compiling with the large 
data model, but that incurs extra CPU instructions whenever the data 
area is accessed.

A better solution, in my view, is to concert some drivers to modules.  I 
note that the config has a large number of devices to be built (some of 
which are denoted as having been tested on x86/x86_64/ia64 only).  I 
converted a few drivers, and most of the selected filesystems (do you 
really need them all at boot time?) into modules.  The kernel then 
builds correctly.

But if people insist on being able to build impractical monolithic 
kernels on Alpha I will post my patch to add a kernel option for the 
large data model.

Cheers
Michael.
