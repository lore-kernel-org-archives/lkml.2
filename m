Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0JORRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:17:21 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:37591 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab0JORRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:17:21 -0400
Message-ID: <4CB88C9F.7040109@tilera.com>
Date: Fri, 15 Oct 2010 13:17:19 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/14] arch/tile: change lower bound on syscall error
 return to -4095
References: <cover.1287090280.git.cmetcalf@tilera.com> <a4dbc5ee52e8741522a2f87067b80116c6c7a934.1287090286.git.cmetcalf@tilera.com> <201010142322.20850.arnd@arndb.de>
In-Reply-To: <201010142322.20850.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/14/2010 5:22 PM, Arnd Bergmann wrote:
> On Thursday 14 October 2010 21:14:29 Chris Metcalf wrote:
>> Previously we were using -1023, which is fine for normal syscall
>> error returns, but the common value in use for other platforms
>> is -4095, and one Tilera-specific driver does use values in the
>> -1100 range, so tickled this bug.
> The patch is ok, but note that any value above starting at 512 is meant
> as kernel internal, so funny things may happen if a driver goes
> beyond that for errors returned to the user.
>
> Better use just the predefined error codes if possible.

Thanks, good point.  In practice we've found that for the syscalls we use
(e.g. pwrite) that are intended to return errors codes from our drivers the
errors are in fact properly returned.  But I've filed a bug internally that
we should review our usage of error codes and determine if there are more
standard ways to handle this, e.g. return a Linux errno but allow passing a
pointer to store a more specific hypervisor or driver error code in.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

