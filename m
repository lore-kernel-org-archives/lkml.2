Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab2ISQGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:06:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44124 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab2ISQGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:06:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120918164103.440C22C0A4@topped-with-meat.com>
References: <1347979995-1452-1-git-send-email-vda.linux@googlemail.com>
 <1347979995-1452-3-git-send-email-vda.linux@googlemail.com>
 <20120918153027.GA21612@redhat.com> <20120918164103.440C22C0A4@topped-with-meat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 19 Sep 2012 18:06:11 +0200
Message-ID: <CAK1hOcN-FOY+wUa32vYekOn7dDaNFWoTce7H0pgVwHOWhYNbOQ@mail.gmail.com>
Subject: Re: [PATCH -mm v2 2/2] coredump: add a new elf note with siginfo of
 the signal
To: Roland McGrath <roland@hack.frob.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Pedro Alves <palves@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 6:41 PM, Roland McGrath <roland@hack.frob.com> wrote:
>> But, somehow I forgot about compat tasks when we discussed this before.
>> Perhaps the code above should do
>>
>>       if (is_compat_task())
>>               copy_siginfo_to_user32(...);
>>       else
>>               copy_siginfo_to_user(...);
>>
>> ?
>
> compat_binfmt_elf.c will define a separate copy of this code via #include.
> So it just needs #define copy_siginfo_to_user copy_siginfo_to_user32 or
> something like that, as the various other types and functions are handled.

Sending a new version in a minute.
