Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1FJDYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:24:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56645 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1FJDYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OvfKKw+jiI0C91DBjLgdn+ncnkJ7DlGlJBYFqwbYu+dE1ohcF9hYCvUv1yh7eZ+GK1
         YzvFwIFtUrA/0jHA9NYFOHYXZXwxoib+AsnSrHQmJnSswoG72u9njQr6EZQBElhK0t3P
         CUdwQKVrxww/35B5t3qAEA4PyYASFIi0RwwyU=
MIME-Version: 1.0
In-Reply-To: <1307662948.2874.293.camel@pasglop>
References: <1307482573-25440-1-git-send-email-ericvh@gmail.com>
 <1307494057.2874.212.camel@pasglop> <BANLkTinD+1+QTUhKvQP-T_bZgbi1YS1jwQ@mail.gmail.com>
 <1307662948.2874.293.camel@pasglop>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Thu, 9 Jun 2011 22:23:20 -0500
Message-ID: <BANLkTikRYDH3K1wOdMzzvVP--frRezVnRQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC][V3] bluegene: use MMU feature flag to
 conditionalize L1 writethrough code
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 6:42 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2011-06-09 at 09:58 -0500, Eric Van Hensbergen wrote:
>> On Tue, Jun 7, 2011 at 7:47 PM, Benjamin Herrenschmidt
>> <benh@kernel.crashing.org> wrote:
>> > BTW. Care to explain to me why you have U2 -both- in the arguments to
>> > tlbwe and in MMUCR ? That doesn't look right to me... which one is used
>> > where and when ?
>> >
>>
>> My reading of the databook is that U2SWOAE is an enable bit that lets the U2
>> storage attribute control the behavior.
>
> You mean the MMUCR variant ?
>

Yeah, the MMCR variant acts as an enable/mask for the U2 storage attribute.

>
> Well, point is, parsing the device-tree from early boot asm is nasty,
> unless you start extending the header but that sucks. That's why I'm
> thinking it might be a good idea to look at what it takes to "convert"
> the initial entry instead, even if that involves some cache flushing
> (provided that's workable at all of course).
>

ah, okay.  I guess if its happening before the secondary cpus come up
then that should be workable.   I guess it doesn't hurt to try.

       -eric
