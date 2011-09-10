Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab1IJAyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:54:38 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:41490 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754650Ab1IJAyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:54:37 -0400
Message-ID: <4E6AB54A.1050504@xenotime.net>
Date: Fri, 09 Sep 2011 17:54:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: question: attribute 'require_context'
References: <201109091747.18525.hartleys@visionengravers.com>
In-Reply-To: <201109091747.18525.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/11 17:47, H Hartley Sweeten wrote:
> Hello all,
> 
> I'm trying to do an allyesconfig build of the kernel on an old debian box
> with gcc version, gcc (Debian 4.3.2-1.1) 4.3.2. Everything goes fine until
> the DRBD device driver gets compiled. At that point I get a bunch of
> error messages like this:
> 
> drivers/block/drbd/drbd_int.h:974:39 error: attribute 'require_context': unknown attribute
> 
> It looks like this is due to the following:
> 
> #ifdef __CHECKER__
> # define __protected_by(x)       __attribute__((require_context(x,1,999,"rdwr")))
> # define __protected_read_by(x)  __attribute__((require_context(x,1,999,"read")))
> # define __protected_write_by(x) __attribute__((require_context(x,1,999,"write")))
> # define __must_hold(x)       __attribute__((context(x,1,1), require_context(x,1,999,"call")))
> #else
> # define __protected_by(x)
> # define __protected_read_by(x)
> # define __protected_write_by(x)
> # define __must_hold(x)
> #endif
> 
> Is the require_context attribute something found in a later version of gcc?

No, it's a proposed change (patch) to sparse.

You can see all sparse mailing list messages about that patch and other
questions about it by searching the linux-sparse archives at marc.info:
  http://marc.info/?l=linux-sparse&w=2&r=1&s=require_context&q=b


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
