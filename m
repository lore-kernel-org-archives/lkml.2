Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161429Ab2CPOpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:45:52 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:43160 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161069Ab2CPOpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:45:51 -0400
Date: Fri, 16 Mar 2012 14:45:44 +0000 (UTC)
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Paul Eggert <eggert@cs.ucla.edu>, "H.J. Lu" <hjl.tools@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        GNU C Library <libc-alpha@sourceware.org>
Subject: Re: x32 and width of blksize_t, suseconds_t
In-Reply-To: <4F634EA4.9070709@zytor.com>
Message-ID: <Pine.LNX.4.64.1203161435530.31619@digraph.polyomino.org.uk>
References: <20120315192515.GA6585@intel.com> <20120315195000.7E3BE2C0A3@topped-with-meat.com>
 <CAMe9rOpXRcO6a4cFEU=s1Gjzzt87zvyzuLhAWupc2pOX6az6ig@mail.gmail.com>
 <4F625570.7050003@cs.ucla.edu> <CAMe9rOpvnhPmpmsLedmOjjYB9SghZiov-cOUi+wrYvKaP+c9pQ@mail.gmail.com>
 <4F6267B1.3090805@cs.ucla.edu> <CAMe9rOrRdj_ns=rkonB2BwgmZa3KHBHTQQCv0bkH8PQ2UMXtHw@mail.gmail.com>
 <4F62F152.1040909@cs.ucla.edu> <4F62F786.2070907@cs.ucla.edu>
 <4F634EA4.9070709@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 16 Mar 2012 14:45:45.0702 (UTC) FILETIME=[78455060:01CD0383]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012, H. Peter Anvin wrote:

> On 03/16/2012 01:19 AM, Paul Eggert wrote:
> > Come to think of it, the proposed x32 patch may have issues
> > with blksize_t and suseconds_t as well.  POSIX says that an x32
> > implementation must support at least one programming environment
> > (presumably settable via a feature test macro) where blksize_t
> > and suseconds_t are no wider than 'long'; see
> > <http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/sys_types.h.html>.
> > But if I understand things correctly, x32 glibc would
> > define these to be 'long long'.  This issue affects system
> > calls such as 'stat' and 'select'.
> 
> That's just not going to happen, sorry.  Why on Earth is this a
> requirement?  It makes no sense whatsoever.

It's probably to support code written for C90.  Note that it's the 
POSIX-conforming system as a whole that is to support such an environment 
- but it might be an environment that uses the traditional 32-bit or 
64-bit ABIs, it needn't be one using the x32 ABI.  "getconf 
POSIX_V7_WIDTH_RESTRICTED_ENVS" must print the names of the environments 
meeting this requirement; if one is "POSIX_V7_ILP32_OFF32", for example, 
then "getconf POSIX_V7_ILP32_OFF32_CFLAGS" will print the flags (maybe 
-m32) and likewise for _LDFLAGS and _LIBS.  In glibc this means defining 
appropriate macros in bits/environment.h to give the right flags - and 
also probably changing posix/confstr.c which has comments saying 
"Currently this means all environment which the system allows." (the x32 
patch series may need to adjust this in some way).

-- 
Joseph S. Myers
joseph@codesourcery.com
