Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0KUBFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 20:05:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25150 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab0KUBFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 20:05:41 -0500
Message-ID: <4CE87041.9070704@oracle.com>
Date: Sat, 20 Nov 2010 17:05:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jean Delvare <khali@linux-fr.org>, Greg KH <gregkh@suse.de>
Subject: Re: WARNING: at tty_io.c: line 1331
References: <4CE82F40.3060807@oracle.com>
In-Reply-To: <4CE82F40.3060807@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[oops, first posting was too large for lkml, so instead of attachments,
I'll put the relevant files online]


On 11/20/10 12:27, Randy Dunlap wrote:
> 2.6.37-rc2-git4 on x86_64, nearly allmodconfig with a several debug/test
> options disabled and a few options changed to =y so that things work
> (like serial console).  Could there be some kernel options that are
> interfering here?
> 
> 
> Kernel config file is attached.
> 
> Reproducible by running 'modules_tester' script with the ONLY environment
> variable set to "hwmon".  I have not been able to reproduce this with other
> driver subsystems.
> 
> Today's test failed during loading/unloaded tmp421.  Previous tests have
> failed with adt7470, adm1031, and jc42.  The log of modules_tester output
> is attached. (mod-hwmon-r2g4.out)
> 
> (as root:)
> # ONLY=hwmon ./modules_tester 2>&1 | tee test.out
> 
> modules_tester just loads and unloads modules 3 times in a row. (it is
> available from http://oss.oracle.com/~rdunlap/scripts/modules_tester)
> 
> 
> This scripted test always fails (WARNING: + kernel is tainted) with:
> 
> WARNING: at /local/linsrc/linux-2.6.37-rc2-git4/drivers/tty/tty_io.c:1331 tty_reopen+0xa8/0xc5()
> 
> The full kernel log is attached as hwmon-fail-37r2g4.txt.
> 

Please see http://oss.oracle.com/~rdunlap/tty-warning/
for all of the relevant files.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
