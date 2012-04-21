Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab2DUAFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:05:50 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:48314 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2DUAFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:05:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1334966747!3635711!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 20 Apr 2012 19:05:46 -0500
Subject: RE: [RFC PATCH 0/2] init: make sure syscall arguments are marked
 __user where needed
Thread-Topic: [RFC PATCH 0/2] init: make sure syscall arguments are marked
 __user where needed
Thread-Index: Ac0fSWp/xWPd8yhXRxutowORuLplpgABNSDg
Message-ID: <ADE657CA350FB648AAC2C43247A983F002069887E112@AUSP01VMBX24.collaborationhost.net>
References: <201204161733.23830.hartleys@visionengravers.com>
 <20120420160039.74c49a0c.akpm@linux-foundation.org>
In-Reply-To: <20120420160039.74c49a0c.akpm@linux-foundation.org>
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

In Friday, April 20, 2012 4:01 PM, Andrew Morton wrote:
> On Mon, 16 Apr 2012 17:33:23 -0700 H Hartley Sweeten wrote:
>
>> When using syscall routines in the kernel, some of the arguments
>> should be user pointers but are missing the __user markup. This
>> produces a number of sparse warnings of the format:    
>>   
>> warning: incorrect type in argument 1 (different address spaces)
>>    expected char [noderef] <asn:1>*dev_name
>>    got char *name 
>> 
>> Wrap the syscall routines in the private do_mounts.h header so that
>> the appropriate __user markups are added for the init mount code.
>
> This makes rather a mess of do_mounts.c for pretty marginal benefit.

Well... That's why it was a RFC... ;-)

> Can we just make "make C=1" skip that file or something?

What about putting something like this at the top of the files:


/*
 * Many of the syscalls used in this file expect some of the arguments
 * to be __user pointers not __kernel pointers.  To limit the sparse
 * noise, turn off sparse checking for this file.
 */
#ifdef __CHECKER__
#undef __CHECKER__
#warning "Sparse checking disabled for this file"
#endif


Maybe without the warning if it doesn't seem necessary.

This keeps <linux/compiler.h> from defining the __attribute__* checks.

Regards,
Hartley

