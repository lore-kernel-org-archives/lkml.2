Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068Ab2COWTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:19:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64203 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab2COWTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:19:45 -0400
MIME-Version: 1.0
In-Reply-To: <4F6267B1.3090805@cs.ucla.edu>
References: <20120315192515.GA6585@intel.com>
	<20120315195000.7E3BE2C0A3@topped-with-meat.com>
	<CAMe9rOpXRcO6a4cFEU=s1Gjzzt87zvyzuLhAWupc2pOX6az6ig@mail.gmail.com>
	<4F625570.7050003@cs.ucla.edu>
	<CAMe9rOpvnhPmpmsLedmOjjYB9SghZiov-cOUi+wrYvKaP+c9pQ@mail.gmail.com>
	<4F6267B1.3090805@cs.ucla.edu>
Date: Thu, 15 Mar 2012 15:19:44 -0700
Message-ID: <CAMe9rOrRdj_ns=rkonB2BwgmZa3KHBHTQQCv0bkH8PQ2UMXtHw@mail.gmail.com>
Subject: Re: PATCH [3/n]: Add __snseconds_t and __SNSECONDS_T_TYPE
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Paul Eggert <eggert@cs.ucla.edu>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: GNU C Library <libc-alpha@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 3:05 PM, Paul Eggert <eggert@cs.ucla.edu> wrote:
> On 03/15/2012 01:57 PM, H.J. Lu wrote:
>> What is the real consequence of using long long on tv_nsec,
>> except for not POSIX compliant? Will it lead to wrong code?
>
> It would break applications that do anything like this:
>
>  struct timespec t;
>  long *p = &t->tv_nsec;
>
> Such applications work fine now and conform to POSIX, but would

GCC will complain about "incompatible pointer type".

> either not compile or (worse) might compile and do the
> wrong thing, if tv_nsec were wider than 'long'.

We had a discussion on Linux kernel mailing list:

https://lkml.org/lkml/2012/2/8/408

We thought it was OK to have long long on tv_nsec.

-- 
H.J.
