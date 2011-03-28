Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1C1HBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:01:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33640 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1C1HBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=C+nbCl7Nah+kDCQ8L0IQ0iiR4PlW8ZXzJH4Y9Pi8XMRRuw+kfb/8SB6u7ibEIuT9jr
         bRdxW3vjkgt5WHZ0RXkoJfIcnotmdHo7ixun/GqId5UkbUcc98vKJmKyvb0uYLE/zhL9
         RzF4hKk17jTOI0Spfcr7dz6dsHlOLOadilOZo=
MIME-Version: 1.0
In-Reply-To: <AANLkTiny-bKXdfnXsygeZ-RDqduYJNWMLXxcRT-cSy_g@mail.gmail.com>
References: <27521.1300989784@redhat.com> <AANLkTiny-bKXdfnXsygeZ-RDqduYJNWMLXxcRT-cSy_g@mail.gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 28 Mar 2011 03:01:12 -0400
X-Google-Sender-Auth: jbJWK2n8HPos510DZbdk_be8Ra8
Message-ID: <AANLkTikXPp+gApLmCVSj9yBymTwoYy-bOGhvWe8fCgOO@mail.gmail.com>
Subject: Re: [GIT PULL] NOMMU and FRV patches
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, tglx@linutronix.de, amwang@redhat.com,
        lethal@linux-sh.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 22:46, Linus Torvalds wrote:
> On Thu, Mar 24, 2011 at 11:03 AM, David Howells wrote:
>> Can you pull these patches please?
>
> No.
>
> Because they are sh*t that have clearly never been tested, and have
> never been in -next.
>
> They don't even compile on anything but NOMMU, as far as I can tell.
> That new "vcoalesce()" helper is crap:

yeah, it would seem that my patch broke MMU (for once the other way
around).  it's the MMU vcoalesce redirection that is broken.  stupid
thinko:
-#define vcoalesce(...) vmap(...)
+#define vcoalesce(...) vmap(__VA_ARGS__)
-mike
