Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0LXWdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 17:33:53 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46182 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab0LXWdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 17:33:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wu+FpIrpZhRlZ/mlQYcflwH2s4Y6ud/DEwz585GT1OK4MQW6vWUuFHQO8/p3uQ/ssO
         R+cWVjI4l6fjsU4s6nh8rh8hShJfH1tMbi/pFrPnEl2XwRUpv7H97jYoAlKByIR5a44W
         mkS+XCrc5N09AkTmW1KWteQ4rlb+uee7Hn9tg=
Message-ID: <4D151FCC.4060202@pobox.com>
Date: Fri, 24 Dec 2010 17:33:48 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gen_init_cpio: Avoid race between call to stat() and
 call to open()
References: <alpine.LNX.2.00.1012242125170.28973@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1012242125170.28973@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2010 03:28 PM, Jesper Juhl wrote:
> Hi,
>
> In usr/gen_init_cpio.c::cpio_mkfile() a call to stat() is made based on
> pathname, subsequently the file is open()'ed and then the value of the
> initial stat() call is used to allocate a buffer. This is not safe since
> the file may change between the call to stat() and the call to open().
> Safer to just open() the file and then do fstat() using the filedescriptor
> returned by open.
>
>
> Signed-off-by: Jesper Juhl<jj@chaosbits.net>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


