Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab1BWTqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:46:05 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64048 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1BWTqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:46:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gZtbQzHWvKFEDtCU2BvnpGgB8lncUPloMoqL+v7suOZAALLn5Zja32SwZ9XFF+Wbkk
         LiYXVqfaipWIZBF35N/SAksiRglAJuceMGkdDVTJF9vQiYKlWDogPvDJbYxP9SddyTdZ
         YEmulOFNQ6deSoYZ6NLfcGObThnhBInM6WZak=
MIME-Version: 1.0
In-Reply-To: <20110223015320.13068.77428.stgit@mike.mtv.corp.google.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
	<20110223015320.13068.77428.stgit@mike.mtv.corp.google.com>
Date: Wed, 23 Feb 2011 11:43:42 -0800
X-Google-Sender-Auth: dzgmImk2YgTIFHAyJuaXLY9CRms
Message-ID: <AANLkTinjhY3oiFTq2xq4fwQ-mtLZ8ph435+nc5irM7wZ@mail.gmail.com>
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

On Tue, Feb 22, 2011 at 5:53 PM, Mike Waychison <mikew@google.com> wrote:
> +static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
> +                                            void *_ret)
> +{

I'm seeing some unaligned references from this function
on ia64.  Code is loading a 2-byte value from an odd
address. We are dereferencing "dh", so looking at the
dmi_header definition, I'd have thought that we must
be touching dh->handle:

struct dmi_header {
        u8 type;
        u8 length;
        u16 handle;
};

I don't see any code in this function that does this,
so I assume there is some inlining or macro stuff
happening.

-Tony
