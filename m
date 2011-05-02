Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1EBRfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:35:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63307 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1EBRe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mm8hVeaxHRYgY4mSzTbQwzwDWLa0hdO+JJMLNCM7g9G2WabbdlYioKn+bHNC3XLsbi
         2vtxBHy6uy9tWilFtESYAK19bO98QMSKVLxJo6WWYZslCD+x2uLg2KJRtZsyAQVgdOxk
         gZlH31OIfeWwhClCZXhKUfFEf2s8iTDvLTNB0=
MIME-Version: 1.0
In-Reply-To: <20110502170736.GB18740@merkur.ravnborg.org>
References: <71633.1304013549@localhost>
	<1304083893-18849-1-git-send-email-mmarek@suse.cz>
	<BANLkTikMf4x0e3UhabUH+c_xnWJMQ3rkvg@mail.gmail.com>
	<20110502170736.GB18740@merkur.ravnborg.org>
Date: Mon, 2 May 2011 13:34:54 -0400
Message-ID: <BANLkTi==Tx6sXcA2Bk6Cp7wc1DY-7c1V3g@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
From: Arnaud Lacombe <lacombar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Valdis.Kletnieks@vt.edu, bp@alien8.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 2, 2011 at 1:07 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Tue, May 03, 2011 at 12:16:15AM +0800, Américo Wang wrote:
>> On Fri, Apr 29, 2011 at 9:31 PM, Michal Marek <mmarek@suse.cz> wrote:
>> > Add support for make W=12, make W=123 and so on, to enable warnings from
>> > multiple W= levels. Normally, make W=<level> does not include warnings
>> > from the previous level.
>> >
>>
>> This interface is not friendly, at least not as normal as we often see.
>> W=x+1 is supposed to include warnings of W=x.
>>
>> Please refine the interface.
>
> Until we see that several people have had benefit if W=...
> we should leave it as is now.
>
> Then when people really start to use if we can refine it.
>
> IMO it is much more important to find the right sub-set
> of warnings to keep on W=1 level than how we see additional warnings.
>
> There may well be warnings where we say that the benefit of it is
> zero - or it is plain wrong in the kernel.
> Lets try to focus on this.
>
Because you are not even sure of what you submitted is good for the kernel ?

I think this has been done completely wrong, first all the extra
warnings got in (without a detailed impact implied by each one), then
it was decided to be split in several level (which I proposed on Feb
20th, but was originally rejected by Borislav Petkov), then, well,
some may need to be removed because they are not good for Linux. I
would rather have provided the framework first, clean, natural
interface, then added new warnings gradually when we were sure had a
positive impact on the kernel, with the associated patch fixing them.
Right now, +80k warnings will be just impossible to fix.

Now, the drawback of your comment is that when it will be time to
change the interface, some will object because it will have been
started to be used by third party scripts, and as authors of third
party script, it is a PITA to have to check the kernel version to know
if I should W=1,2,3, or W=123 or if W=3 includes W=1 ...

my 0.2c,

 - Arnaud
