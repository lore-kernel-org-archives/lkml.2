Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab0KHVpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:45:00 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44901 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab0KHVo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:44:59 -0500
Date: Mon, 8 Nov 2010 16:33:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Pavel Roskin <proski@gnu.org>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc1 (libipw remove_proc_entry warning)
Message-ID: <20101108213343.GC2310@tuxdriver.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
 <20101103161837.fad11d79.randy.dunlap@oracle.com>
 <AANLkTimnHFHJq13xpJ0ZgLmpd+cHmHH5sQ4HWtL_MrMT@mail.gmail.com>
 <4CD48E04.2050709@oracle.com>
 <AANLkTik80AuVEefHwccB81WPdT4UPfTSjQdG-3Yq17e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik80AuVEefHwccB81WPdT4UPfTSjQdG-3Yq17e7@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 04:38:14PM -0700, Linus Torvalds wrote:
> On Fri, Nov 5, 2010 at 4:06 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On 11/05/10 15:24, Linus Torvalds wrote:
> >>
> >> Totally UNTESTED patch attached. It may or may not compile. And maybe
> >> it doesn't catch all cases, but it should catch the obvious ones.
> >
> > That works for me.
> >
> > Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Goodie. Pavel, John - feel free to add my sign-off on that patch. Make
> up a relevant commit message. Ok?

In the queue...

commit 269e2d77b82d92d8dad543a2375e74372e9d773e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Nov 8 16:27:12 2010 -0500

    libipw: fix proc entry removal
    
    This bug seems to be due to commit 27ae60f8f7aac ("ipw2x00: replace
    "ieee80211" with "libipw" where appropriate"), where Pavel did this:
    
    -       libipw_proc = proc_mkdir(DRV_NAME, init_net.proc_net);
    +       libipw_proc = proc_mkdir("ieee80211", init_net.proc_net);
    
    but then the cleanup was kept as
    
            remove_proc_entry(DRV_NAME, init_net.proc_net);
    
    in both places (both in the failure case and in the unload case). The
    error string is also total crap, and says
    
         "Unable to create " DRV_NAME " proc directory\n");
    
    Even though it doesn't actually create a proc directory named DRV_NAME at all.
    
    So that patch looks like total and utter crap to me. The commit message says
    
      "Keep /proc/net/ieee80211 under the original name to avoid breaking user
        interface."
    
    but the thing is, it really didn't fix anything but that one create
    thing. It needs to fix all the other cases too.
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Sorry for the delay -- I'm not a good traveler!
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
