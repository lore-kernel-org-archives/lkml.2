Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2FUBKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:10:35 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:37675 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755480Ab2FUBKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:10:33 -0400
Message-ID: <4FE27471.8050505@xenotime.net>
Date: Wed, 20 Jun 2012 18:10:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Jun 20 (hweight return type)
References: <20120620173536.b856bbd97497cf02ddf8d6d2@canb.auug.org.au>
In-Reply-To: <20120620173536.b856bbd97497cf02ddf8d6d2@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 12:35 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120619:


Someone changes the return type of __const_hweight8() to
(unsigned long).  That causes printk format warnings when
hweight8/16() etc. is passed a constant:

drivers/input/joystick/analog.c:412:4: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'
drivers/input/joystick/analog.c:412:4: warning: format '%d' expects type 'int', but argument 5 has type 'long unsigned int'
drivers/input/joystick/analog.c:416:5: warning: format '%d' expects type 'int', but argument 5 has type 'long unsigned int'


Note that in

#define hweight8(w)  (__builtin_constant_p(w) ? __const_hweight8(w)  : __arch_hweight8(w))

__arch_hweight*() still returns unsigned int while __const_hweight*()
returns unsigned long.  This can't be good, can it?




-- 
~Randy
