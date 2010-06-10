Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab0FJN72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:59:28 -0400
Received: from mail.tpi.com ([70.99.223.143]:4404 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759036Ab0FJN71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:59:27 -0400
Message-ID: <4C10EFB6.3020500@canonical.com>
Date: Thu, 10 Jun 2010 07:59:18 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
CC: e1000-devel@lists.sourceforge.net,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: e1000e probe failure on 2.6.34 and higher, Intel MB
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

http://bugs.launchpad.net/bugs/591707

I've a bug where e1000e works with Lucid (2.6.32), but fails to probe 
with 2.6.35-rc2. The output is mighty terse.

[   28.193628] e1000e 0000:00:19.0: PCI INT A disabled
[   28.193740] e1000e: probe of 0000:00:19.0 failed with error -3

The full dmesg logs are at 
https://bugs.edge.launchpad.net/ubuntu/+source/linux/+bug/591707/comments/23 
and 
https://bugs.edge.launchpad.net/ubuntu/+source/linux/+bug/591707/comments/24

The reporter says that it also fails with 2.6.34. The report has logs 
showing that it works with 2.6.32 and fails with 2.6.35-rc1. I've 
requested the reporter install a vanilla -rc2 kernel from 
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.35-rc2-maverick/linux-image-2.6.35-020635rc2-generic_2.6.35-020635rc2_amd64.deb, 
but I do not expect different results given that the only change from 
rc1 to rc2 is 'e1000e: change logical negate to bitwise' (which is not 
germane to probing).

This appears to be an Intel OEM MB as far as I can tell from the DMI. It 
was new in April so is unlikely to have flash corruption issues such as 
those observed with 2.6.24.

Any suggestions on why the probe silently fails? None of the module 
params look like they'll make a difference.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
