Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1D2Bsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 21:48:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44989 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1D2Bsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 21:48:53 -0400
MIME-Version: 1.0
In-Reply-To: <1303920819.9308.19723.camel@nimitz>
References: <1303850501-16249-1-git-send-email-jesse@nicira.com> <1303920819.9308.19723.camel@nimitz>
From: Jesse Gross <jesse@nicira.com>
Date: Thu, 28 Apr 2011 18:48:32 -0700
Message-ID: <BANLkTinZkiy-EMdiJhOu1J2RfO8xDU5OXg@mail.gmail.com>
Subject: Re: [PATCH] flex_array: Avoid divisions when accessing elements.
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 9:13 AM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> On Tue, 2011-04-26 at 13:41 -0700, Jesse Gross wrote:
>> On most architectures division is an expensive operation and
>> accessing an element currently requires four of them.  This
>> performance penalty effectively precludes flex arrays from
>> being used on any kind of fast path.  However, two of these
>> divisions can be handled at creation time and the others can
>> be replaced by a reciprocal divide, completely avoiding real
>> divisions on access.
>
> flex_array.c has a nice table for how many objects can be allocated:
>
>  * Element size | Objects | Objects |
>  * PAGE_SIZE=4k |  32-bit |  64-bit |
>  * ---------------------------------|
>  *      1 bytes | 4186112 | 2093056 |
>  *      2 bytes | 2093056 | 1046528 |
>  *      3 bytes | 1395030 |  697515 |
>  *      4 bytes | 1046528 |  523264 |
>  *     32 bytes |  130816 |   65408 |
>  *     33 bytes |  126728 |   63364 |
>  *   2048 bytes |    2044 |    1022 |
>  *   2049 bytes |    1022 |     511 |
>  *       void * | 1046528 |  261632 |
>
> This patch changes that a bit.  Would you mind updating it?

Sure, I'll send out an updated patch that does that tomorrow.
