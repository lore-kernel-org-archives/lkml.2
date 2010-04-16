Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab0DPMXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 08:23:21 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:60887 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758305Ab0DPMXT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 08:23:19 -0400
X-AuditID: 12074424-b7b9dae000002832-29-4bc856b6b34b
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <87vdbr8vzv.fsf@basil.nowhere.org>
Date: Fri, 16 Apr 2010 08:23:09 -0400
Cc: Zan Lynx <zlynx@acm.org>, Andrew Morton <akpm@linux-foundation.org>,
       Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <736D6FBC-DA18-49FD-BBE5-0BA848189932@mit.edu>
References: <4BBA6776.5060804@mozilla.com> <20100415155309.2649a29b.akpm@linux-foundation.org> <4BC79F75.2090704@acm.org> <87vdbr8vzv.fsf@basil.nowhere.org>
To: Andi Kleen <andi@halobates.de>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 16, 2010, at 7:41 AM, Andi Kleen wrote:

> Zan Lynx <zlynx@acm.org> writes:
> 
>> On 4/15/10 4:53 PM, Andrew Morton wrote:
>> 
>>> This just isn't an interesting case.  World-wide, the number of people
>>> who compile their own web browser and execute it from the file which ld
>>> produced is, umm, seven.
>> 
>> Gentoo users? Linux From Scratch?
> 
> "make install" tends to copy. I am not aware of any Makefiles
> that link directly to /usr/bin, and usually that wouldn't work
> anyways because of permissions. copy fixes the problem.

... and those people who are executing the binary out of the build directory are probably running the regression  test (i.e., "make; make check") and on most developer machines, if they're lucky they have enough memory that the executable will still be in their page cache.   :-)

This being said, on modern file systems (i.e., btrfs, ext4, xfs, et. al), delayed allocation should mostly hide this problem; and if not, and the linker can estimate in advance how big the resulting binary will be, it could be modified to use the fallocate(2) system call.

-- Ted


