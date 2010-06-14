Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0FNGhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 02:37:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39184 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab0FNGho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 02:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=rJ47av6OlKGmZMrkwoNVyIHftiGfcl089/wXgWhqB3QMfH22+9eRvKGG6CBH3wDyhC
         A0IWv6Q6boWwaU0viFhshNUbsopAjAYsDSqvSGAi/gRysvye1gdv7f7R5qtdXDfJGIl9
         7MgKXEM4bcHkyV8a5alw4NU9zpGw/gt/cbWgE=
MIME-Version: 1.0
In-Reply-To: <AANLkTik_lsycuZNpCiPA7L594bhwSjR2XQg9VZ3CIKEB@mail.gmail.com>
References: <AANLkTik_lsycuZNpCiPA7L594bhwSjR2XQg9VZ3CIKEB@mail.gmail.com>
Date: Mon, 14 Jun 2010 00:37:43 -0600
Message-ID: <AANLkTilPPwXMiaC1S2ykLI4tyRA-tIj8fD0vhfzHbIeN@mail.gmail.com>
Subject: Re: 4K Pageable Stacks a MUST
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What I am talking about here is setting up the page fault handler to
map an extra 4K when the stack runs off the end then freeing the page
when the stack shrinks and create a 16K max window.  Would fix some
issues.  Based upon what I saw in NetWare 16K seems to be about as big
as you would ever need and you could still use 4K for most things.
Doing stack probes is braindead and the problem is getting worse from
what I have seen on newer distros.

Jeff

On Mon, Jun 14, 2010 at 12:34 AM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
> I have been running down bugs on the MDB Debugger on a 4 processor AMD
> Opteron System and have discovered that processors 1-X (other than 0)
> use a buttload of stack space when all the spinlock debgguging checks
> are turned on -- way too much memory and the systenter_past_esp panic
> shows up a lot.  NetWare at one point instrumented the ability to page
> map an extra 4K of memory up to 16K (then release it when the stack
> shrunk back to a smaller usage footprint).  I think for debugging and
> just general usage you should enable a 16K pagable limit with 4K
> stacks for debuggers and such or just to stop a lot of dump traps.
>
> It's getting to the point where 8K wont be enough when people need to
> debug spinlocks and rcu locks and other types of breakage.  Would not
> be hard to instrument.
>
> Jeff
>
