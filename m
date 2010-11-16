Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934471Ab0KPNEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:04:04 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:36835 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283Ab0KPNEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:04:02 -0500
X-Spam-Processed: digidescorp.com, Tue, 16 Nov 2010 07:04:01 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1936c50a63=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] nommu: yield CPU periodically while disposing
 large VM
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@snapgear.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20101115204703.fc774a17.akpm@linux-foundation.org>
References: <1289507596-17613-1-git-send-email-steve@digidescorp.com>
	 <20101111184059.5744a42f.akpm@linux-foundation.org>
	 <1289831351.2524.15.camel@iscandar.digidescorp.com>
	 <20101115204703.fc774a17.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Digital Design Corporation
Date: Tue, 16 Nov 2010 07:03:57 -0600
Message-ID: <1289912637.3449.3.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 20:47 -0800, Andrew Morton wrote:
> On Mon, 15 Nov 2010 08:29:11 -0600 "Steven J. Magnani" <steve@digidescorp.com> wrote:
> 
> > As efficient as schedule() may be, it still scares me to call it on
> > reclaim of every block of memory allocated by a terminating process,
> > particularly on the relatively slow processors that inhabit NOMMU land.
> 
> This is cond_resched(), not schedule()!  cond_resched() is just a few
> instructions, except for the super-rare case where it calls schedule().

The light comes on..._cond_resched() is overloaded. I was looking at the
static version, which calls schedule(). The extern version is much more
lightweight.

I'll respin the patch.

Thanks,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



