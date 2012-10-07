Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2JGWeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 18:34:05 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53478 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2JGWeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 18:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <m2haq5vs7h.fsf@firstfloor.org>
References: <1349637532-27466-1-git-send-email-elezegarcia@gmail.com>
	<m2haq5vs7h.fsf@firstfloor.org>
Date: Sun, 7 Oct 2012 19:34:02 -0300
Message-ID: <CALF0-+Wwf3gOWtZFrEwkQ4HUEZ-zagVSSN3QbZEYT4RhCGYoaA@mail.gmail.com>
Subject: Re: [PATCH v2] Makefile: Add option to disable gcc automatic inlining
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        mmarek@suse.cz, sam@ravnborg.org, rientjes@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 7, 2012 at 7:21 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Ezequiel Garcia <elezegarcia@gmail.com> writes:
>
>> The new option is CONFIG_CC_DISABLE_AUTO_INLINE and it's
>> located at:
>>   * Kernel hacking
>>     * Disable gcc automatic inlining
>
> You don't state anywhere why you want that?
>

This is important -if not necessary- to trace memory allocations with
ftrace kmem
events. Allocations are traced through _RET_IP_ macro, which in turn
only works accurately if gcc don't inline.

Without this patch you will trace callsites like kstrdup, instead of the real
caller.

Perhaps I should explain this better in the commit message?

Thanks for reviewing,

    Ezequiel
