Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2JZIHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:07:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2JZIHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:07:36 -0400
Date: Fri, 26 Oct 2012 01:07:32 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Fengguang Wu <fengguang.wu@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 08/31] use clamp_t in UNAME26 fix
Message-ID: <20121026080732.GB3127@elie.Belkin>
References: <20121026000214.941721299@linuxfoundation.org>
 <20121026000215.817875317@linuxfoundation.org>
 <20121026001119.GA3028@elie.Belkin>
 <20121026022803.GA2938@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026022803.GA2938@kroah.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Thu, Oct 25, 2012 at 05:11:19PM -0700, Jonathan Nieder wrote:
>> Greg Kroah-Hartman wrote:

>>>  		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
>>> -		copy = min(sizeof(buf), max_t(size_t, 1, len));
>>> +		copy = clamp_t(size_t, len, 1, sizeof(buf));
>>>  		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
>>
>> Does this have any effect at runtime?  If not, why is it needed for
>> stable kernels?
>
> It's a bugfix for the previous patch in this area, fixing the build
> warning.  I don't like adding stable patches that add new warnings :)

Ok, that's fair.  Thanks for explaining.

Jonathan
