Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab1EBUX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:23:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52260 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1EBUX7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <1304357805.30823.18.camel@nimitz>
References: <1304357194-19308-1-git-send-email-eparis@redhat.com> <1304357805.30823.18.camel@nimitz>
From: Jesse Gross <jesse@nicira.com>
Date: Mon, 2 May 2011 13:23:38 -0700
Message-ID: <BANLkTimG5fuf9eEzVqsTB_TSy2B1kn5h6g@mail.gmail.com>
Subject: Re: [PATCH] flex_array: avoid divisions when accessing elements
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 10:36 AM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> On Mon, 2011-05-02 at 13:26 -0400, Eric Paris wrote:
>> On most architectures division is an expensive operation and accessing an
>> element currently requires four of them.  This performance penalty
>> effectively precludes flex arrays from being used on any kind of fast
>> path.  However, two of these divisions can be handled at creation time and
>> the others can be replaced by a reciprocal divide, completely avoiding
>> real divisions on access.
>>
>> Signed-off-by: Jesse Gross <jesse@nicira.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Eric Paris <eparis@redhat.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> [rebase on top of changes to support 0 len elements: eparis]
>> [initialize part_nr when array fits entirely in base: eparis]
>> Signed-off-by: Eric Paris <eparis@redhat.com>
>
> This seems sane to me, especially in the element access case.
>
> Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

Thanks Eric!
