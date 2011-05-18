Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1ERHWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:22:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40650 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab1ERHWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:22:49 -0400
Date: Wed, 18 May 2011 09:22:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: James <bjlockie@lockie.ca>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: help to bisect
Message-ID: <20110518072245.GB17608@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	James <bjlockie@lockie.ca>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4DD31264.4070704@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DD31264.4070704@lockie.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 08:27:16PM -0400, James wrote:
> How do I build v2.6.36 so I can test it mark it good so I can bisect?
> 
> Here is what I want to do:
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
> $ cd linux-2.6.37.y
> $ git bisect start
> $ git bisect good v2.6.36
> $ git bisect bad v2.6.37.6
> 
> Do I do "git checkout v2.6.36"?

Yes, but you should do it first, before starting bisection. After you've
verified .36 is fine, then you do the last three commands:

> $ git bisect start
> $ git bisect good v2.6.36
> $ git bisect bad v2.6.37.6

assuming you have verified also that .37.6 is bad, but I guess so,
otherwise you wouldn't be bisecting in the first place :)

Also, it might make sense to check whether .37 is fine too before
bisecting. If so, you save yourself quite a bit of bisection runs by
marking .37 as good instead of .36.

HTH.

-- 
Regards/Gruss,
    Boris.
