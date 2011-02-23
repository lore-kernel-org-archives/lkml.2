Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1BWV3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:29:49 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59759 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab1BWV3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LkS9lxqKbcrFapxYf44abNBUQi6BoeYK6/iUSo9oaAU3Mzhv5KPrgVvxGsB9b2Pw1z
         9YScLQta5FRkIUhaluJAZZutZ0CwbNdw+9sqFhq+xM5PL4b7aVzIZwzsxancikLvkX29
         LI9845zbSH3RAoigbMWD0AAIYShnY8lY0GMuE=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=+-Wc0bWdpvR+X6UszLf7MXKYgi8Oo6anN-jR8@mail.gmail.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
	<20110223015320.13068.77428.stgit@mike.mtv.corp.google.com>
	<AANLkTinjhY3oiFTq2xq4fwQ-mtLZ8ph435+nc5irM7wZ@mail.gmail.com>
	<AANLkTi=+-Wc0bWdpvR+X6UszLf7MXKYgi8Oo6anN-jR8@mail.gmail.com>
Date: Wed, 23 Feb 2011 13:29:46 -0800
X-Google-Sender-Auth: KB6MuBDZ6i-JL6C3XQxtqVAWHFM
Message-ID: <AANLkTi=dE5_VjJ+5H6cWf9nAtdkLiqhSXo6Gvd_uGQ25@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] firmware: Basic dmi-sysfs support
From: Tony Luck <tony.luck@intel.com>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, Olof Johansson <olofj@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>, Jon Mayer <jonmayer@google.com>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>,
        David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:28 PM, Mike Waychison <mikew@google.com> wrote:
> Ya, I don't think there is anything that guarantees that dmi_header is
> aligned.   The access is probably the struct copy I did here:
>
>        /* Set the key */
>        entry->dh = *dh;

Yup - looking back at the assembly I see that one of the 2-byte
accesses is offset 2
(picking up ->handle), but the second is offset 0 (picking up ->type
and ->length). The
compiler assumed the structure was 2-byte aligned because of ->handle.

> What if we changed that guy to use memcpy?  We'd probably need to
> memcpy the dmi_system_event_log as well.  Patch attached (applies on
> top of the entire patchset).

With the patch, all the unaligned accesses go away.

Tested-by: Tony Luck <tony.luck@intel.com>

-Tony
