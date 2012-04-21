Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2DUAqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:46:18 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:23776 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2DUAqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:46:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1334969175!3641863!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 20 Apr 2012 19:46:14 -0500
Subject: RE: [RFC PATCH 0/2] init: make sure syscall arguments are marked
 __user where needed
Thread-Topic: [RFC PATCH 0/2] init: make sure syscall arguments are marked
 __user where needed
Thread-Index: Ac0fV5MM+5jrQJ/rQ2ayautYpikBQgAAFB9A
Message-ID: <ADE657CA350FB648AAC2C43247A983F002069887E116@AUSP01VMBX24.collaborationhost.net>
References: <201204161733.23830.hartleys@visionengravers.com>
	<20120420160039.74c49a0c.akpm@linux-foundation.org>
	<ADE657CA350FB648AAC2C43247A983F002069887E112@AUSP01VMBX24.collaborationhost.net>
 <20120420174319.6cea0e81.akpm@linux-foundation.org>
In-Reply-To: <20120420174319.6cea0e81.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 20, 2012 5:43 PM, Andrew Morton wrote:
> On Fri, 20 Apr 2012 19:05:46 -0500 H Hartley Sweeten wrote:
>
>>> Can we just make "make C=1" skip that file or something?
>> 
>> What about putting something like this at the top of the files:
>> 
>> 
>> /*
>>  * Many of the syscalls used in this file expect some of the arguments
>>  * to be __user pointers not __kernel pointers.  To limit the sparse
>>  * noise, turn off sparse checking for this file.
>>  */
>> #ifdef __CHECKER__
>> #undef __CHECKER__
>> #warning "Sparse checking disabled for this file"
>> #endif
>> 
>> 
>> Maybe without the warning if it doesn't seem necessary.
>> 
>> This keeps <linux/compiler.h> from defining the __attribute__* checks.
>
> That looks nice and explicit.

Another option would be to just undef the __user and __kernel checks. That
way the other sparse checks should still work.

I'll post an updated patch with the #undef __CHECKER__ method shortly.

Regards,
Hartley
