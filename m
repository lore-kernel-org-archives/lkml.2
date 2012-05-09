Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab2EIStP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab2EIStN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:49:13 -0400
Date: Wed, 9 May 2012 14:49:09 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: vfs: INFO: possible circular locking dependency detected
Message-ID: <20120509184909.GA27705@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1336577114.3638.23.camel@lappy>
 <20120509161203.GK22082@ZenIV.linux.org.uk>
 <CA+1xoqdEFOBPSng99jFcgj9Un9ZguXqKhXYdDCeKv3k5nLrC6Q@mail.gmail.com>
 <20120509162854.GM22082@ZenIV.linux.org.uk>
 <20120509163732.GN22082@ZenIV.linux.org.uk>
 <CA+1xoqf=fDqJq1ks=fo9B27nGrAEVGArYSddmX49Otxw+jpKJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1xoqf=fDqJq1ks=fo9B27nGrAEVGArYSddmX49Otxw+jpKJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 07:13:29PM +0200, Sasha Levin wrote:
 > On Wed, May 9, 2012 at 6:37 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
 > > If that's _all_ that happened, I'm not particulary
 > > concerned; it's not pretty, but saying "thou shalt not grab ->cred_guard_mutex
 > > anywhere in ->read() on anything that has exec bits or might get one" is
 > > not too terrible.  If that's something else, though, we might have a real
 > > problem...
 > 
 > That's probably the case. The proc file got chmodded and exec'ed.
 > 
 > Can we do something to eliminate this false positive though? I can't
 > think of anything nice...
 > 
 > btw,
 > I've never seen this issue before, even though I run same tests for a
 > while now. What could have triggered it now?

Assuming you're running trinity du-jour, I only added fuzzing of execve yesterday.

	Dave

