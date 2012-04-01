Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2DAJo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 05:44:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59320 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2DAJo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 05:44:27 -0400
Date: Sun, 1 Apr 2012 11:44:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend core dump note section to contain file names of mapped files
Message-ID: <20120401094425.GQ17822@one.firstfloor.org>
References: <CAK1hOcPxVWDCTRLzH6X+88WXuw_Ywzbt+iAJ3QMEfxG22duk9g@mail.gmail.com> <20120401031329.GP17822@one.firstfloor.org> <4F77C972.2000200@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F77C972.2000200@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 08:20:18PM -0700, H. Peter Anvin wrote:
> On 03/31/2012 08:13 PM, Andi Kleen wrote:
> >> I propose to save this information in core dump, as a new note
> >> in note segment.
> > 
> > Seems like a good idea but rather than write complicated code i would just reuse
> > the /proc/*/maps code and dump it in that format?
> > 
> 
> Does /proc/*/maps handle oddball characters in filenames?

It doesn't handle new lines well, but then if someone does that they 
break all programs that parse maps for other reasons (and likely
a lot of other things too) anyways.

Other than that it should be ok: the file name is just the last component
on the line.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
