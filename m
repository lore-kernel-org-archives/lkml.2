Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0FONsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:48:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32939 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0FONsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZMzlub3tHUNNI2MAX9t6gYz0pFVSCnD9qT4GwcGEVbtQtbEoY18+Z4YtSljpg3zV+Z
         0OHAeM6XXRJ9kZncV8AzN2If6qeP8tgvlhMNl+lwVQOaazpUpfiTRwEltevCBjjXIjU2
         5vjkpYv9gDLxjonyt/f0EiVfYB3C5PCbJBP9Y=
Message-ID: <4C178498.3000702@panasas.com>
Date: Tue, 15 Jun 2010 09:48:08 -0400
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090925 Remi/fc9 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mark Hills <mark@pogo.org.uk>
CC: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Michal Marek <mmarek@suse.cz>
Subject: Re: Appending '+' to version, since 2.6.35-rc2
References: <alpine.NEB.2.01.1006131729430.2991@jrf.vwaro.pbz>
In-Reply-To: <alpine.NEB.2.01.1006131729430.2991@jrf.vwaro.pbz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun. 13, 2010, 15:01 -0400, Mark Hills <mark@pogo.org.uk> wrote:
> Commit 85a256d adds a new feature:
> 
>   [...] When CONFIG_LOCALVERSION_AUTO is not enabled, a `+' is appended
>   to the kernel version to represent that the kernel has been revised
>   since the last release unless "make LOCALVERSION=" was used to uniquely
>   identify the build.
> 
> I'm finding this inconvenient for 'casual' kernel development.
> 
> For example, my usual workflow goes something like:
> 

FWIW, I agree with this.
If I wanted a version suffix of this sort I'd just use CONFIG_LOCALVERSION_AUTO.

Benny

> 1) find something I suspect is a bug
> 2) upgrade to the latest stable or -rc kernel, to confirm
> 3) experiment with patch to fix it
> 
> Since 2.6.35-rc2, going from step 2 to 3 causes the version of the kernel 
> to change: forcing time-consuming rebuilds, installing modules, and manual 
> changes associated with a new version number; eg. updating the lilo/grub 
> config, or the distribution's initrd.
> 
> Whilst I can understand the motivation for the '+' being mandatory, the 
> added stages above unnecessarily raise the bar for casual developers, or 
> other people who need to 'dip' into the kernel and test patches. These 
> people are least likely to be aware of using LOCALVERSION to override it 
> too.
> 
> May I suggest that this particular part of the commit be reverted (example 
> below)? In favour of a user, if they wish, explicitly setting LOCALVERSION 
> or using CONFIG_LOCALVERSION_AUTO.
> 

