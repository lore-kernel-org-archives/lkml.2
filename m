Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab2CPIT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:19:28 -0400
Received: from smtp.cs.ucla.edu ([131.179.128.62]:47837 "EHLO smtp.cs.ucla.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758132Ab2CPITP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:19:15 -0400
Message-ID: <4F62F786.2070907@cs.ucla.edu>
Date: Fri, 16 Mar 2012 01:19:18 -0700
From: Paul Eggert <eggert@cs.ucla.edu>
Organization: UCLA Computer Science Department
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        GNU C Library <libc-alpha@sourceware.org>
Subject: x32 and width of blksize_t, suseconds_t
References: <20120315192515.GA6585@intel.com> <20120315195000.7E3BE2C0A3@topped-with-meat.com> <CAMe9rOpXRcO6a4cFEU=s1Gjzzt87zvyzuLhAWupc2pOX6az6ig@mail.gmail.com> <4F625570.7050003@cs.ucla.edu> <CAMe9rOpvnhPmpmsLedmOjjYB9SghZiov-cOUi+wrYvKaP+c9pQ@mail.gmail.com> <4F6267B1.3090805@cs.ucla.edu> <CAMe9rOrRdj_ns=rkonB2BwgmZa3KHBHTQQCv0bkH8PQ2UMXtHw@mail.gmail.com> <4F62F152.1040909@cs.ucla.edu>
In-Reply-To: <4F62F152.1040909@cs.ucla.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Come to think of it, the proposed x32 patch may have issues
with blksize_t and suseconds_t as well.  POSIX says that an x32
implementation must support at least one programming environment
(presumably settable via a feature test macro) where blksize_t
and suseconds_t are no wider than 'long'; see
<http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/sys_types.h.html>.
But if I understand things correctly, x32 glibc would
define these to be 'long long'.  This issue affects system
calls such as 'stat' and 'select'.
