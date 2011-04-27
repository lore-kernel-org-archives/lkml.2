Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab1D0QOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:14:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60857 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab1D0QOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:14:17 -0400
Subject: Re: [PATCH] flex_array: Avoid divisions when accessing elements.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jesse Gross <jesse@nicira.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
In-Reply-To: <1303850501-16249-1-git-send-email-jesse@nicira.com>
References: <1303850501-16249-1-git-send-email-jesse@nicira.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 27 Apr 2011 09:13:39 -0700
Message-ID: <1303920819.9308.19723.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 13:41 -0700, Jesse Gross wrote:
> On most architectures division is an expensive operation and
> accessing an element currently requires four of them.  This
> performance penalty effectively precludes flex arrays from
> being used on any kind of fast path.  However, two of these
> divisions can be handled at creation time and the others can
> be replaced by a reciprocal divide, completely avoiding real
> divisions on access. 

flex_array.c has a nice table for how many objects can be allocated:

 * Element size | Objects | Objects |
 * PAGE_SIZE=4k |  32-bit |  64-bit |
 * ---------------------------------|
 *      1 bytes | 4186112 | 2093056 |
 *      2 bytes | 2093056 | 1046528 |
 *      3 bytes | 1395030 |  697515 |
 *      4 bytes | 1046528 |  523264 |
 *     32 bytes |  130816 |   65408 |
 *     33 bytes |  126728 |   63364 |
 *   2048 bytes |    2044 |    1022 |
 *   2049 bytes |    1022 |     511 |
 *       void * | 1046528 |  261632 |

This patch changes that a bit.  Would you mind updating it?

-- Dave

