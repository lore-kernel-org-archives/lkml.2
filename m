Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab1LHGfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 01:35:13 -0500
Received: from lo.gmane.org ([80.91.229.12]:41651 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab1LHGfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 01:35:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
Subject: Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
Date: Thu, 08 Dec 2011 14:34:47 +0800
Message-ID: <4EE05A87.1050904@kingswood-consulting.co.uk>
References: <20111206235815.GA21764@www.outflux.net> <CA+55aFzRz6DcmP8uYaeYAUkpBfePZTYQg-hvERnA9huCQu4X3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 202.55.39.28
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
In-Reply-To: <CA+55aFzRz6DcmP8uYaeYAUkpBfePZTYQg-hvERnA9huCQu4X3g@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/11 02:41, Linus Torvalds wrote:
> On Tue, Dec 6, 2011 at 3:58 PM, Kees Cook<keescook@chromium.org>  wrote:
>> A long-standing class of security issues is the symlink-based
>> time-of-check-time-of-use race, most commonly seen in world-writable
>> directories like /tmp.
>
> Ugh. I really dislike the implementation.
>
> Wouldn't it be much nicer to instead actually use the symlink
> protection fields, and make the rules be:
>
>   - creating a symlink as root does the traditional "lrwxrwxrwx" thing
>   - creating a symlink in a directory you own similarly does "lrwxrwxrwx"
>   - creating a symlink anywhere else (which implies either sticky or
> world-writable directory) does "lrwx------", so only you can use it.
>
> That seems to be much nicer semantics, and makes the protection
> *visible* instead of some kind of hacky run-time random behavior
> depending on some invisible config option that people aren't even
> aware of.

This sounds really good way to go about it, but it seems that an 
implementation might be invasive.

Currently the symlinks are created in the file system e.g. ext4_symlink 
has the S_IFLNK|S_IRWXUGO buried in it. It is likely other fs's follow 
this model too.

Also, having tried creating such a link, it seems that the read-side 
permissions check (at least in generic_readlink) is missing.

Frank
-- 
------------------------------------------------------------------------
Frank A. Kingswood                      frank@kingswood-consulting.co.uk
Cambridge, United Kingdom                               +44-7545-209 100


