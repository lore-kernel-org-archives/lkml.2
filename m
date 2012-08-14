Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2HNUOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:14:30 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:42732 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757397Ab2HNUO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:14:29 -0400
Message-ID: <502AB14C.6090406@xenotime.net>
Date: Tue, 14 Aug 2012 13:13:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Thai Bui <blquythai@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] boot: Put initcall_debug into its own Kconfig option
 DEBUG_INITCALL
References: <1344891431-30869-1-git-send-email-blquythai@gmail.com> <20120813212151.GA15429@phenom.dumpdata.com> <CAKkTMC5SP6LgWbhtkU_HCBUAfArGuHXtp4mcwi2tFTjZOwVQbA@mail.gmail.com> <5029823A.9020207@xenotime.net> <20120814011826.GA2255@leaf>
In-Reply-To: <20120814011826.GA2255@leaf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 06:18 PM, Josh Triplett wrote:

> On Mon, Aug 13, 2012 at 03:39:54PM -0700, Randy Dunlap wrote:
>> On 08/13/2012 03:08 PM, Thai Bui wrote:
>>> Hi all,
>>>
>>> I am as part of a capstone group at Portland State University is working
>>> to tinify the kernel as small as possible. The ultimate goal is to make
>>> the kernel small enough to use on micro-controller (or under < 200k).
>>> This patch is one of them, it saves 176 bytes on a minimal configuration
>>> of the kernel (the bzImage file was reduced from 363264 bytes to 363264
>>> bytes applying this patch).
>>>
>>> Aside from the purpose of reducing the size of the kernel. We are also
>>> trying to clean up the kernel by making Kconfig options to compile out
>>> the stuffs that aren't used often.
>>
>> IMO the kernel already has too many kconfig options.
>>
>> Also, personally I would not merge a patch that saves so little memory,
>> especially on what I consider a very useful option.
> 
> I think Thai undersold his patch significantly; the *compressed* size
> went down by 176 bytes, and the uncompressed size went down more than


Thanks.  Good point.

> that.  And that's the savings starting from a very minimal kernel, not
> starting from a defconfig kernel.
> 
> In any case, do you object to the introduction of a Kconfig option at
> all, or to that option defaulting to off?  In particular, would you
> object if the option only showed up if EMBEDDED, and defaulted to y?  At
> that point, you could reasonably expect that most users and distros will
> have it enabled, so you'll be able to count on asking people to enable
> it and send you the output.  Would that suffice?

It's not one patch that I object to.  It's a "pile" of them.
and when does it stop?  or does it go on ad infinitum?

One could make options to make many lines of code configurable,
but that would hardly be the right thing to do IMHO.

> The patch itself seems incredibly straightforward and non-invasive to
> me; it just stubs out the global variable and lets GCC fold away all the
> code.
> 
> At this point, the kernel is running out of major things to cut out to
> save space; getting from ~200k (the current smallest kernel possible) to
> much less than that will require a pile of patches that save anywhere


a pile being how many patches (roughly)?

> from a few hundred bytes to a few kilobytes.  I certainly agree that
> those patches need to avoid introducing too much complexity.  However, I
> don't think it makes sense to object to a patch that saves space solely
> on the grounds that it doesn't save *more* space.  That would make it
> impossible to cut out small things, and small things add up.


Yeah, I think that former Sen. Everett Dirksen said something like that. ;)


-- 
~Randy
