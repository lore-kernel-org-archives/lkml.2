Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966622Ab2EOXCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:02:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56859 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966567Ab2EOXCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:02:07 -0400
Message-ID: <4FB2E069.7060703@amacapital.net>
Date: Tue, 15 May 2012 16:02:01 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
References: <20120515133450.GD22985@linux.intel.com>
In-Reply-To: <20120515133450.GD22985@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 06:34 AM, Matthew Wilcox wrote:
> 
> There are a number of interesting non-volatile memory (NVM) technologies
> being developed.  Some of them promise DRAM-comparable latencies and
> bandwidths.  At Intel, we've been thinking about various ways to present
> those to software.  This is a first draft of an API that supports the
> operations we see as necessary.  Patches can follow easily enough once
> we've settled on an API.
> 
> We think the appropriate way to present directly addressable NVM to
> in-kernel users is through a filesystem.  Different technologies may want
> to use different filesystems, or maybe some forms of directly addressable
> NVM will want to use the same filesystem as each other.

> What we'd really like is for people to think about how they might use
> fast NVM inside the kernel.  There's likely to be a lot of it (at least in
> servers); all the technologies are promising cheaper per-bit prices than
> DRAM, so it's likely to be sold in larger capacities than DRAM is today.
> 
> Caching is one obvious use (be it FS-Cache, Bcache, Flashcache or
> something else), but I bet there are more radical things we can do
> with it.  What if we stored the inode cache in it?  Would booting with
> a hot inode cache improve boot times?  How about storing the tree of
> 'struct devices' in it so we don't have to rescan the busses at startup?
> 

I would love to use this from userspace.  If I could carve out a little
piece of NVM as a file (or whatever) and mmap it, I could do all kinds
of fun things with that.  It would be nice if it had well-defined, or at
least configurable or discoverable, caching properties (e.g. WB, WT, WC,
UC, etc.).

(Even better would be a way to make a clone of an fd that only allows
mmap, but that's a mostly unrelated issue.)

--Andy
