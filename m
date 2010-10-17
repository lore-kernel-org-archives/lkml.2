Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab0JQAzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:55:18 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53748 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab0JQAzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:55:17 -0400
Message-ID: <4CBA4933.1080108@kernel.org>
Date: Sat, 16 Oct 2010 17:54:11 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
References: <20101016065206.GO4681@dastard> <20101016192027.GA6883@infradead.org> <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com> <20101017003526.GA29677@dastard>
In-Reply-To: <20101017003526.GA29677@dastard>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Sat, 16 Oct 2010 17:54:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2010 05:35 PM, Dave Chinner wrote:
> On Sat, Oct 16, 2010 at 02:10:29PM -0700, H. Peter Anvin wrote:
>> "Christoph Hellwig" <hch@infradead.org> wrote:
>>> Besides the algorithmic problems with ima, why is kernel.org using
>>> IMA to start with?  Except for IBM looking for a reason to jusity why
>>> TPM isn't a completely waster of ressources it's pointless.  And it was
>>> only merged under the premise that it would not affect innocent normal
>>> users.
>>
>> I'm confused ... what makes you think we are?  This might have
>> been an unintentional misconfiguration...
> 
> It's enabled in the kernel that is running:
> 
> $ grep CONFIG_IMA /boot/config-2.6.34.7-56.fc11.x86_64
> CONFIG_IMA=y
> CONFIG_IMA_MEASURE_PCR_IDX=10
> CONFIG_IMA_AUDIT=y
> CONFIG_IMA_LSM_RULES=y
> $
> 
> and it's using lots of memory, so if you're not actually using it I
> think it should be disabled.
> 
> If this is a stock fedora config, then they've got some work to
> do....

Considering the only change to the RPM I made for 2.6.34 (the kernel
currently running on master) was a one line change to get XFS to not
kill the box, it's standard.

Taking a quick glance at my laptop (F12) I'll note the following:

config-2.6.32.16-150.fc12.x86_64:CONFIG_IMA=y
config-2.6.32.16-150.fc12.x86_64:CONFIG_IMA_MEASURE_PCR_IDX=10
config-2.6.32.16-150.fc12.x86_64:CONFIG_IMA_AUDIT=y
config-2.6.32.16-150.fc12.x86_64:CONFIG_IMA_LSM_RULES=y

config-2.6.32.21-166.fc12.x86_64:CONFIG_IMA=y
config-2.6.32.21-166.fc12.x86_64:CONFIG_IMA_MEASURE_PCR_IDX=10
config-2.6.32.21-166.fc12.x86_64:CONFIG_IMA_AUDIT=y
config-2.6.32.21-166.fc12.x86_64:CONFIG_IMA_LSM_RULES=y

config-2.6.32.21-168.fc12.x86_64:CONFIG_IMA=y
config-2.6.32.21-168.fc12.x86_64:CONFIG_IMA_MEASURE_PCR_IDX=10
config-2.6.32.21-168.fc12.x86_64:CONFIG_IMA_AUDIT=y
config-2.6.32.21-168.fc12.x86_64:CONFIG_IMA_LSM_RULES=y

So I would happily punt this at Fedora as an issue upstream (Fedora) in
this case.  This seems to be a boolean value inside the kernel, it's
either enabled, or it's not.

There does seem to be a boot option to disable it, but it seems to be on
by default if it's compiled in, and it's not like it's obvious that this
is there and chewing up resources, is there a way to find out how much
memory this is chewing up?

I can understand the distributions wanting to turn this on, there is
likely user requests to be able to use this.  It's just annoying that
it's completely non-obvious that this change went in, it's on by default
and it's stealing memory, particularly when it's not being used for
anything.

Speaking to TPM, it's not quite an entire waste of resources - you can
use it as a random number generator source from hardware, so that's
useful - can't say much beyond that.

- John 'Warthog9' Hawley
