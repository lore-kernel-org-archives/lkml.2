Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab0DJPNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 11:13:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42503 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0DJPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 11:13:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 10 Apr 2010 17:13:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <201003271537.40488.arnd@arndb.de>
Message-ID: <tkrat.5a45045b32e1e7c6@s5r6.in-berlin.de>
References: <201003242240.54907.arnd@arndb.de>
 <201003251438.59062.arnd@arndb.de> <4BAD4795.2040700@s5r6.in-berlin.de>
 <201003271537.40488.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Mar, Arnd Bergmann wrote:
> On Saturday 27 March 2010 00:47:33 Stefan Richter wrote:
>> firewire-core and raw1394 do not actually require the BKL, they only
>> miss to declare their files as not seekable.  I will post patches which
>> change these accordingly.
> 
> Your patches look good, but it would be helpful to also set .llseek = no_llseek
> in the file operations, because that is much easier to grep for than
> only the nonseekable_open. While it's technically a NOP on the presence of
> nonseekable_open, it will help that I don't accidentally apply my patch on
> top of yours.

I pushed modified versions of these patches out to linux1394-2.6.git now
(master and for-next branch, on top of unrelated firewire updates). They
contain the explicit .llseek = no_llseek now.

http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=commitdiff;h=3ac26b2ee30005930117fe6a180c139c5f300faf
http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=commitdiff;h=7cfe21aae155c26193fde617dc61d37a79a63f86
-- 
Stefan Richter
-=====-==-=- -=-- -=-=-
http://arcgraph.de/sr/

