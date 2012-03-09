Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab2CISOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:14:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab2CISOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:14:17 -0500
Date: Fri, 9 Mar 2012 13:14:04 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 1/2] watchdog, hpwdt: Remove priority option for NMI
 callback
Message-ID: <20120309181404.GK24378@redhat.com>
References: <1331311044-1120-1-git-send-email-dzickus@redhat.com>
 <9774516974AF5F4C8A2C3C69CD34123320369D9C@G9W0755.americas.hpqcorp.net>
 <20120309171711.GI24378@redhat.com>
 <9774516974AF5F4C8A2C3C69CD34123320369E69@G9W0755.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9774516974AF5F4C8A2C3C69CD34123320369E69@G9W0755.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 05:28:15PM +0000, Mingarelli, Thomas wrote:
> Can I register for more than one type? Like NMI_UNKNOWN | NMI_DIE (or something like that)?

There are only two queues, NMI_LOCAL and NMI_UNKNOWN.  The difference is
NMI_LOCAL has handlers that can determine if they are the NMI source,
which is needed because _every_ handler is executed on every NMI.
NMI_UNKNOWN is reserved for handlers that just assume the NMI is theirs.

Cheers,
Don
