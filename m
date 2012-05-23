Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab2EWSBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:01:01 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34081 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab2EWSBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:01:00 -0400
MIME-Version: 1.0
In-Reply-To: <1337284958.17726.51.camel@joe2Laptop>
References: <1337284958.17726.51.camel@joe2Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 23 May 2012 12:00:29 -0600
Message-ID: <CAJfuBxw4F-nsEwn6Nh2swo+j4xJprTb_e5o4tOjuJSqqEeCUhA@mail.gmail.com>
Subject: Re: [RFC PATCH] dynamic_debug: Remove __used attribute from metadata
To: Joe Perches <joe@perches.com>, Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 2:02 PM, Joe Perches <joe@perches.com> wrote:
> The __used attribute in the declaration of the
> dynamic_debug metadata stops the compiler from
> optimizing and eliminating constant tests and
> the metadata declaration used in things like:
>
>   #define DEBUG_LEVEL 0
>   if (DEBUG_LEVEL > 1)
>        pr_debug("foo...");
>
> This is a common construct for debugging macros
> with a constant "level" test.
>
> When dynamic_debug is not configured, this is
> pr_debug and format string is eliminated unless
> DEBUG_LEVEL is greater than 1.
>
> Remove the unnecessary __used attribute so the
> even the dynamic_debug use of pr_debug can be
> appropriately optimized away completely.
>


Im a bit puzzled - the __used attr is in the
#if defined(CONFIG_DYNAMIC_DEBUG) branch.

If its not config'd, the METADATA is not compiled,
and this should have no effect.
Did you mean enabled instead of configured ?

FWIW, removing __used causes no harm here,
ie it doesnt break dynamic-debug facility.

Still, Id like to hear from Jason, he wrote it.
